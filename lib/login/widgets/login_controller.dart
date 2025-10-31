import 'package:flutter/material.dart';
import 'package:epi/api_service/auth_service.dart';
import 'package:epi/WISHLIST/custom_toast.dart';
import 'package:epi/Bottom_NavigationPage.dart';

class LoginController {
  final AuthServices _authServices = AuthServices();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  bool isLoading = false;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
  }

  Future<void> handleEmailLogin(BuildContext context) async {
    if (_validateForm()) {
      showInfoToast(context, "Processing Login...");

      String? result = await _authServices.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (result == "success") {
        if (context.mounted) {
          showSuccessToast(context, "Login Successful");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavigationPage()),
          );
        }
      } else {
        if (context.mounted) {
          showErrorToast(context, result ?? 'Login failed');
        }
      }
    }
  }

  Future<void> handleGoogleSignIn(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final result = await _authServices.signInWithGoogle();

    // Close loading dialog
    if (context.mounted) Navigator.pop(context);

    if (result == "success") {
      if (context.mounted) {
        showSuccessToast(context, "Login Successful");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigationPage()),
        );
      }
    } else {
      _showErrorDialog(context, result);
    }
  }

  bool _validateForm() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return false;
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailController.text)) {
      return false;
    }
    
    if (passwordController.text.length < 6) {
      return false;
    }
    
    return true;
  }

  void _showErrorDialog(BuildContext context, String? errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Failed"),
        content: Text(errorMessage ?? "An unexpected error occurred."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}