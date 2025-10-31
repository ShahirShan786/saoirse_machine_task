import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'Bottom_NavigationPage.dart';
import 'api_service/api_endpoint.dart';
import 'data/user_model/user_data.dart';
import 'locator/app_db.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String firebaseUid, email, name, profilePic;
  final String? phoneNumber;

  const CompleteProfileScreen({
    super.key,
    required this.email,
    required this.firebaseUid,
    required this.name,
    this.phoneNumber,
    required this.profilePic,
  });

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  late TextEditingController unameController;
  late TextEditingController phoneController;
  late TextEditingController referralCodeController;
  void _updateSystemUIOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Color(0xff013263),
          statusBarIconBrightness: Brightness.light,
        ),
      );
    });
  }

  // Global key to manage the form state
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _updateSystemUIOverlay();
    unameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phoneNumber);
    referralCodeController = TextEditingController();
  }

  Future<void> getUserDetail(String userId) async {
    String url = '${APIEndPoints.baseUrl}api/auth/profile/$userId';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      debugPrint("response status code : ${response.statusCode}");
      debugPrint("response body : ${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        try {
          appDB.user = UserData.fromJson(data);
          appDB.isLogin = true;
          debugPrint("NOW HIVE DB ${appDB.user.name}");
          debugPrint("NOW HIVE DB ${appDB.user.id}");
          debugPrint("NOW HIVE DB ${appDB.user.firebaseUid}");
          debugPrint("NOW HIVE DB ${appDB.user.phoneNumber}");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const BottomNavigationPage()),
          );
        } catch (e, s) {
          debugPrint("Stack :$s");
        }
      }
    } catch (e, s) {
      debugPrint("Error : $e");
      debugPrint("stackTrace: $s");
    }
  }

  // Function to save data to SharedPreferences
  Future<void> saveData() async {
    String url = '${APIEndPoints.baseUrl}api/auth/signup';
    Map<String, String> mappedBodyData = {
      "firebaseUid": widget.firebaseUid.toString(),
      "email": widget.email.toString(),
      "name": unameController.text.toString(),
      "phoneNumber": "+91${phoneController.text.toString()}",
      "profilePicture": widget.profilePic,
      "referredByCode": referralCodeController.text.toString(),
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(mappedBodyData),
      );
      debugPrint("response status code : ${response.statusCode}");
      debugPrint("response body : ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['user'] != null) {
          getUserDetail(data['user']);
        } else {
          showError(data['message']);
        }
      } else {
        showError("Status code: ${response.statusCode}");
      }
    } catch (e, s) {
      showError("Internet error!");
      debugPrint("error : $e");
      debugPrint("stack : $s");
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(
        top: 15,
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
              preferredSize: Size(double.infinity, 10), child: Row()),
          centerTitle: true,
          backgroundColor: Color(0xff013263),
          title: Text("Add Your details"),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: "Roboto",
            color: Colors.white,
          ),
          leadingWidth: 60,
          toolbarHeight: 40,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20)
              .copyWith(top: 40, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.profilePic),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      "Enter name",
                      style: TextStyle(
                        color: Color(0xff5e5e5e),
                        fontFamily: "Roboto",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: unameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        if (value.length < 3) {
                          return 'Username must contain at least 3 characters';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffd9d9d9)),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffd9d9d9)),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffd9d9d9)),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        hintText: "Enter Name",
                        hintStyle: TextStyle(
                          color: Color(0xff5e5e5e).withValues(alpha: 0.40),
                          fontFamily: "Roboto",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Phone number",
                      style: TextStyle(
                        color: Color(0xff5e5e5e),
                        fontFamily: "Roboto",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: phoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'phone number is required';
                        }
                        if (value.length < 10) {
                          return 'please enter valid 10 digit phone NUmber';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 10,
                      decoration: InputDecoration(
                        counterText: "",
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffd9d9d9)),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffd9d9d9)),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffd9d9d9)),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        isDense: true,
                        prefixIconConstraints: BoxConstraints(
                            minHeight: 0, minWidth: 40, maxWidth: 40),
                        prefixIcon: Text(
                          "  +91",
                          style: TextStyle(
                            color: Color(0xff5e5e5e).withValues(alpha: 0.40),
                            fontFamily: "Roboto",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        hintText: "0123456789",
                        hintStyle: TextStyle(
                          color: Color(0xff5e5e5e).withValues(alpha: 0.40),
                          fontFamily: "Roboto",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Referral Id (Optional)",
                      style: TextStyle(
                        color: Color(0xff5e5e5e),
                        fontFamily: "Roboto",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: referralCodeController,
                      validator: (value) {
                        return null;
                      
                        // if (value != null) {
                        //   if (value.length < 8) {
                        //     return 'please enter valid referral code.';
                        //   }
                        // }
                        // return null;
                      },
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      maxLength: 8,
                      decoration: InputDecoration(
                        counterText: "",
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffd9d9d9)),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffd9d9d9)),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffd9d9d9)),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        hintText: "XXXX XXXX",
                        hintStyle: TextStyle(
                          color: Color(0xff5e5e5e).withValues(alpha: 0.40),
                          fontFamily: "Roboto",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    /*const SizedBox(
                      height: 50,
                    ),*/
                    /*  const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    )*/
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ).copyWith(bottom: 20),
            child: ElevatedButton(
              onPressed: () async {
                // Validate the form before saving the data
                if (_formKey.currentState?.validate() ?? false) {
                  // If form is valid, save the data and navigate
                  await saveData();
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(double.maxFinite, 50),
                backgroundColor: Color(0xff013263),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
              ),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
