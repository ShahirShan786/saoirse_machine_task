import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentHistoryPage extends StatelessWidget {
  final String userId;

  const PaymentHistoryPage({super.key, required this.userId});
  Future<List<dynamic>> fetchPaymentHistory() async {
    const String url = 'http://16.171.26.118/payment_history.php';

    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'view',
        'user_id': userId,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null &&
            data['payment_history'] != null &&
            data['payment_history'] is List) {
          return data['payment_history'];
        } else {
          return []; // Return an empty list instead of null
        }
      } else {
        throw Exception("Failed to fetch payment history.");
      }
    } catch (e) {
      return []; // Return an empty list on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(surfaceTintColor: Colors.transparent,
          title: const Text(
        "Payment History",
        style: TextStyle(fontFamily: "font"),
      )),
      body: FutureBuilder<List<dynamic>>(
        future: fetchPaymentHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // else if (snapshot.hasError) {
          //   return Center(
          //       child: Text(
          //     "${snapshot.error} nnn",
          //     style: const TextStyle(fontFamily: "font"),
          //   ));
          // }
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              "No payment History available.",
              style: TextStyle(fontFamily: "font"),
            ));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final payment = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade100,
                          spreadRadius: 0,
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.only(left: 10,right: 10),
                          minTileHeight: 0,
                          minVerticalPadding: 0,
                          title: Text(
                            "Product ID: ${payment['product_id']}",
                            style: const TextStyle(fontFamily: "font"),
                          ),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.only(left: 10,right: 10),
                          minTileHeight: 40,
                          minVerticalPadding: 10,
                          title: Text(
                            "Paid: ₹${payment['payment_amount']}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "Balance: ₹${payment['balance_amount']}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Text(
                            payment['payment_date'],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                // Card(
                //   margin: const EdgeInsets.all(8.0),
                //   child: ListTile(
                //     title: Text("Product ID: ${payment['product_id']}"),
                //     subtitle: Text(
                //       "Paid: ₹${payment['payment_amount']}\nBalance: ₹${payment['balance_amount']}",
                //     ),
                //     trailing: Text(payment['payment_date']),
                //   ),
                // );
              },
            );
          }
        },
      ),
    );
  }
}
