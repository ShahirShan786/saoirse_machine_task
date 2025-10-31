import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BankAccountPage extends StatefulWidget {
  const BankAccountPage({super.key});

  @override
  _BankAccountPageState createState() => _BankAccountPageState();
}

class _BankAccountPageState extends State<BankAccountPage> {
  late String userId;
  List<Map<String, dynamic>> bankAccounts = [];

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('id') ?? '';
    });

    if (userId.isNotEmpty) {
      _fetchBankAccounts();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("User ID not found. Please log in again.")),
      );
    }
  }
  // view existing bank accounts

  Future<void> _fetchBankAccounts() async {
    const String url = 'http://16.171.26.118/fetch_bank_accounts.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'user_id': userId},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status_code'] == 200) {
          setState(() {
            bankAccounts = List<Map<String, dynamic>>.from(data['data']);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['msg'])),
          );
        }
      } else {
        throw Exception('Failed to fetch bank accounts.');
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching bank accounts.")),
      );
    }
  }

  // add bank accounts

  Future<void> _addBankAccount(
      String bankName, String accountNumber, String ifscCode) async {
    const String url = 'http://16.171.26.118/add_bank_account.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'user_id': userId,
          'bank_name': bankName,
          'account_number': accountNumber,
          'ifsc_code': ifscCode,
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status_code'] == 200) {
          _fetchBankAccounts();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Bank account added successfully.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['msg'])),
          );
        }
      } else {
        throw Exception('Failed to add bank account.');
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error adding bank account.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank Accounts"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: bankAccounts.length,
              itemBuilder: (context, index) {
                final account = bankAccounts[index];
                return ListTile(
                  title: Text(account['bank_name']),
                  subtitle: Text(
                    "A/C: ${account['account_number']}\nIFSC: ${account['ifsc_code']}",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  leading: const Icon(Icons.account_balance),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                // shape: const RoundedRectangleBorder(),
                fixedSize: const Size(600, 50),
                backgroundColor: const Color(0xFF223043),
              ),
              onPressed: () {
                _showAddBankDialog();
              },
              child: const Text(
                "Add Bank Account",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBankDialog() {
    final TextEditingController accountNumberController =
        TextEditingController();
    final TextEditingController ifscController = TextEditingController();

    List<String> bankNames = [
      "State Bank of India (SBI)",
      "HDFC Bank",
      "ICICI Bank",
      "Axis Bank",
      "Punjab National Bank (PNB)",
      "Bank of Baroda",
      "Canara Bank",
      "Union Bank of India",
      "Kotak Mahindra Bank",
      "Indian Bank",
      "IDBI Bank",
      "Yes Bank",
      "IndusInd Bank",
      "Federal Bank",
      "IDFC First Bank"
    ];

    String selectedBank = bankNames[0]; // Default selection

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Bank Account"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedBank,
                decoration: const InputDecoration(labelText: "Bank Name"),
                items: bankNames.map((String bank) {
                  return DropdownMenuItem<String>(
                    value: bank,
                    child: SizedBox(
                        width: 200,
                        child: Text(
                          bank,
                          overflow: TextOverflow.ellipsis,
                        )),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    selectedBank = newValue;
                  }
                },
              ),
              TextField(
                controller: accountNumberController,
                decoration: const InputDecoration(labelText: "Account Number"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: ifscController,
                decoration: const InputDecoration(labelText: "IFSC Code"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF223043),
              ),
              onPressed: () {
                _addBankAccount(
                  selectedBank, // Use selected bank from dropdown
                  accountNumberController.text,
                  ifscController.text,
                );
                Navigator.pop(context);
              },
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
