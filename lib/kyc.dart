import 'dart:convert';
import 'dart:io';
import 'package:epi/logIn.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KycPage extends StatefulWidget {
  const KycPage({super.key});
  @override
  _KycPageState createState() => _KycPageState();
}

class _KycPageState extends State<KycPage> {
  Map<String, File?> images = {
    'Adhaar Card (Front)': null,
    'Adhaar Card (Back)': null,
    'Bank Passbook': null,
    'Pan Card': null,
  };
  Map<String, TextEditingController> controllers = {};
  String username = '';
  String password = '';
  String userId = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    for (var key in images.keys) {
      controllers[key] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      password = prefs.getString('password') ?? '';
    });
    print("Loaded Username: $username, Password: $password"); // Debugging
  }


  Future<void> _submitKyc() async {
    if (images.values.any((image) => image == null)) {
      _showErrorDialog("Please select all images before submitting.");
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await _loginAndRetrieveUserId();
      if (userId.isEmpty) {
        _showErrorDialog("User ID could not be retrieved. Please log in again.");
        setState(() {
          isLoading = false;
        });
        return;
      }

      Dio dio = Dio();
      String url = "http://16.171.26.118/submit_kyc.php";

      FormData formData = FormData.fromMap({
        "User_id": userId,
        if (images["Adhaar Card (Front)"] != null)
          "adhaarfront": await MultipartFile.fromFile(images["Adhaar Card (Front)"]!.path),
        if (images["Adhaar Card (Back)"] != null)
          "adhaarback": await MultipartFile.fromFile(images["Adhaar Card (Back)"]!.path),
        if (images["Bank Passbook"] != null)
          "bankpassbook": await MultipartFile.fromFile(images["Bank Passbook"]!.path),
        if (images["Pan Card"] != null)
          "pancard": await MultipartFile.fromFile(images["Pan Card"]!.path),
      });

      Response response = await dio.post(url, data: formData);
      if (response.statusCode == 200) {
        print("Raw API Response: ${response.data}"); // Debugging

        var responseBody;
        if (response.data is String) {
          responseBody = jsonDecode(response.data); // Handle JSON String
        } else {
          responseBody = response.data; // Handle JSON Map
        }

        print("Parsed API Response: $responseBody"); // Debugging

        if (responseBody['status_code'] == 200) {
          _showSuccessDialog("KYC submitted successfully.");
        } else {
          _showErrorDialog("KYC submission failed: ${responseBody['msg']}");
        }
      }

      else {
        _showErrorDialog("Failed to submit KYC. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during KYC submission: $e"); // Debugging print
      _showErrorDialog("An error occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> _loginAndRetrieveUserId() async {
    try {
      String url = "http://16.171.26.118/user_login.php";
      Dio dio = Dio();

      // Debugging print: Check username and password before sending request
      print("Sending Login Request: Username = '$username', Password = '$password'");

      var data = {
        "Username": username.trim(),
        "Password": password.trim(),
      };

      Response response = await dio.post(url, data: FormData.fromMap(data));

      print("Login API Response: ${response.data}"); // Debugging

      var responseBody = response.data;

      if (responseBody['status_code'] == 200 && responseBody['data'] != null) {
        var userData = responseBody['data'][0];
        setState(() {
          userId = userData['id'].toString();
        });
        print("User ID retrieved: $userId"); // Debugging
      } else {
        print("Login Failed: ${responseBody['msg']}"); // Debugging
        throw Exception(responseBody['msg']);
      }
    } catch (e) {
      print("Error during login: $e"); // Debugging
      throw Exception("Error during login and user ID retrieval.");
    }
  }



  Future<void> _pickImage(String field, ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        images[field] = File(pickedFile.path);
        controllers[field]?.text = pickedFile.path;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"))
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => logIn()), // Navigate
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("KYC Verification")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...images.keys.map((key) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    controller: controllers[key],
                    readOnly: true,
                    onTap: () => _pickImage(key, ImageSource.gallery),
                    decoration: InputDecoration(
                      hintText: key,
                      label: const Text("File"),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.image),
                    ),
                  ),
                );
              }),
              // ...images.entries.map((entry) {
              //   return entry.value == null
              //       ? const Text("No image selected",
              //           style: TextStyle(fontSize: 20, color: Colors.red))
              //       : Image.file(entry.value!, height: 100, width: 100);
              // }).toList(),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 45),
                    backgroundColor: Colors.black),
                onPressed: isLoading ? null : _submitKyc,
                icon: const Icon(
                  Icons.domain_verification,
                  color: Colors.white,
                ),
                label: const Text(
                  "Verify",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              if (isLoading) const CircularProgressIndicator(),
    const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 45),
                    backgroundColor: Colors.black),
                onPressed:(){Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => logIn()), // Navigate
    );}
                ,icon: const Icon(
                  Icons.skip_next,
                  color: Colors.white,
                ),
                label: const Text(
                  "Skip",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}