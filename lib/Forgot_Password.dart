import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool isCodeSent = false;
  bool isCodeVerified = false;
  bool isLoading = false;

  Future<void> sendResetCode() async {
    setState(() => isLoading = true);
    var url = "http://16.171.26.118/forgot_password.php";
    var response = await http.post(Uri.parse(url), body: {
      'email': emailController.text.trim(),
      'action': 'send_code',
    });

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status_code'] == 200) {
      setState(() {
        isCodeSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Reset code sent to email.")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(jsonResponse['msg'])));
    }
    setState(() => isLoading = false);
  }

  Future<void> verifyCode() async {
    setState(() => isLoading = true);
    var url = "http://16.171.26.118/forgot_password.php";
    var response = await http.post(Uri.parse(url), body: {
      'email': emailController.text.trim(),
      'reset_code': codeController.text.trim(),
      'action': 'verify_code',
    });

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status_code'] == 200) {
      setState(() {
        isCodeVerified = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Code verified! Set new password.")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(jsonResponse['msg'])));
    }
    setState(() => isLoading = false);
  }

  Future<void> resetPassword() async {
    setState(() => isLoading = true);
    var url = "http://16.171.26.118/forgot_password.php";
    var response = await http.post(Uri.parse(url), body: {
      'email': emailController.text.trim(),
      'new_password': newPasswordController.text.trim(),
      'action': 'reset_password',
    });

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status_code'] == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Password reset successful!")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(jsonResponse['msg'])));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isCodeSent)
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Enter your email"),
              ),
            if (isCodeSent && !isCodeVerified)
              TextField(
                controller: codeController,
                decoration: InputDecoration(labelText: "Enter reset code"),
              ),
            if (isCodeVerified)
              TextField(
                controller: newPasswordController,
                decoration: InputDecoration(labelText: "Enter new password"),
                obscureText: true,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : isCodeVerified
                  ? resetPassword
                  : isCodeSent
                  ? verifyCode
                  : sendResetCode,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Text(isCodeVerified
                  ? "Reset Password"
                  : isCodeSent
                  ? "Verify Code"
                  : "Send Reset Code"),
            ),
          ],
        ),
      ),
    );
  }
}
