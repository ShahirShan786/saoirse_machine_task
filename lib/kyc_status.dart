import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class KycStatusPage extends StatefulWidget {
  const KycStatusPage({super.key});

  @override
  State<KycStatusPage> createState() => _KycStatusPageState();
}

class _KycStatusPageState extends State<KycStatusPage> {
  String kycStatus = "Pending"; // Default KYC status
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchKycStatus(); // Fetch the initial KYC status on page load
  }

  Future<void> _fetchKycStatus() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('user_id') ?? '';

      if (userId.isEmpty) {
        throw Exception("User ID not found in SharedPreferences.");
      }

      final response = await http.post(
        Uri.parse('http://16.171.26.118/check_kyc_status.php'),  // Change with your API URL
        body: {'User_id': userId},
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != null && data['status_code'] == 200 && data['status'] != null) {
          setState(() {
            kycStatus = data['status'].toLowerCase(); // Normalize status string
          });
        } else {
          throw Exception("Unexpected response format: $data");
        }
      } else {
        throw Exception("Failed to fetch KYC status. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during KYC status fetch: $e");
      _showErrorDialog(message: e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog({String message = "An error occurred. Please try again."}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
      appBar: AppBar(
        title: const Text("KYC Status"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Current KYC Status:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const CircularProgressIndicator()
                : Text(
              kycStatus,
              style: TextStyle(
                fontSize: 24,
                color: kycStatus == "approved" ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchKycStatus,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: const Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }
}
