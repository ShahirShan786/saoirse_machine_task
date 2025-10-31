import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentSubmissionPage extends StatefulWidget {
  final String userId;
  final String productId;
  final String dailyPayment;

  const PaymentSubmissionPage({
    super.key,
    required this.userId,
    required this.productId,
    required this.dailyPayment,
  });

  @override
  State<PaymentSubmissionPage> createState() => _PaymentSubmissionPageState();
}

class _PaymentSubmissionPageState extends State<PaymentSubmissionPage> {
  final TextEditingController _transactionIdController = TextEditingController();
  bool isSubmitting = false;

  Future<String?> _fetchQrImage() async {
    try {
      final response = await http.get(Uri.parse("http://16.171.26.118/qrimg_view.php"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status_code'] == 200 && data['images'].isNotEmpty) {
          return data['images'][0]['image_url']; // Fetch first QR image URL
        }
      }
    } catch (e) {
      debugPrint("Error fetching QR image: $e");
    }
    return null; // Return null if fetching fails
  }

  Future<void> _submitPayment() async {
    if (_transactionIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a transaction ID")),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final response = await http.post(
        Uri.parse("http://16.171.26.118/submit_payment.php"),
        body: {
          "User_id": widget.userId,
          "Product_id": widget.productId,
          "Transaction_id": _transactionIdController.text,
          "Daily_payment": widget.dailyPayment,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body)),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to submit payment. Please try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Submit Payment", style: TextStyle(fontFamily: "font")),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<String?>(
              future: _fetchQrImage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loader while fetching
                } else if (snapshot.hasError || snapshot.data == null) {
                  return const Text("Failed to load QR code");
                } else {
                  return Image.network(
                    snapshot.data!,
                    width: 200,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text("Error loading QR image");
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Product ID: ${widget.productId}\nMake your daily payment of ₹${widget.dailyPayment}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _transactionIdController,
              decoration: InputDecoration(
                labelText: "Transaction ID",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSubmitting ? null : _submitPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Submit Payment"),
            ),
          ],
        ),
      ),
    );
  }
}
