import 'dart:convert';

import 'package:epi/Bottom_NavigationPage.dart';
import 'package:epi/Forgot_Password.dart';
import 'package:epi/data/user_model/user_data.dart';
import 'package:epi/locator/app_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'api_service/api_endpoint.dart';
import 'api_service/auth_service.dart';

// ignore: camel_case_types
class logIn extends StatefulWidget {
  const logIn({super.key});

  @override
  State<logIn> createState() => _logInState();
}

// ignore: camel_case_types
class _logInState extends State<logIn> {
  // Declare the GlobalKey inside the state class to ensure uniqueness
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  // State variables
  bool termsAccepted = false;
  bool isLoading = false;
  bool eye = true;
  var privacyPolicyUrl = Uri.https("epielio.com", "/privacy/");
  late String email, profilePic, name, firebaseUid, phoneNumber;

  // TextEditingControllers
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  void _updateSystemUIOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    });
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
            MaterialPageRoute(builder: (context) => const BottomNavigationPage()),
          );
        } catch (e, s) {
          debugPrint("error :$e");
          debugPrint("Stack :$s");
        }
      }

    } catch (e, s) {
      debugPrint("Error : $e");
      debugPrint("stackTrace: $s");
    }
  }

  Future<void> checkUser() async {
    String url = '${APIEndPoints.baseUrl}api/auth/checkUserExists';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'email': email}),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint("response status code : ${response.statusCode}");
      debugPrint("response body : ${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exists'] == true) {

          getUserDetail(data['userId']);

          //Store in local DB
          debugPrint("USER TYPE ${data["user"].runtimeType}");

          try {} catch (e, s) {
            debugPrint("EXCEPTION IN HIVE $e");
            debugPrint("Stack IN HIVE $s");
          }
        } else {
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => CompleteProfileScreen(
          //       email: email,
          //       firebaseUid: firebaseUid,
          //       name: name,
          //       profilePic: profilePic,
          //       phoneNumber: phoneNumber,
          //     ),
          //   ),
          // );
        }
      } else {
        showError("Status code: ${response.statusCode}");
      }
    } catch (e, s) {
      showError("error : $e");
      debugPrint("error : $s, ");
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
  void initState() {
    super.initState();

    _updateSystemUIOverlay();
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: Duration(
                seconds: 3,
              ),
              alignment: Alignment.center,
              // curve: Curves.easeOutCirc,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/image/logo.png",
                    scale: 4,
                    alignment: Alignment.center,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40,
                    ).copyWith(top: 30),
                    child: Text(
                      "Invest small, Dream big, Own it!",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 28,
                        color: Color(0xff12111f),
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
          /*Text(
            "Your details",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              fontFamily: "Roboto",
              color: Color(0xff101010),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Please provide your name and email.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              fontFamily: "Roboto",
              color: Color(0xff5e5e5e),
            ),
          ),*/
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            child: GestureDetector(
              // onTap: googleSignIn,
              onTap: () {
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (context) => CompleteProfileScreen(
                //       firebaseUid: "wdvevfwev",
                //       profilePic:
                //           "https://lh3.googleusercontent.com/a/ACg8ocI9rbL2GvDtLzcpAvf7IY6wH5jpLxOak-NVKq7IDBHdm8V63A=s96-c",
                //       email: "demo@mail.com",
                //       name: "demo",
                //       phoneNumber: "1234567890",
                //     ),
                //   ),
                // );
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xff013263),
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  border: Border.all(
                    color: Color(0xff5e5e5e),
                    style: BorderStyle.solid,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 15,
                    children: [
                      Image.asset(
                        "assets/image/google_logo.png",
                        scale: 3,
                      ),
                      Text(
                        "Sign in with Google",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Roboto",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: RichText(
              text: TextSpan(
                text: "By Signing up you agree to EPI Elio's ",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff828282),
                ),
                children: [
                  TextSpan(
                    text: "Terms & Conditions ",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff013263),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        if (await canLaunchUrl(privacyPolicyUrl)) {
                          await launchUrl(privacyPolicyUrl);
                        } else {
                          throw ("can't launch url");
                        }
                      },
                  ),
                  TextSpan(
                    text: "and",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff828282),
                    ),
                  ),
                  TextSpan(
                    text: " Privacy Policy",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff013263),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        if (await canLaunchUrl(privacyPolicyUrl)) {
                          await launchUrl(privacyPolicyUrl);
                        } else {
                          throw ("can't launch url");
                        }
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Copyright | Version 2.1",
                  style: TextStyle(
                    color: Color(0xff5e5e5e),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto",
                  ),
                )
              ],
            ),
          )
        ],
      )

      /*Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "LOG IN",
                    style: TextStyle(
                        fontFamily: "font",
                        fontSize: 25,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  suffixIcon: const Icon(Icons.person),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'Username',
                ),
                controller: username,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a username.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        eye = !eye;
                      });
                    },
                    icon: eye
                        ? Image.asset(
                            "assets/icon/hide.png",
                            scale: 25,
                          )
                        : Image.asset(
                            "assets/icon/view.png",
                            scale: 25,
                          ),
                  ),
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'Password',
                ),
                controller: password,
                obscureText: eye, // Hide the password text
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a password.";
                  }
                  if (value.length < 6) {
                    return "Password should be at least 6 characters.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              */ /* ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (formkey.currentState!.validate()) {
                          Submit();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(double.maxFinite, 50),
                  backgroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Log In",
                        style: TextStyle(color: Colors.white),
                      ),
              ),*/ /*
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: GestureDetector(
                  onTap: googleSignIn,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                      border: Border.all(
                        color: Color(0xff5e5e5e),
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 15,
                        children: [
                          Image.asset(
                            "assets/image/google_logo.png",
                            scale: 3,
                          ),
                          Text(
                            "Sign in with Google",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              */ /*Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      _showTermsAndConditionsPopup();
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),*/ /*
            ],
          ),
        ),
      )*/
      ,
    );
  }

  Future<void> googleSignIn() async {
    setState(() {
      isLoading = true;
    });
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      email = user.email ?? "";
      name = user.displayName ?? "";
      profilePic = user.photoURL ?? "";
      phoneNumber = user.phoneNumber ?? "";
      firebaseUid = user.uid;
      debugPrint(
          " email : ${user.email}  ,user details : uID : ${user.uid},name : ${user.displayName} verified Email:${user.emailVerified} photo url:${user.photoURL}, :${user.tenantId}");
      checkUser();
    } else {
      _showErrorDialog("An error occurred. Please try again later.");
    }
    setState(() {
      isLoading = false;
    });
  }

  // ignore: non_constant_identifier_names
  //login
  Future<void> Submit() async {
    setState(() {
      isLoading = true;
    });

    // ignore: non_constant_identifier_names
    var APIURL = "http://16.171.26.118/user_login.php";

    Map<String, String> mappedData = {
      'Username': username.text.trim(),
      'Password': password.text.trim(),
    };

    try {
      http.Response response = await http.post(
        Uri.parse(APIURL),
        body: mappedData,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData['status_code'] == 200 &&
            jsonData['data'] != null &&
            jsonData['data'].isNotEmpty) {
          var userData = jsonData['data'][0];

          // Save user ID in SharedPreferences
          // final SharedPreferences prefs = await SharedPreferences.getInstance();
          // prefs.setString('id', userData['id'].toString());
          // Retrieve the user ID

          // Navigate to the home page
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                builder: (context) => const BottomNavigationPage()),
          );
        } else {
          _showErrorDialog("Invalid username or password.");
        }
      } else {
        _showErrorDialog("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      _showErrorDialog("An error occurred. Please try again later.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // void _showErrorDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.white,
  //         title: const Text(
  //           "Login Failed",
  //           style: TextStyle(fontFamily: "font", fontSize: 25),
  //         ),
  //         content: Text(message),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text(
  //               "OK",
  //               style: TextStyle(
  //                 fontFamily: "font",
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Login Failed",
            style: TextStyle(fontFamily: "font", fontSize: 25),
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  fontFamily: "font",
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _navigateToForgotPassword(); // Navigate to Forgot Password screen
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  fontFamily: "font",
                  color: Colors.red, // Highlight the button
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// Function to navigate to the forgot password screen
  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const ForgotPassword()), // Replace with your actual Forgot Password screen
    );
  }

  void _showTermsAndConditionsPopup() {
    bool showMoreDetails = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                "Terms and Conditions",
                style: TextStyle(fontFamily: "font", fontSize: 25),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "By creating an account, you agree to our Terms and Conditions.",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          overflow: TextOverflow.clip),
                    ),
                    if (showMoreDetails)
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Terms and Conditions for Elio e-Com APK\n\n"
                          "Effective Date: [Insert Date]\n\n"
                          "These Terms and Conditions (\"Agreement\") govern your download, installation, and use of the Elio e-Com APK (\"App\"). By accessing or using the App, you agree to be bound by this Agreement. If you do not agree to these terms, do not use the App.\n\n"
                          "1. Ownership\n\n"
                          "1.1. The App is developed and owned by Saoirse IT Solutions LLP.\n"
                          "1.2. All intellectual property rights related to the App, including logos, trademarks, and content, remain the exclusive property of Saoirse IT Solutions LLP.\n\n"
                          "2. License to Use\n\n"
                          "2.1. You are granted a limited, non-exclusive, non-transferable, and revocable license to use the App for personal purposes.\n"
                          "2.2. You may not:\n"
                          "    - Modify, copy, or distribute the App.\n"
                          "    - Use the App for commercial purposes without authorization.\n\n"
                          "3. Privacy and Data Protection\n\n"
                          "3.1. Your data will be handled in accordance with our Privacy Policy.\n"
                          "3.2. By using the App, you consent to the collection and use of your personal data as described in the Privacy Policy.\n\n"
                          "4. Security and Misuse\n\n"
                          "4.1. You agree not to misuse our services or attempt to compromise their security.\n"
                          "4.2. The company reserves the right to take action if security is breached or misuse is detected.\n\n"
                          "5. Modification of Terms\n\n"
                          "5.1. The company reserves the right to modify these terms at any time.\n"
                          "5.2. Any changes to the terms will be effective immediately upon posting the updated terms on the App or on the website.\n\n"
                          "6. Contact Information\n\n"
                          "6.1. If you have any questions regarding these Terms and Conditions, please contact us at support@eliotechno.com.\n\n"
                          "Privacy Policy for EPI APK\n\n"
                          "Effective Date: [Insert Date]\n\n"
                          "This Privacy Policy governs the collection, use, and sharing of personal information by the Easy Purchase Investment (EPI) APK, an initiative of Elio e-Com, a subsidiary of Saoirse IT Solutions LLP. By using the EPI APK (\"App\"), you agree to the practices described in this Privacy Policy. If you do not agree to this policy, please do not use the App.\n\n"
                          "1. Information We Collect\n\n"
                          "1.1. Personal Information\n"
                          "We collect personal information from users when they register, use the App, or engage with EPI services:\n"
                          "  - Full name\n"
                          "  - Email address\n"
                          "  - Phone number\n"
                          "  - Government-issued ID details (e.g., Aadhaar, PAN)\n"
                          "  - Residential address\n\n"
                          "1.2. Financial Information\n"
                          "Payment details such as UPI, credit/debit card, or bank account information for processing transactions related to the EPI scheme.\n\n"
                          "1.3. Usage Information\n"
                          "We may collect information about your interactions with the App, including:\n"
                          "  - Transaction history\n"
                          "  - App usage patterns and preferences\n"
                          "  - Referrals and commission tracking\n\n"
                          "1.4. Device Information\n"
                          "  - IP address\n"
                          "  - Device type, model, and operating system version\n"
                          "  - App version and crash logs\n\n"
                          "2. How We Use Your Information\n\n"
                          "We use the information collected for the following purposes:\n"
                          "  - To register and manage your EPI account.\n"
                          "  - To process your payments and investments for the EPI scheme.\n"
                          "  - To deliver products upon successful scheme completion.\n"
                          "  - To send you notifications about your investment progress, rewards, and any important updates related to the scheme.\n"
                          "  - To respond to your customer service inquiries.\n"
                          "  - To improve the functionality and user experience of the App.\n"
                          "  - To comply with legal, regulatory, and security obligations.\n\n"
                          "3. Sharing Your Information\n\n"
                          "3.1. With Service Providers\n"
                          "We may share your information with trusted third-party vendors and service providers to assist us in processing payments, managing products, or providing support services.\n\n"
                          "3.2. Legal and Regulatory Requirements\n"
                          "We may disclose your information when required by law, such as complying with a subpoena, court order, or other legal process, or when necessary to protect our rights and the safety of others.\n\n"
                          "3.3. Business Transfers\n"
                          "In the event of a merger, acquisition, or sale of assets, your personal information may be transferred to the new entity, and you will be notified via the App or email.\n\n"
                          "4. Data Security\n\n"
                          "4.1. We implement technical, administrative, and physical safeguards to protect your personal information.\n"
                          "4.2. While we take reasonable measures to protect your data, no method of electronic transmission or storage is entirely secure, and we cannot guarantee 100% security.\n\n"
                          "5. Retention of Information\n\n"
                          "5.1. We retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required by law.\n"
                          "5.2. After the retention period, your personal information will be securely deleted or anonymized.\n\n"
                          "6. User Rights\n\n"
                          "6.1. Access and Correction: You have the right to access and update your personal information through your EPI account.\n"
                          "6.2. Data Deletion: You may request the deletion of your account and personal data, subject to any legal or contractual obligations.\n"
                          "6.3. Opt-Out of Marketing: You can opt-out of receiving marketing communications at any time by changing your communication preferences within the App or contacting us directly.\n\n"
                          "7. Cookies and Tracking Technologies\n\n"
                          "7.1. We may use cookies, web beacons, and similar technologies to enhance your experience, analyze usage patterns, and improve the App's functionality.\n"
                          "7.2. You can manage your cookie preferences by adjusting your browser or device settings.\n\n"
                          "8. Third-Party Links\n\n"
                          "The App may contain links to third-party websites or services. This Privacy Policy applies only to the EPI APK, and we are not responsible for the privacy practices of third-party websites. We encourage you to review their privacy policies before providing any personal information.\n\n"
                          "9. Changes to This Privacy Policy\n\n"
                          "We may update this Privacy Policy from time to time to reflect changes in our practices or legal requirements.\n"
                          "Any changes will be posted within the App or communicated through email.\n"
                          "We encourage you to periodically review this policy to stay informed about how we are protecting your information.\n\n"
                          "10. Contact Us\n\n"
                          "For any questions or concerns regarding this Privacy Policy, or to exercise your rights regarding your personal data, please contact us at:\n"
                          "Email: [Insert Email Address]\n"
                          "Phone: [Insert Phone Number]\n"
                          "Website: [Insert Website URL]\n\n"
                          "By using the EPI APK, you consent to the practices described in this Privacy Policy. Please ensure you review this policy periodically for updates.",
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showMoreDetails = !showMoreDetails;
                        });
                      },
                      child: Text(
                        showMoreDetails
                            ? "Show Less Details"
                            : "Read Full Details",
                        style: const TextStyle(color: Colors.deepPurpleAccent),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: termsAccepted,
                          onChanged: (value) {
                            setState(() {
                              termsAccepted = value!;
                            });
                          },
                        ),
                        // ignore: prefer_const_constructors
                        SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "I agree to the Terms and Conditions.",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black, fontFamily: "font"),
                  ),
                ),
                ElevatedButton(
                  onPressed: termsAccepted
                      ? () {
                          Navigator.of(context).pop();
                          /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CompleteProfileScreen()),
                          );*/
                        }
                      : null,
                  child: const Text(
                    "Agree",
                    style: TextStyle(color: Colors.black, fontFamily: "font"),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/*
import 'dart:convert';

import 'package:epi/Bottom_NavigationPage.dart';
import 'package:epi/Forgot_Password.dart';
import 'package:epi/Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api_service/api_endpoint.dart';
import 'api_service/auth_service.dart';

// ignore: camel_case_types
class logIn extends StatefulWidget {
  const logIn({super.key});

  @override
  State<logIn> createState() => _logInState();
}

// ignore: camel_case_types
class _logInState extends State<logIn> {
  // Declare the GlobalKey inside the state class to ensure uniqueness
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  // State variables
  bool termsAccepted = false;
  bool isLoading = false;
  bool eye = true;
  var privacyPolicyUrl = Uri.https("epielio.com", "/privacy/");
  late String email, profilePic, name, firebaseUid, phoneNumber;

  // TextEditingControllers
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  void _updateSystemUIOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    });
  }

  Future<void> checkUser() async {
    String url = '${APIEndPoints.baseUrl}api/auth/checkUserExists';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'email': email}),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint("response status code : ${response.statusCode}");
      debugPrint("response body : ${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exists'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const BottomNavigationPage()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CompleteProfileScreen(
                email: email,
                firebaseUid: firebaseUid,
                name: name,
                profilePic: profilePic,
                phoneNumber: phoneNumber,
              ),
            ),
          );
        }
      } else {
        showError("Status code: ${response.statusCode}");
      }
    } catch (e, s) {
      showError("error : $e");
      debugPrint("error : $s, ");
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
  void initState() {
    super.initState();

    _updateSystemUIOverlay();
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: Duration(
                seconds: 3,
              ),
              alignment: Alignment.center,
              // curve: Curves.easeOutCirc,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/image/logo.png",
                    scale: 4,
                    alignment: Alignment.center,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40,
                    ).copyWith(top: 30),
                    child: Text(
                      "Invest small, Dream big, Own it!",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 28,
                        color: Color(0xff12111f),
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
          */
/*Text(
            "Your details",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              fontFamily: "Roboto",
              color: Color(0xff101010),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Please provide your name and email.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              fontFamily: "Roboto",
              color: Color(0xff5e5e5e),
            ),
          ),*/ /*

          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            child: GestureDetector(
              // onTap: googleSignIn,
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationPage(
                      navigateIndex: 0,
                    ),
                  ),
                );
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xff013263),
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  border: Border.all(
                    color: Color(0xff5e5e5e),
                    style: BorderStyle.solid,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 15,
                    children: [
                      Image.asset(
                        "assets/image/google_logo.png",
                        scale: 3,
                      ),
                      Text(
                        "Sign in with Google",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Roboto",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: RichText(
              text: TextSpan(
                text: "By Signing up you agree to EPI Elio's ",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff828282),
                ),
                children: [
                  TextSpan(
                    text: "Terms & Conditions ",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff013263),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        if (await canLaunchUrl(privacyPolicyUrl)) {
                          await launchUrl(privacyPolicyUrl);
                        } else {
                          throw ("can't launch url");
                        }
                      },
                  ),
                  TextSpan(
                    text: "and",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff828282),
                    ),
                  ),
                  TextSpan(
                    text: " Privacy Policy",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff013263),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        if (await canLaunchUrl(privacyPolicyUrl)) {
                          await launchUrl(privacyPolicyUrl);
                        } else {
                          throw ("can't launch url");
                        }
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Copyright | Version 2.1",
                  style: TextStyle(
                    color: Color(0xff5e5e5e),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto",
                  ),
                )
              ],
            ),
          )
        ],
      )

      */
/*Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "LOG IN",
                    style: TextStyle(
                        fontFamily: "font",
                        fontSize: 25,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  suffixIcon: const Icon(Icons.person),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'Username',
                ),
                controller: username,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a username.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        eye = !eye;
                      });
                    },
                    icon: eye
                        ? Image.asset(
                            "assets/icon/hide.png",
                            scale: 25,
                          )
                        : Image.asset(
                            "assets/icon/view.png",
                            scale: 25,
                          ),
                  ),
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'Password',
                ),
                controller: password,
                obscureText: eye, // Hide the password text
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a password.";
                  }
                  if (value.length < 6) {
                    return "Password should be at least 6 characters.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              */ /*
 */
/* ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (formkey.currentState!.validate()) {
                          Submit();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(double.maxFinite, 50),
                  backgroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Log In",
                        style: TextStyle(color: Colors.white),
                      ),
              ),*/ /*
 */
/*
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: GestureDetector(
                  onTap: googleSignIn,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                      border: Border.all(
                        color: Color(0xff5e5e5e),
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 15,
                        children: [
                          Image.asset(
                            "assets/image/google_logo.png",
                            scale: 3,
                          ),
                          Text(
                            "Sign in with Google",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              */ /*
 */
/*Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      _showTermsAndConditionsPopup();
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),*/ /*
 */
/*
            ],
          ),
        ),
      )*/ /*

      ,
    );
  }

  Future<void> googleSignIn() async {
    setState(() {
      isLoading = true;
    });
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      // Save user ID in SharedPreferences

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // Retrieve the user ID
      await prefs.setString('id', user.uid);
      await prefs.setString('name', user.displayName ?? "No name");
      await prefs.setString('email', user.email ?? "No email");

      email = user.email ?? "";
      name = user.displayName ?? "";
      profilePic = user.photoURL ?? "";
      phoneNumber = user.phoneNumber ?? "";
      firebaseUid = user.uid;
      debugPrint(
          " email : ${user.email}  ,user details : uID : ${user.uid},name : ${user.displayName} verified Email:${user.emailVerified} photo url:${user.photoURL}, :${user.tenantId}");
      prefs.setBool('isFirstTime', false);
      checkUser();
    } else {
      _showErrorDialog("An error occurred. Please try again later.");
    }
    setState(() {
      isLoading = false;
    });
  }

  // ignore: non_constant_identifier_names
  //login
  Future<void> Submit() async {
    setState(() {
      isLoading = true;
    });

    // ignore: non_constant_identifier_names
    var APIURL = "http://16.171.26.118/user_login.php";

    Map<String, String> mappedData = {
      'Username': username.text.trim(),
      'Password': password.text.trim(),
    };

    try {
      http.Response response = await http.post(
        Uri.parse(APIURL),
        body: mappedData,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData['status_code'] == 200 &&
            jsonData['data'] != null &&
            jsonData['data'].isNotEmpty) {
          var userData = jsonData['data'][0];

          // Save user ID in SharedPreferences
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('id', userData['id'].toString());
          // Retrieve the user ID

          // Navigate to the home page
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                builder: (context) => const BottomNavigationPage()),
          );
        } else {
          _showErrorDialog("Invalid username or password.");
        }
      } else {
        _showErrorDialog("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      _showErrorDialog("An error occurred. Please try again later.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // void _showErrorDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.white,
  //         title: const Text(
  //           "Login Failed",
  //           style: TextStyle(fontFamily: "font", fontSize: 25),
  //         ),
  //         content: Text(message),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text(
  //               "OK",
  //               style: TextStyle(
  //                 fontFamily: "font",
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Login Failed",
            style: TextStyle(fontFamily: "font", fontSize: 25),
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  fontFamily: "font",
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _navigateToForgotPassword(); // Navigate to Forgot Password screen
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  fontFamily: "font",
                  color: Colors.red, // Highlight the button
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// Function to navigate to the forgot password screen
  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const ForgotPassword()), // Replace with your actual Forgot Password screen
    );
  }

  void _showTermsAndConditionsPopup() {
    bool showMoreDetails = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                "Terms and Conditions",
                style: TextStyle(fontFamily: "font", fontSize: 25),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "By creating an account, you agree to our Terms and Conditions.",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          overflow: TextOverflow.clip),
                    ),
                    if (showMoreDetails)
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Terms and Conditions for Elio e-Com APK\n\n"
                          "Effective Date: [Insert Date]\n\n"
                          "These Terms and Conditions (\"Agreement\") govern your download, installation, and use of the Elio e-Com APK (\"App\"). By accessing or using the App, you agree to be bound by this Agreement. If you do not agree to these terms, do not use the App.\n\n"
                          "1. Ownership\n\n"
                          "1.1. The App is developed and owned by Saoirse IT Solutions LLP.\n"
                          "1.2. All intellectual property rights related to the App, including logos, trademarks, and content, remain the exclusive property of Saoirse IT Solutions LLP.\n\n"
                          "2. License to Use\n\n"
                          "2.1. You are granted a limited, non-exclusive, non-transferable, and revocable license to use the App for personal purposes.\n"
                          "2.2. You may not:\n"
                          "    - Modify, copy, or distribute the App.\n"
                          "    - Use the App for commercial purposes without authorization.\n\n"
                          "3. Privacy and Data Protection\n\n"
                          "3.1. Your data will be handled in accordance with our Privacy Policy.\n"
                          "3.2. By using the App, you consent to the collection and use of your personal data as described in the Privacy Policy.\n\n"
                          "4. Security and Misuse\n\n"
                          "4.1. You agree not to misuse our services or attempt to compromise their security.\n"
                          "4.2. The company reserves the right to take action if security is breached or misuse is detected.\n\n"
                          "5. Modification of Terms\n\n"
                          "5.1. The company reserves the right to modify these terms at any time.\n"
                          "5.2. Any changes to the terms will be effective immediately upon posting the updated terms on the App or on the website.\n\n"
                          "6. Contact Information\n\n"
                          "6.1. If you have any questions regarding these Terms and Conditions, please contact us at support@eliotechno.com.\n\n"
                          "Privacy Policy for EPI APK\n\n"
                          "Effective Date: [Insert Date]\n\n"
                          "This Privacy Policy governs the collection, use, and sharing of personal information by the Easy Purchase Investment (EPI) APK, an initiative of Elio e-Com, a subsidiary of Saoirse IT Solutions LLP. By using the EPI APK (\"App\"), you agree to the practices described in this Privacy Policy. If you do not agree to this policy, please do not use the App.\n\n"
                          "1. Information We Collect\n\n"
                          "1.1. Personal Information\n"
                          "We collect personal information from users when they register, use the App, or engage with EPI services:\n"
                          "  - Full name\n"
                          "  - Email address\n"
                          "  - Phone number\n"
                          "  - Government-issued ID details (e.g., Aadhaar, PAN)\n"
                          "  - Residential address\n\n"
                          "1.2. Financial Information\n"
                          "Payment details such as UPI, credit/debit card, or bank account information for processing transactions related to the EPI scheme.\n\n"
                          "1.3. Usage Information\n"
                          "We may collect information about your interactions with the App, including:\n"
                          "  - Transaction history\n"
                          "  - App usage patterns and preferences\n"
                          "  - Referrals and commission tracking\n\n"
                          "1.4. Device Information\n"
                          "  - IP address\n"
                          "  - Device type, model, and operating system version\n"
                          "  - App version and crash logs\n\n"
                          "2. How We Use Your Information\n\n"
                          "We use the information collected for the following purposes:\n"
                          "  - To register and manage your EPI account.\n"
                          "  - To process your payments and investments for the EPI scheme.\n"
                          "  - To deliver products upon successful scheme completion.\n"
                          "  - To send you notifications about your investment progress, rewards, and any important updates related to the scheme.\n"
                          "  - To respond to your customer service inquiries.\n"
                          "  - To improve the functionality and user experience of the App.\n"
                          "  - To comply with legal, regulatory, and security obligations.\n\n"
                          "3. Sharing Your Information\n\n"
                          "3.1. With Service Providers\n"
                          "We may share your information with trusted third-party vendors and service providers to assist us in processing payments, managing products, or providing support services.\n\n"
                          "3.2. Legal and Regulatory Requirements\n"
                          "We may disclose your information when required by law, such as complying with a subpoena, court order, or other legal process, or when necessary to protect our rights and the safety of others.\n\n"
                          "3.3. Business Transfers\n"
                          "In the event of a merger, acquisition, or sale of assets, your personal information may be transferred to the new entity, and you will be notified via the App or email.\n\n"
                          "4. Data Security\n\n"
                          "4.1. We implement technical, administrative, and physical safeguards to protect your personal information.\n"
                          "4.2. While we take reasonable measures to protect your data, no method of electronic transmission or storage is entirely secure, and we cannot guarantee 100% security.\n\n"
                          "5. Retention of Information\n\n"
                          "5.1. We retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required by law.\n"
                          "5.2. After the retention period, your personal information will be securely deleted or anonymized.\n\n"
                          "6. User Rights\n\n"
                          "6.1. Access and Correction: You have the right to access and update your personal information through your EPI account.\n"
                          "6.2. Data Deletion: You may request the deletion of your account and personal data, subject to any legal or contractual obligations.\n"
                          "6.3. Opt-Out of Marketing: You can opt-out of receiving marketing communications at any time by changing your communication preferences within the App or contacting us directly.\n\n"
                          "7. Cookies and Tracking Technologies\n\n"
                          "7.1. We may use cookies, web beacons, and similar technologies to enhance your experience, analyze usage patterns, and improve the App's functionality.\n"
                          "7.2. You can manage your cookie preferences by adjusting your browser or device settings.\n\n"
                          "8. Third-Party Links\n\n"
                          "The App may contain links to third-party websites or services. This Privacy Policy applies only to the EPI APK, and we are not responsible for the privacy practices of third-party websites. We encourage you to review their privacy policies before providing any personal information.\n\n"
                          "9. Changes to This Privacy Policy\n\n"
                          "We may update this Privacy Policy from time to time to reflect changes in our practices or legal requirements.\n"
                          "Any changes will be posted within the App or communicated through email.\n"
                          "We encourage you to periodically review this policy to stay informed about how we are protecting your information.\n\n"
                          "10. Contact Us\n\n"
                          "For any questions or concerns regarding this Privacy Policy, or to exercise your rights regarding your personal data, please contact us at:\n"
                          "Email: [Insert Email Address]\n"
                          "Phone: [Insert Phone Number]\n"
                          "Website: [Insert Website URL]\n\n"
                          "By using the EPI APK, you consent to the practices described in this Privacy Policy. Please ensure you review this policy periodically for updates.",
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showMoreDetails = !showMoreDetails;
                        });
                      },
                      child: Text(
                        showMoreDetails
                            ? "Show Less Details"
                            : "Read Full Details",
                        style: const TextStyle(color: Colors.deepPurpleAccent),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: termsAccepted,
                          onChanged: (value) {
                            setState(() {
                              termsAccepted = value!;
                            });
                          },
                        ),
                        // ignore: prefer_const_constructors
                        SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "I agree to the Terms and Conditions.",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black, fontFamily: "font"),
                  ),
                ),
                ElevatedButton(
                  onPressed: termsAccepted
                      ? () {
                          Navigator.of(context).pop();
                          */
/* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CompleteProfileScreen()),
                          );*/ /*

                        }
                      : null,
                  child: const Text(
                    "Agree",
                    style: TextStyle(color: Colors.black, fontFamily: "font"),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
*/
