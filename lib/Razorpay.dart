import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

Future<Map<String, String>> loadRazorpayKeys() async {
  try {
    final csvString = await rootBundle.loadString('assets/rzp.csv');
    final lines = LineSplitter().convert(csvString);
    final headers = lines[0].split(',');
    final values = lines[1].split(',');
    return {
      headers[0]: values[0],
      headers[1]: values[1],
    };
  } catch (e) {
    print("Error loading Razorpay keys: $e");
    return {};
  }
}

class PaymentPage extends StatefulWidget {
  final String productId;
  final double amount;
  final String userId;

  const PaymentPage({super.key, required this.productId, required this.amount, required this.userId});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;
  String razorpayKey = '';

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    loadRazorpayKeys().then((keys) {
      setState(() {
        razorpayKey = keys['key_id']!;
      });
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Success: ${response.paymentId}");

    // TODO: Replace with actual API endpoint and user_id
    const String apiUrl = 'http://16.171.26.118/payment_transaction_insert.php'; // Replace with your IP

    try {
      final res = await http.post(
        Uri.parse(apiUrl),
        body: {
          'product_id': widget.productId,
          'user_id': widget.userId,
          'transaction_id': response.paymentId ?? '',
          'amount': widget.amount.toString(),
          'status': 'success',
        },
      );

      final result = json.decode(res.body);
      print("API Response: $result");

      if (result['status'] == 'success') {
        Navigator.pop(context, true); // Success - return to previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment saved, but not recorded on server")),
        );
      }
    } catch (e) {
      print("Error saving payment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment saved, but sync failed")),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Failed")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  void _startPayment() {
    if (razorpayKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please wait... Razorpay key not loaded")),
      );
      return;
    }

    var options = {
      'key': razorpayKey,
      'amount': (widget.amount * 100).toInt(),
      'name': 'EPI Daily Payment',
      'description': 'Product ID: ${widget.productId}',
      'prefill': {'contact': '', 'email': ''},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Payment"),
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Payment Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text("Product ID: ${widget.productId}"),
                  Text("Amount to Pay: ₹${widget.amount.toStringAsFixed(2)}"),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF223043),
                ),
                child: const Text("Pay Now", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
