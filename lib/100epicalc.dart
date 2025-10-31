import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:epi/payscheme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HundredEpicalc extends StatefulWidget {
  final String productId;
  final double price;
  final String? image;
  final String? name;
  final String? descprition;

  const HundredEpicalc(
      {super.key,
      required this.productId,
      required this.price,
      this.descprition,
      this.image,
      this.name});

  @override
  State<HundredEpicalc> createState() => _HundredEpicalcState();
}

class _HundredEpicalcState extends State<HundredEpicalc> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  double _totalAmount = 0.0;
  final double _dailyPayment = 100.0;
  int _daysRequired = 0;
  int _years = 0;
  int _months = 0;
  int _remainingDays = 0;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool termsAccepted = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _productIdController.text = widget.productId;
    _amountController.text = widget.price.toString();
    loadWishlist();
  }

  // void _calculateEPI() {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _totalAmount = double.parse(_amountController.text);
  //       _daysRequired = (_totalAmount / _dailyPayment).ceil();
  //
  //       // Calculate years, months, and days
  //       _years = _daysRequired ~/ 365;
  //       int totalMonths = (_daysRequired % 365) ~/ 30;
  //       _months = totalMonths;
  //       _remainingDays = (_daysRequired % 365) % 30;
  //
  //       _startDate = DateTime.now();
  //       _endDate = _startDate.add(Duration(days: _daysRequired));
  //     });
  //   }
  // }

  void _calculateEPI() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _totalAmount = double.parse(_amountController.text);
        _daysRequired = (_totalAmount / _dailyPayment).ceil();

        // Calculate years, months, and days
        _years = _daysRequired ~/ 365;
        int totalMonths = (_daysRequired % 365) ~/ 30;
        _months = totalMonths;
        _remainingDays = (_daysRequired % 365) % 30;

        _startDate = DateTime.now();
        _endDate = _startDate.add(Duration(days: _daysRequired));
      });

      // Show the dialog after calculations

      if (_daysRequired > 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Days Required: $_daysRequired days"),
                  const SizedBox(
                    height: 10,
                  ),
                  if (_years > 0)
                    Text(
                        "Equivalent Time: $_years years, $_months months, and $_remainingDays days"),
                  const SizedBox(
                    height: 10,
                  ),
                  if (_years == 0)
                    Text(
                        "Equivalent Time: $_months months and $_remainingDays days"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      "Start Date: ${DateFormat('dd MMM yyyy').format(_startDate)}"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      "End Date: ${DateFormat('dd MMM yyyy').format(_endDate)}"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF223043),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          _showTermsAndConditionsPopup(); // Call next function
                        },
                        child: const Text(
                          "Continue",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    }
  }

  void _proceedToNextPage() async {
    try {
      await _saveResults();

      final userId = await _uploadData();
      if (userId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SchemeAndPayment(userId: userId)),
        );
      }
    } catch (e) {
      print("Error during navigation: $e");
      _showErrorDialog(
          "An error occurred while processing your request. Please try again.");
    }
  }

  Future<void> _saveResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('total_amount', _totalAmount);
    await prefs.setDouble('daily_payment', _dailyPayment);
    await prefs.setInt('days_required', _daysRequired);
    await prefs.setString('start_date', _startDate.toIso8601String());
    await prefs.setString('end_date', _endDate.toIso8601String());
  }

  Future<String?> _uploadData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id') ?? ''; // Retrieve user ID
    final productId = _productIdController.text.trim();

    try {
      final response = await http.post(
        Uri.parse('http://16.171.26.118/submit_epi.php'),
        // Replace with your EC2 instance IP
        body: {
          'product_id': productId,
          'total_amount': _totalAmount.toString(),
          'daily_payment': _dailyPayment.toString(),
          'days_required': _daysRequired.toString(),
          'start_date': _startDate.toIso8601String(),
          'end_date': _endDate.toIso8601String(),
          'user_id': userId,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Handle the updated response structure
        if (jsonResponse['status_code'] == 200 &&
            jsonResponse['status'] == "Success") {
          print('Message: ${jsonResponse['message']}');
          return userId; // Return the user ID directly since it's already stored
        } else {
          print('Unexpected response format: $jsonResponse');
          _showErrorDialog(jsonResponse['message'] ??
              "An error occurred. Please try again.");
        }
      } else {
        print('Server error: ${response.statusCode}');
        _showErrorDialog("Server error occurred. Please try again later.");
      }
    } catch (e) {
      print('Error during data upload: $e');
      _showErrorDialog(
          "An error occurred. Please check your connection and try again.");
    }

    return null;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Set<String> wishlist = {};

  Future<void> loadWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      wishlist = (prefs.getStringList('wishlist') ?? []).toSet();
    });
  }

  Future<void> toggleWishlist(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (wishlist.contains(productId)) {
        wishlist.remove(productId);
      } else {
        wishlist.add(productId);
      }
      prefs.setStringList('wishlist', wishlist.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_back_ios)),
                    Container(
                      height: MediaQuery.of(context).size.height * .3,
                      width: MediaQuery.of(context).size.height * .3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage("${widget.image}"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_forward_ios)),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .75,
                      child: Text(
                        '${widget.name?.toUpperCase()}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: "font",
                            overflow: TextOverflow.clip),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        wishlist.contains(widget.productId)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () => toggleWishlist(widget.productId),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  " ₹${widget.price.toString()}",
                  style: const TextStyle(
                      fontFamily: "font",
                      overflow: TextOverflow.ellipsis,
                      fontSize: 15),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${widget.descprition}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    overflow: TextOverflow.clip,
                  ),
                ),
                const Divider(),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "100rs Daily:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: "font"),
                    ),

                    ElevatedButton(
              onPressed:_calculateEPI,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF223043),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: const Size(120, 35),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text(
                'Calculate',
                style: TextStyle(color: Colors.white, fontFamily: "font"),
              ),
            ),
                   
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final List<bool> _checkboxValues = [false, false, false, false, false, false];

  bool get _canProceed {
    bool term5Selected = _checkboxValues[4];
    int selectedCount =
        _checkboxValues.sublist(0, 4).where((value) => value).length;
    return (term5Selected && selectedCount == 4);
  }

  void _showTermsAndConditionsPopup() {
    bool showMoreDetails = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                "Investment and Product Purchase Agreement (Bond) Acknowledgment",
                style: TextStyle(fontFamily: "font", fontSize: 18),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "By participating in the EPI (Easy Purchase Investment) program, I, the undersigned, acknowledge and agree to the following terms:",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontFamily: "font",
                          overflow: TextOverflow.clip),
                    ),
                    if (showMoreDetails)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            // const Text(
                            //     style: TextStyle(
                            //         fontSize: 12, color: Colors.black),
                            //     "By participating in the EPI (Easy Purchase Investment) program, I, the undersigned, acknowledge and agree to the following terms:"),
                            const Text(
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                                "\n1. Investment Terms I understand that my daily investment of ₹[amount] will accumulate over the selected investment period (e.g., 6 months, 12 months) for the purpose of purchasing a product or earning commission rewards."),
                            const Text(
                              "\n2. Product Purchase I agree that at the end of the investment period, I will receive the product I have selected or an equivalent product, or if I choose, I can withdraw the invested amount (less applicable fees or penalties) within 7 days.",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            ),
                            const Text(
                              "\n3. Commission Earnings I understand that I will earn commissions based on my referrals and daily investment. If I choose not to purchase the product, I agree to the deduction from my earned commission as specified in the program.",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            ),
                            const Text(
                              "\n4. Withdrawal and Non-Purchase Clause If I decide not to purchase the product, I acknowledge that a portion of my earned commission will be deducted as per the conditions of this agreement, and the remaining balance will be credited back to me.",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            ),
                            const Text(
                              "\n5. Saoirse's Responsibility I understand that Saoirse IT Solutions LLP will manage the funds securely, and they are responsible for delivering the product or returning the invested funds within 7 days of the investment period’s completion.",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            ),
                            const Text(
                              "\n6. Legal Terms and Binding Agreement"
                              "\n6.1 Legal Binding Agreement: \nThis Agreement is a legally binding contract between the investor (hereinafter referred to as 'User') and Saoirse IT Solutions LLP (hereinafter referred to as 'Saoirse'). By accepting this Agreement, the User agrees to adhere to all the terms and conditions outlined herein.",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            ),
                            const Text(
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                                "\n6.2 Jurisdiction: \nThis Agreement shall be governed by and construed in accordance with the laws of India. Any disputes arising from this Agreement shall be resolved exclusively in the courts located in [location], India."),
                            const Text(
                              "\n6.3 Compliance with Laws: \nThe User agrees to comply with all applicable laws, regulations, and rules concerning investments, withdrawals, and earnings within the framework of the EPI program.",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            ),
                            const Text(
                              "\n6.4 Termination: \nSaoirse reserves the right to terminate this Agreement if the User engages in any fraudulent or illegal activity, violates the terms, or fails to meet the program's conditions.",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            ),
                            const Text(
                              "\n6.5 Legal Recourse: \nIf Saoirse fails to fulfill its obligations under this Agreement, including but not limited to the failure to deliver the product or return the invested funds within the specified time frame, the User has the right to seek legal recourse. The User may file a lawsuit against Saoirse IT Solutions LLP in accordance with Indian laws and regulations. Legal action must be initiated within 7 to 10 days from the date the User is notified of the failure to fulfill the obligation.",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            ),

                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              "Digital Acknowledgment",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontFamily: "font"),
                            ),

                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              subtitle: const Text(
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                  "\n1. I acknowledge and agree to the terms and conditions of the Investment and Product Purchase Agreement (Bond) as outlined above."),
                              value: _checkboxValues[0],
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _checkboxValues[0] = newValue ?? false;
                                });
                              },
                            ),
                            // Checkbox for Term 2
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              subtitle: const Text(
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                  "\n2. I confirm that I am participating voluntarily and agree to the deductions from my commission if I choose not to purchase the product."),
                              value: _checkboxValues[1],
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _checkboxValues[1] = newValue ?? false;
                                });
                              },
                            ),
                            // Checkbox for Term 3
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              subtitle: const Text(
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                  "\n3. I understand that this Agreement is legally binding and governed by the laws of India."),
                              value: _checkboxValues[2],
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _checkboxValues[2] = newValue ?? false;
                                });
                              },
                            ),
                            // Checkbox for Term 4
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              subtitle: const Text(
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                                "\n4. I acknowledge that I have the right to seek legal recourse against Saoirse IT Solutions LLP in case of failure to fulfill their obligations, within 7 to 10 days from the notification of failure.",
                              ),
                              value: _checkboxValues[3],
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _checkboxValues[3] = newValue ?? false;
                                });
                              },
                            ),
                            const Text(
                              "Digital Signature",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontFamily: "font"),
                            ),
                            const Text(
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                              "\nBy clicking the 'I Agree' button below, I digitally sign this Agreement and confirm my understanding and acceptance of the terms outlined above.",
                            ),

                            // Checkbox for Term 5 (Agree to proceed)
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              subtitle: const Text(
                                '5. I Agree',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              value: _checkboxValues[4],
                              onChanged: (bool? newValue) {
                                setState(() {
                                  // Deselect the 6th checkbox if 5th is selected
                                  if (newValue == true) {
                                    _checkboxValues[5] = false;
                                  }
                                  _checkboxValues[4] = newValue ?? false;
                                });
                              },
                            ),
                            // Checkbox for Term 6 (Do not agree)
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              subtitle: const Text(
                                '6. I Do Not Agree',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              value: _checkboxValues[5],
                              onChanged: (bool? newValue) {
                                setState(() {
                                  // Deselect the 5th checkbox if 6th is selected
                                  if (newValue == true) {
                                    _checkboxValues[4] = false;
                                  }
                                  _checkboxValues[5] = newValue ?? false;
                                });
                              },
                            ),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10),
                                text:
                                    "This updated version now specifies that users must initiate legal action within 7 to 10 days if Saoirse does not fulfill its obligations, giving clear timelines for users to act if necessary.",
                              ),
                            )
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showMoreDetails = !showMoreDetails;
                        });
                      },
                      child: Text(
                        showMoreDetails ? "<< Show Less" : "Read Full >>",
                        style: const TextStyle(color: Colors.deepPurpleAccent),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black, fontFamily: "font"),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _canProceed ? const Color(0xFF223043) : Colors.grey),
                  onPressed: _canProceed
                      ? () {
                          Navigator.of(context).pop();
                          _proceedToNextPage();
                        }
                      : null,
                  child: Text(
                    "Agree",
                    style: TextStyle(
                        color: _canProceed ? Colors.white : Colors.black,
                        fontFamily: "font"),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
