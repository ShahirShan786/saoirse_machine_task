import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VaultPage extends StatefulWidget {
  final String userId;

  const VaultPage({super.key, required this.userId});

  @override
  _VaultPageState createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  double totalVaultAmount = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.userId.isEmpty) {
      _showErrorDialog(message: 'User ID is empty');
    } else {
      print('VaultPage userId: ${widget.userId}'); // Debugging line
      fetchVaultBalance();
    }
  }

  Future<void> fetchVaultBalance() async {
    const String url = 'http://16.171.26.118/vault_balance.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'user_id': widget.userId},
      );

      // Debugging: Print the entire response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if the response contains the expected data
        if (data['status_code'] == 200) {
          setState(() {
            // Parse total_amount as a double, even if it's returned as a string
            totalVaultAmount = double.tryParse(data['total_amount']) ?? 0.0;
            print('Total Vault Amount: $totalVaultAmount');
          });
        } else {
          _showErrorDialog(message: 'Error: ${data['msg']}');
        }
      } else {
        _showErrorDialog(message: 'Failed to fetch vault balance.');
      }
    } catch (e) {
      _showErrorDialog(message: 'Error: $e');
    }
  }


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
      appBar: AppBar(
        title: const Text('Vault Balance'),
      ),
      body: Center(
        child: totalVaultAmount == 0.0
            ? const CircularProgressIndicator()
            : Text(
          'Total Vault Balance: ₹$totalVaultAmount',
          style: const TextStyle(fontSize: 18),
        ),

      ),
    );
  }
}
