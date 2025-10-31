// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class Withdrawal extends StatefulWidget {
//   final String amount;
//   Withdrawal({super.key, required this.amount});

//   @override
//   State<Withdrawal> createState() => _WithdrawalState();
// }

// class _WithdrawalState extends State<Withdrawal> {
//   TextEditingController withdrawalAmountController = TextEditingController();
//   TextEditingController accountNoController = TextEditingController();
//   TextEditingController bankNameController = TextEditingController();

//   Future<void> submitWithdrawal() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userId =
//         prefs.getString('id'); // Get user ID from SharedPreferences

//     if (userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text("User ID not found. Please log in again.")));
//       return;
//     }

//     String withdrawalAmount = withdrawalAmountController.text.trim();
//     String accountNo = accountNoController.text.trim();
//     String bankName = bankNameController.text.trim();

//     if (withdrawalAmount.isEmpty || accountNo.isEmpty || bankName.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please fill all fields.")));
//       return;
//     }

//     final response = await http.post(
//       Uri.parse('http://16.171.26.118/insert_withdrawal.php'),
//       body: {
//         'user_id': userId,
//         'request_amount': withdrawalAmount,
//         'account_no': accountNo,
//         'bank_name': bankName,
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(data['message'])));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text("Failed to submit withdrawal request.")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Withdrawal',
//           style: TextStyle(color: Colors.black, fontFamily: "font"),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextFormField(
//               enabled: false,
//               decoration: InputDecoration(
//                 prefixText: '₹ ${widget.amount}',
//                 prefixStyle: const TextStyle(color: Colors.black),
//                 label: const Text("TOTAL AMOUNT",
//                     style: TextStyle(color: Colors.grey)),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextFormField(
//               controller: withdrawalAmountController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 label: Text("WITHDRAWAL AMOUNT",
//                     style: TextStyle(color: Colors.grey)),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextFormField(
//               controller: accountNoController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 label: Text("ACCOUNT NO", style: TextStyle(color: Colors.grey)),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextFormField(
//               controller: bankNameController,
//               decoration: const InputDecoration(
//                   enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.grey)),
//                   focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.grey)),
//                   label: Text(
//                     "BANK NAME",
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                   floatingLabelBehavior: FloatingLabelBehavior.always),
//             ),
//             const SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: () {
//                 submitWithdrawal();
//               },
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF223043),
//                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   minimumSize: const Size(double.infinity, 50),
//                   padding: EdgeInsets.zero,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10))),
//               child: const Text(
//                 'REQUEST',
//                 style: TextStyle(color: Colors.white, fontFamily: "font"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'WithdrawalWaitingScreen.dart';

class Withdrawal extends StatefulWidget {
  final String amount;
  const Withdrawal({super.key, required this.amount});

  @override
  State<Withdrawal> createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal>
    with SingleTickerProviderStateMixin {
  TextEditingController withdrawalAmountController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  double totalVaultAmount = 0.0;
  int countdown = 3;
  bool isRefreshing = false;

  List<Map<String, String>> userBankAccounts = [];
  String? selectedBankId;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Duration for one full rotation
    );

    // Define the rotation animation using a Tween
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
    super.initState();
    startCountdown();
    fetchUserBankAccounts();
  }

  /// Function to start the countdown and refresh balance
  void startCountdown() {
    _controller.repeat(); // Start rotating

    // Stop rotating after 2 seconds
    Future.delayed(const Duration(seconds: 4), () {
      _controller.stop(); // Stop the animation
    });
    setState(() {
      isRefreshing = true;
      countdown = 3;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        fetchVaultBalance();
        setState(() {
          isRefreshing = false;
        });
      }
    });
  }

  /// Fetch Vault Balance from API
  Future<void> fetchVaultBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');

    const String url = 'http://16.171.26.118/vault_balance.php';
    try {
      final response =
          await http.post(Uri.parse(url), body: {'user_id': userId});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status_code'] == 200) {
          setState(() {
            totalVaultAmount =
                double.tryParse(data['total_amount'].toString()) ?? 0.0;
          });
        }
      }
    } catch (e) {
      print("Error fetching vault balance: $e");
    }
  }

  /// Fetch User's Bank Accounts
  Future<void> fetchUserBankAccounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    const String url = 'http://16.171.26.118/fetch_bank_accounts.php';
    try {
      final response =
          await http.post(Uri.parse(url), body: {'user_id': userId});
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status_code'] == 200 && data['data'] is List) {
          List<Map<String, String>> banks = (data['data'] as List).map((bank) {
            return {
              'id': bank['id'].toString(),
              'bank_name': bank['bank_name'].toString(),
              'account_no': bank['account_number']
                  .toString(), // Ensure this matches API key
            };
          }).toList();

          print("Fetched Banks: $banks");
          setState(() {
            userBankAccounts = banks;
            if (banks.isNotEmpty) {
              selectedBankId = banks.first['id'];
              _updateBankDetails(selectedBankId!);
            }
          });
        } else {
          print("No bank accounts found.");
        }
      } else {
        print(
            "Failed to fetch bank accounts. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception in fetching bank accounts: $e");
    }
  }

  /// Update Account Number and Bank Name when user selects a bank
  void _updateBankDetails(String bankId) {
    final selectedBank =
        userBankAccounts.firstWhere((bank) => bank['id'] == bankId);
    setState(() {
      accountNoController.text = selectedBank['account_no']!;
      bankNameController.text = selectedBank['bank_name']!;
    });
  }

  /// Function to handle withdrawal request
  Future<void> submitWithdrawal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');

    String withdrawalAmount = withdrawalAmountController.text.trim();
    String accountNo = accountNoController.text.trim();
    String bankName = bankNameController.text.trim();

    if (withdrawalAmount.isEmpty || accountNo.isEmpty || bankName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://16.171.26.118/insert_withdrawal.php'),
      body: {
        'user_id': userId,
        'request_amount': withdrawalAmount,
        'account_no': accountNo,
        'bank_name': bankName,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        int withdrawalId = data['withdrawal_id']; // Get withdrawal ID

        // Navigate to Withdrawal Waiting Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WithdrawalWaitingScreen(withdrawalId: withdrawalId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit withdrawal request.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Withdrawal',
          style: TextStyle(color: Colors.black, fontFamily: "font"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                isRefreshing
                    ? Text(
                        "Refreshing in $countdown...",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      )
                    : Text(
                        "Vault Balance: ₹$totalVaultAmount",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                const Spacer(),
                IconButton(
                  onPressed: startCountdown,
                  icon: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animation.value, // Apply the rotation
                        child: const Icon(
                          Icons.refresh,
                          size: 28,
                        ),
                      );
                    },
                  ),

                  //  const Text("Refresh Vault Balance"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// Withdrawal Amount
            TextFormField(
              controller: withdrawalAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("WITHDRAWAL AMOUNT",
                    style: TextStyle(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 20),

            /// Select Bank Account Dropdown
            userBankAccounts.isNotEmpty
                ? DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedBankId,
                    items: userBankAccounts.map((bank) {
                      return DropdownMenuItem<String>(
                        value: bank['id'],
                        child: Text(
                            "${bank['bank_name']} - ${bank['account_no']}"),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                        labelText: "Select Bank Account",
                        focusedBorder: OutlineInputBorder(),
                        border: OutlineInputBorder()),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedBankId = newValue;
                          _updateBankDetails(newValue);
                        });
                      }
                    },
                  )
                : const Text(
                    "No bank accounts found. Please add a bank account."),

            const SizedBox(height: 20),

            /// Account No (Auto-filled)
            TextFormField(
              controller: accountNoController,
              enabled: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("ACCOUNT NO", style: TextStyle(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 20),

            /// Bank Name (Auto-filled)
            TextFormField(
              controller: bankNameController,
              enabled: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("BANK NAME", style: TextStyle(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 40),

            /// Withdrawal Request Button
            ElevatedButton(
              onPressed: submitWithdrawal,
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(600, 50),
                backgroundColor: const Color(0xFF223043),
              ),
              child: const Text(
                "REQUEST WITHDRAWAL",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
