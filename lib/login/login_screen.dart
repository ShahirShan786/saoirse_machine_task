import 'package:epi/Bottom_NavigationPage.dart';
import 'package:epi/Forgot_Password.dart';
import 'package:epi/WISHLIST/custom_toast.dart';
import 'package:epi/api_service/auth_service.dart';
import 'package:epi/forgot_password/forgot_password_screen.dart';
import 'package:epi/signup/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  
  final AuthServices _authServices = AuthServices();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Constants
  static const _primaryColor = Color(0xFF0A1F44);
  static const _textColor = Color(0xFF1A1A1A);
  static const _borderColor = Color(0xFFE0E0E0);
  static const _buttonHeight = 16.0;
  static const _logoSize = 120.0;
  static const _borderRadius = 12.0;

  // Spacing Constants
  static const _smallSpace = SizedBox(height: 16);
  static const _mediumSpace = SizedBox(height: 20);
  static const _largeSpace = SizedBox(height: 24);
  static const _extraLargeSpace = SizedBox(height: 40);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  _buildLogoSection(),
                  _mediumSpace,
                  _buildTaglineSection(),
                  _extraLargeSpace,
                  _buildEmailField(),
                  _smallSpace,
                  _buildPasswordField(),
                  _buildForgotPasswordSection(context),
                  _mediumSpace,
                  _buildLoginButton(context),
                  _largeSpace,
                  _buildDividerSection(),
                  _largeSpace,
                  _buildGoogleSignInButton(context),
                  _mediumSpace,
                  _buildSignUpSection(context),
                  _largeSpace,
                  _buildTermsAndPrivacySection(),
                  _smallSpace,
                  _buildVersionSection(),
                  _largeSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Logo Section
  Widget _buildLogoSection() {
    return Center(
      child: Image.asset(
        'assets/image/logo.png',
        height: _logoSize,
        width: _logoSize,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: _logoSize,
            width: _logoSize,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
            child: const Icon(
              Icons.show_chart,
              size: 60,
              color: Color(0xFF0A1F44),
            ),
          );
        },
      ),
    );
  }

  // Tagline Section
  Widget _buildTaglineSection() {
    return const Text(
      'Invest small, Dream big,\nOwn it!',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: _textColor,
        height: 1.4,
      ),
    );
  }

  // Email Field
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        prefixIcon: const Icon(Icons.email_outlined),
        border: _buildInputBorder(),
        enabledBorder: _buildInputBorder(),
        focusedBorder: _buildFocusedBorder(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: _validateEmail,
    );
  }

  // Password Field
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: _togglePasswordVisibility,
        ),
        border: _buildInputBorder(),
        enabledBorder: _buildInputBorder(),
        focusedBorder: _buildFocusedBorder(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: _validatePassword,
    );
  }

  // Forgot Password Section
  Widget _buildForgotPasswordSection(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
          );
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Login Button
  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleLogin(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: _buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        elevation: 2,
      ),
      child: const Text(
        'Login',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Divider Section
  Widget _buildDividerSection() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
        ),
      ],
    );
  }

  // Google Sign In Button
  Widget _buildGoogleSignInButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _handleGoogleSignIn(context),
      icon: Image.network(
        'https://www.google.com/favicon.ico',
        height: 24,
        width: 24,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.g_mobiledata, size: 24);
        },
      ),
      label: const Text(
        'Sign in with Google',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _textColor,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: _buttonHeight),
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  // Sign Up Section
  Widget _buildSignUpSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: _primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Terms and Privacy Section
  Widget _buildTermsAndPrivacySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            height: 1.5,
          ),
          children: const [
            TextSpan(
              text: 'By Signing up you agree to EPI Elio\'s ',
            ),
            TextSpan(
              text: 'Terms & Conditions',
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Version Section
  Widget _buildVersionSection() {
    return Center(
      child: Text(
        'Copyright | Version 2.1',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 12,
        ),
      ),
    );
  }

  // Helper Methods
  OutlineInputBorder _buildInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
      borderSide: const BorderSide(color: _borderColor),
    );
  }

  OutlineInputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
      borderSide: const BorderSide(
        color: _primaryColor,
        width: 2,
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Authentication Handlers
  Future<void> _handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      showInfoToast(context, "Processing Login...");

      String? result = await _authServices.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (result == "success") {
        if (context.mounted) {
          showSuccessToast(context, "Login Successful");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigationPage()),
          );
        }
      } else {
        if (context.mounted) {
          showErrorToast(context, result ?? 'Login failed');
        }
      }
    }
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final result = await _authServices.signInWithGoogle();

    if (context.mounted) Navigator.pop(context);

    if (result == "success") {
      if (context.mounted) {
        showSuccessToast(context, "Login Successful");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigationPage()),
        );
      }
    } else {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Login Failed"),
            content: Text(result ?? "An unexpected error occurred."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }
}
