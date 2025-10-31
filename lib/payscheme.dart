import 'dart:convert';

import 'package:epi/Razorpay.dart';
import 'package:epi/paymenthistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchemeAndPayment extends StatefulWidget {
  final String userId;

  const SchemeAndPayment({super.key, required this.userId});

  @override
  State<SchemeAndPayment> createState() => _SchemeAndPaymentState();
}

class _SchemeAndPaymentState extends State<SchemeAndPayment> {
  late String userId;
  Map<String, double> balanceMap = {}; // Tracks balance for each product
  Map<String, DateTime> paymentDates =
      {}; // Tracks the last payment date for each product
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

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    _loadPaymentData();

    _updateSystemUIOverlay();
  }

  // Load payment data from SharedPreferences
  Future<void> _loadPaymentData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!mounted) {
      setState(() {
        balanceMap = Map<String, double>.from(
            jsonDecode(prefs.getString('balanceMap') ?? '{}'));
        paymentDates =
            (jsonDecode(prefs.getString('paymentDates') ?? '{}') as Map)
                .map((key, value) => MapEntry(key, DateTime.parse(value)));
      });
    }
  }

  // Save payment data to SharedPreferences
  Future<void> _savePaymentData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('balanceMap', jsonEncode(balanceMap));
    await prefs.setString(
        'paymentDates',
        jsonEncode(paymentDates
            .map((key, value) => MapEntry(key, value.toIso8601String()))));
  }

  // Record payment in the backend
  Future<void> _recordPaymentToBackend(
      String productId, double dailyPayment, double remainingBalance) async {
    const String url = 'http://16.171.26.118/payment_history.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'action': 'record',
          'user_id': userId,
          'product_id': productId,
          'payment_amount': dailyPayment.toString(),
          'balance_amount': remainingBalance.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status_code'] == 200) {
          print("Payment recorded successfully in the backend.");
        } else {
          print("Failed to record payment: ${responseData['msg']}");
        }
      } else {
        print("Backend error while recording payment.");
      }
    } catch (e) {
      print("Error recording payment: $e");
    }
  }

  // Process payment: Restrict to once per day and update the backend
  void _processPayment(String productId, double dailyPayment) async {
    if (productId.isEmpty) {
      print("Product ID is required.");
      return;
    }

    DateTime today = DateTime.now();

    if (paymentDates[productId] != null &&
        paymentDates[productId]!.day == today.day &&
        paymentDates[productId]!.month == today.month &&
        paymentDates[productId]!.year == today.year) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment already made for today.")),
      );
      return;
    }

    // Navigate to PaymentSubmissionPage and wait for the result
    bool? paymentSuccessful = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          productId: productId,
          amount: dailyPayment,
          userId: userId,
        ),
      ),
    );

    if (paymentSuccessful!) {
      // If payment was successfully submitted, update balance and save data
      setState(() {
        balanceMap[productId] = (balanceMap[productId] ?? 0) - dailyPayment;
        paymentDates[productId] = today;
      });

      await _savePaymentData();
      await _recordPaymentToBackend(
        productId,
        dailyPayment,
        balanceMap[productId] ?? 0,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment successfully recorded.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentHistoryPage(userId: userId),
                  ),
                );
              },
              child: const Text(
                "History",
                style: TextStyle(fontFamily: "font", color: Colors.black),
              )),
          const SizedBox(
            width: 10,
          )
        ],
        surfaceTintColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: _getPlanDetails(userId),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text(
              "PLEASE CHECK YOUR INTERNET CONNECTION",
              style: TextStyle(fontFamily: "font"),
            ));
          } else if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * .4,
                      width: 300,
                      child: Lottie.asset("assets/anim/empty1.json")),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "No plans found..!",
                    style: TextStyle(fontFamily: "font"),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (ctx, index) {
                final plan = snapshot.data[index];

                final productId = plan['product_id'].toString();
                final totalAmount =
                    double.parse(plan['total_amount'].toString());
                final dailyPayment =
                    double.parse(plan['daily_payment'].toString());

                balanceMap[productId] ??= totalAmount;

                bool canPay = paymentDates[productId] == null ||
                    paymentDates[productId]!.day != DateTime.now().day;

                bool isPaymentCompleted = balanceMap[productId] == 0;

                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Product ID: $productId",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Amount: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              "₹$totalAmount",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Daily Payment: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              "₹$dailyPayment",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Balance: ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹${balanceMap[productId]!.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: canPay && !isPaymentCompleted
                                  ? () {
                                      _processPayment(productId, dailyPayment);
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF223043),
                              ),
                              child: Text(
                                isPaymentCompleted
                                    ? "Payment Completed"
                                    : "Pay Now",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<dynamic>> _getPlanDetails(String userId) async {
    const String url = "http://16.171.26.118/user_view_epi.php";
    try {
      final response = await http.get(Uri.parse("$url?id=$userId"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['data'] != null) {
          return List<dynamic>.from(data['data']);
        } else {
          return []; // Return an empty list instead of null
        }
      } else {
        throw Exception("Failed to load plans.");
      }
    } catch (e) {
      throw Exception("ERROR $e");
    }
  }
}
