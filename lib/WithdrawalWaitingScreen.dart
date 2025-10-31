import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WithdrawalWaitingScreen extends StatefulWidget {
  final int withdrawalId;

  const WithdrawalWaitingScreen({super.key, required this.withdrawalId});

  @override
  _WithdrawalWaitingScreenState createState() => _WithdrawalWaitingScreenState();
}

class _WithdrawalWaitingScreenState extends State<WithdrawalWaitingScreen> {
  String status = "pending"; // Default status
  late Timer timer;

  @override
  void initState() {
    super.initState();
    // Start polling for withdrawal status every 5 seconds
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkWithdrawalStatus();
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Stop polling when the screen is closed
    super.dispose();
  }

  /// Function to check withdrawal status from `get_withdrawal_status.php`
  Future<void> checkWithdrawalStatus() async {
    final response = await http.post(
      Uri.parse('http://16.171.26.118/get_withdrawal_status.php'),
      body: {'withdrawal_id': widget.withdrawalId.toString()},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          status = data['withdrawal_status'];
        });

        if (status == "approved") {
          timer.cancel(); // Stop polling
          Navigator.pop(context); // Close waiting screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Withdrawal Approved!")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              "Waiting for withdrawal approval...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Current Status: $status",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
