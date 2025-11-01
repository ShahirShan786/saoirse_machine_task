import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:epi/kyc.dart';
import 'dart:math'; // For random number generation
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Startup3 extends StatefulWidget {
  const Startup3({super.key});

  @override
  State<Startup3> createState() => _Startup3State();
}

class _Startup3State extends State<Startup3> {
  String username = "null";  // Default value 'null' if empty
  String email = "null";     // Default value 'null' if empty
  String password = "null";  // Default value 'null' if empty
  String Referd_by = "null"; // Default value 'null' if empty
  bool _isPasswordVisible = false;

  final _formKey = GlobalKey<FormState>(); // Added form key for validation

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Load data from SharedPreferences and set default text as 'null' if empty
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "null";
      email = prefs.getString('email') ?? "null";
      password = prefs.getString('password') ?? "null";
      Referd_by = prefs.getString('Referd_by') ?? "null"; // Referral code can be empty
    });
  }

  // Function to generate a random referral code
  String generateReferralCode() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    String referralCode = '';
    for (int i = 0; i < 6; i++) {
      referralCode += characters[random.nextInt(characters.length)];
    }
    return referralCode;
  }
  Future<void> submit() async {
    String newReferralCode = generateReferralCode(); // Generate referral code

    // Log the values before submitting
    print("Submitting with the following data:");
    print("Username: $username");
    print("Email: $email");
    print("Password: $password");
    print("Referral Code: $Referd_by");

    // Check if fields are empty
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    var uri = Uri.parse("http://16.171.26.118/user_register.php");

    var request = http.MultipartRequest("POST", uri);
    request.fields['Username'] = username;
    request.fields['Email'] = email;
    request.fields['Password'] = password;
    request.fields['Referd_by'] = Referd_by.isEmpty ? "NoReferral" : Referd_by;
    request.fields['new_referal_code'] = newReferralCode;

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      // Debugging
      print("Response Body: $responseBody");

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(responseBody);
        if (decodedResponse['status_code'] == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decodedResponse['msg'])),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const KycPage(),
            ),
          );
        } else if (decodedResponse['status_code'] == 409) {
          _showErrorDialog(message: "Username already exists. Please choose a different username.");
        } else {
          _showErrorDialog(message: "Error: ${decodedResponse['msg']}");
        }
      } else {
        _showErrorDialog(message: "HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      _showErrorDialog(message: "Submission Error: $e");
    }
  }

  // Function to show error dialog
  void _showErrorDialog({String message = "An error occurred. Please try again."}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueGrey,
        title: const Text("Registration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,  // Added form key for validation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Username: $username"),
                    Text("Email: $email"),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            obscureText: !_isPasswordVisible,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            controller: TextEditingController(text: password),
                            readOnly: true, // Set read-only if necessary
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ],
                    ),
                    Text("Referral Code: $Referd_by"),
                    // Display the generated referral code if you wish to show it to the user
                    const SizedBox(height: 10),
                    Text("Generated Referral Code: ${generateReferralCode()}"),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    submit();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KycPage(),
                      ),
                    );
                  }
                },
                child: const Text("Finish Registration"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

