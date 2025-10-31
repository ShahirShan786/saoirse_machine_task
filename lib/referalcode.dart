import 'dart:convert';
import 'package:epi/withdrawal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferralCode extends StatefulWidget {
  const ReferralCode({super.key});

  @override
  State<ReferralCode> createState() => _ReferralCodeState();
}

class _ReferralCodeState extends State<ReferralCode> {
  Map<String, dynamic>? referrer;
  List<dynamic> referredUsers = [];
  bool isLoading = true;
  String userId = '';
  String referralCode = '';
  double totalVaultAmount = 0.0;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller1 = TextEditingController();

  Map<String, dynamic>?
      referredBy; // To store referrer details from 'referal_menu.php'
  Set<String> claimedRewards = {}; // To track claimed rewards

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
      await fetchReferredUsersPayments();
      await fetchReferredBy();
      await fetchVaultBalance(); // Fetch vault balance after getting userId
    } else {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(message: 'User ID not found. Please log in again.');
    }
  }

  // Existing function to fetch referred users' payments
  Future<void> fetchReferredUsersPayments() async {
    const String url = 'http://16.171.26.118/refered_users_payments.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'user_id': userId},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status_code'] == 200) {
          setState(() {
            referrer = data['referrer'];
            referralCode = data['referrer']['new_referal_code'];
            referredUsers = data['referred_users'];
            isLoading = false;
          });
          _controller1.text = referralCode.toString();
        } else {
          setState(() {
            isLoading = false;
          });
          _showErrorDialog(message: 'Error: ${data['msg']}');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog(message: 'Failed to fetch referral data.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(message: 'PLEASE CHECK YOUR INTERNET CONNECTION');
    }
  }

  // New function to fetch referrer details using 'referal_menu.php'
  Future<void> fetchReferredBy() async {
    const String url = 'http://16.171.26.118/referal_menu.php';

    // try {
    final response = await http.post(
      Uri.parse(url),
      body: {'user_id': userId},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status_code'] == 200) {
        setState(() {
          referredBy = data['referrer']; // Store the referrer details
        });
      } else {
        _showErrorDialog(message: 'Error: ${data['msg']}');
      }
    } else {
      _showErrorDialog(message: 'Failed to fetch referrer data.');
    }
  }

  //   catch (e) {
  //     _showErrorDialog(message: 'Error: $e');
  //   }
  // }

  // Function to update the referred by if it's null
  Future<void> updateReferredBy(String referralCode) async {
    const String url = 'http://16.171.26.118/update_referd_by.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'user_id': userId,
          'Referd_by': referralCode,
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status_code'] == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['msg'])),
          );
          await fetchReferredBy(); // Fetch the updated referred by information
        } else {
          _showErrorDialog(message: 'Error: ${data['msg']}');
        }
      } else {
        _showErrorDialog(message: 'Failed to update referred by.');
      }
    } catch (e) {
      _showErrorDialog(message: 'Error: $e');
    }
  }

  Future<void> claimReward(double reward, String username) async {
    final prefs = await SharedPreferences.getInstance();
    final String lastClaimDate = prefs.getString('last_claim_date') ?? '';
    final String todayDate = DateTime.now()
        .toIso8601String()
        .split('T')[0]; // Get today's date as YYYY-MM-DD

    if (lastClaimDate == todayDate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can only convert once per day.")),
      );
      return;
    }

    const String url = 'http://16.171.26.118/claim_reward.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'user_id': userId,
          'reward': reward.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status_code'] == 200) {
          setState(() {
            claimedRewards.add(username);
            for (var user in referredUsers) {
              if (user['Username'] == username) {
                user['daily_payment'] = '0.0';
              }
            }
          });

          // Save the last claim date
          prefs.setString('last_claim_date', todayDate);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['msg'])),
          );
        } else {
          _showErrorDialog(message: 'Error: ${data['msg']}');
        }
      } else {
        _showErrorDialog(message: 'Failed to claim reward. Server error.');
      }
    } catch (e) {
      _showErrorDialog(message: 'Error: $e');
    }
  }

  void _showErrorDialog(
      {String message = "An error occurred. Please try again."}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Error",
            style: TextStyle(fontFamily: "font"),
          ),
          content: Text(
            message,
            style: const TextStyle(fontFamily: "font"),
          ),
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

/////////////////////////////////////////////////////////////////////////////
  Future<void> fetchVaultBalance() async {
    const String url = 'http://16.171.26.118/vault_balance.php';
    // try {
    final response = await http.post(
      Uri.parse(url),
      body: {'user_id': userId},
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
          _controller.text = "₹ ${totalVaultAmount.toString()}";
          print('Total Vault Amount: $totalVaultAmount');
        });
      } else {
        _showErrorDialog(message: 'Error: ${data['msg']}');
      }
    } else {
      _showErrorDialog(message: 'Failed to fetch vault balance.');
    }
    // }
    // catch (e) {
    //   _showErrorDialog(message: 'Error: $e');
    // }
  }

  void shareReferralCode(String referralCode) {
    if (referralCode.isNotEmpty) {
      Share.share("Join us using my referral code: $referralCode");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  children: [
                    Container(
                      color: const Color(0xFF223043),
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFormField(
                            style: const TextStyle(
                                color: Colors.white, fontFamily: "font"),
                            controller: _controller,
                            scrollPadding: EdgeInsets.zero,
                            readOnly: true,
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF8E999C),
                                  ),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF8E999C),
                                  ),
                                ),
                                suffix: ElevatedButton(
                                  onPressed: () {
                                    if (referredUsers.isNotEmpty) {
                                      final user = referredUsers
                                          .first; // Example: Get first user
                                      final double dailyPayment =
                                          double.parse(user['daily_payment']);
                                      final double reward = dailyPayment * 0.25;
                                      final String username = user['Username'];
                                      claimReward(reward, username);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8E999C),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: const Size(100, 30),
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'CONVERT',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "font"),
                                  ),
                                ),
                                label: const Text(
                                  "WALLET",
                                  style: TextStyle(color: Colors.white),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            scrollPadding: EdgeInsets.zero,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixText: "10",
                                suffixStyle: TextStyle(
                                    color: Colors.white, fontFamily: "font"),
                                prefixText: "0",
                                prefixStyle: TextStyle(
                                    color: Colors.white, fontFamily: "font"),
                                disabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF8E999C))),
                                label: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "TOTAL REFFERALS",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "MAX REFFERALS",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _controller1,
                            style: const TextStyle(
                                color: Colors.white, fontFamily: "font"),
                            scrollPadding: EdgeInsets.zero,
                            readOnly: true,
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF8E999C),
                                  ),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF8E999C),
                                  ),
                                ),
                                suffix: ElevatedButton(
                                  onPressed: () {
                                    shareReferralCode(referralCode);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF8E999C),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      minimumSize: const Size(100, 30),
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: const Text(
                                    'INVITE',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "font"),
                                  ),
                                ),
                                label: const Text(
                                  "REFFERAL CODE",
                                  style: TextStyle(color: Colors.white),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                          ),
                          TextFormField(
                            style: const TextStyle(
                                color: Colors.white, fontFamily: "font"),
                            scrollPadding: EdgeInsets.zero,
                            readOnly: true,
                            decoration: InputDecoration(
                                label: const Text(
                                  "",
                                ),
                                border: InputBorder.none,
                                suffix: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Withdrawal(
                                          amount:
                                              "₹ ${totalVaultAmount.toString()}",
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF8E999C),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      minimumSize: const Size(100, 30),
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: const Text(
                                    'WITHDRAW',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "font"),
                                  ),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    referredUsers.isEmpty
                        ? const Text(
                            "No users registered with your referral code.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "Referred Users:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: referredUsers.length,
                                itemBuilder: (context, index) {
                                  final user = referredUsers[index];
                                  final double dailyPayment =
                                      double.parse(user['daily_payment']);
                                  final double reward = dailyPayment * 0.25;
                                  final username = user['Username'];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade100,
                                            spreadRadius: 0,
                                            blurRadius: 3,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          username,
                                          style: const TextStyle(
                                              fontFamily: "font"),
                                        ),
                                        subtitle: Text(
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                          "Email: ${user['Email']}\nDaily Payment: ₹${claimedRewards.contains(username) ? '0.0' : dailyPayment}\nReward: ₹${claimedRewards.contains(username) ? '0.0' : reward}",
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
