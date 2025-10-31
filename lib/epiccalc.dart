// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:epi/payscheme.dart';
// import 'package:neumorphic_button/neumorphic_button.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class Epicalc extends StatefulWidget {
//   final String productId;
//   final double price;
//   final String? image;
//   final String? name;
//
//   const Epicalc(
//       {Key? key,
//         required this.productId,
//         required this.price,
//         this.image,
//         this.name})
//       : super(key: key);
//
//   @override
//   State<Epicalc> createState() => _EpicalcState();
// }
//
// class _EpicalcState extends State<Epicalc> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _productIdController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();
//   double _totalAmount = 0.0;
//   double _dailyPayment = 200.0;
//   List<double> _dailyPaymentOptions = [200, 500, 1000];
//   int _daysRequired = 0;
//   int _years = 0;
//   int _months = 0;
//   int _remainingDays = 0;
//   DateTime _startDate = DateTime.now();
//   DateTime _endDate = DateTime.now();
//   bool termsAccepted = false;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _productIdController.text = widget.productId;
//     _amountController.text = widget.price.toString();
//   }
//
//   void _calculateEPI() {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _totalAmount = double.parse(_amountController.text);
//         _daysRequired = (_totalAmount / _dailyPayment).ceil();
//
//         // Calculate years, months, and days
//         _years = _daysRequired ~/ 365;
//         int totalMonths = (_daysRequired % 365) ~/ 30;
//         _months = totalMonths;
//         _remainingDays = (_daysRequired % 365) % 30;
//
//         _startDate = DateTime.now();
//         _endDate = _startDate.add(Duration(days: _daysRequired));
//       });
//     }
//   }
//
//   void _proceedToNextPage() async {
//     try {
//       await _saveResults();
//
//       final userId = await _uploadData();
//       if (userId != null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => SchemeAndPayment(userId: userId)),
//         );
//       }
//     } catch (e) {
//       print("Error during navigation: $e");
//       _showErrorDialog(
//           "An error occurred while processing your request. Please try again.");
//     }
//   }
//
//   Future<void> _saveResults() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setDouble('total_amount', _totalAmount);
//     await prefs.setDouble('daily_payment', _dailyPayment);
//     await prefs.setInt('days_required', _daysRequired);
//     await prefs.setString('start_date', _startDate.toIso8601String());
//     await prefs.setString('end_date', _endDate.toIso8601String());
//   }
//
//   Future<String?> _uploadData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString('id') ?? ''; // Retrieve user ID
//     final productId = _productIdController.text.trim();
//
//     try {
//       final response = await http.post(
//         Uri.parse('http://16.171.26.118/submit_epi.php'),
//         // Replace with your EC2 instance IP
//         body: {
//           'product_id': productId,
//           'total_amount': _totalAmount.toString(),
//           'daily_payment': _dailyPayment.toString(),
//           'days_required': _daysRequired.toString(),
//           'start_date': _startDate.toIso8601String(),
//           'end_date': _endDate.toIso8601String(),
//           'user_id': userId,
//         },
//       );
//
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//
//         // Handle the updated response structure
//         if (jsonResponse['status_code'] == 200 &&
//             jsonResponse['status'] == "Success") {
//           print('Message: ${jsonResponse['message']}');
//           return userId; // Return the user ID directly since it's already stored
//         } else {
//           print('Unexpected response format: $jsonResponse');
//           _showErrorDialog(jsonResponse['message'] ??
//               "An error occurred. Please try again.");
//         }
//       } else {
//         print('Server error: ${response.statusCode}');
//         _showErrorDialog("Server error occurred. Please try again later.");
//       }
//     } catch (e) {
//       print('Error during data upload: $e');
//       _showErrorDialog(
//           "An error occurred. Please check your connection and try again.");
//     }
//
//     return null;
//   }
//
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Error"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         title: const Text("Make Your Plan"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Divider(),
//                 Container(
//                   height: 120,
//                   width: double.infinity,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         height: 120,
//                         width: 120,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           image: DecorationImage(
//                             image: NetworkImage("${widget.image}"),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       const Spacer(),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * .5,
//                         child: Text(
//                           '${widget.name}',
//                           style: const TextStyle(
//                               fontFamily: "font", overflow: TextOverflow.fade),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Divider(),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 TextFormField(
//                   controller: _productIdController,
//                   decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       floatingLabelBehavior: FloatingLabelBehavior.always,
//                       labelText: 'Product ID',
//                       labelStyle: TextStyle(color: Colors.grey)),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the product ID';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _amountController,
//                   decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Total Amount',
//                       labelStyle: TextStyle(color: Colors.grey)),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the total amount';
//                     }
//                     if (double.tryParse(value) == null ||
//                         double.parse(value) <= 0) {
//                       return 'Please enter a valid amount';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "Select Daily Payment Option:",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Container(
//                       decoration: const BoxDecoration(
//                           color: Color(0xFF84B5C2),
//                           borderRadius: BorderRadius.all(Radius.circular(10))),
//                       height: 40,
//                       width: MediaQuery.of(context).size.width * 0.35,
//                       child: Center(
//                         child: DropdownButton<double>(
//                           alignment: AlignmentDirectional.topStart,
//                           dropdownColor: const Color(0xFF84B5C2),
//                           value: _dailyPayment,
//                           onChanged: (double? newValue) {
//                             setState(() {
//                               _dailyPayment = newValue!;
//                             });
//                           },
//                           items: _dailyPaymentOptions
//                               .map<DropdownMenuItem<double>>((double value) {
//                             return DropdownMenuItem<double>(
//                               value: value,
//                               child: Text(
//                                 '₹${value.toStringAsFixed(2)}',
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                     NeumorphicButton(
//                       onTap: _calculateEPI,
//                       bottomRightShadowBlurRadius: 15,
//                       bottomRightShadowSpreadRadius: 1,
//                       borderWidth: 5,
//                       backgroundColor: const Color(0xFF84B5C2),
//                       topLeftShadowBlurRadius: 15,
//                       topLeftShadowSpreadRadius: 1,
//                       topLeftShadowColor: Colors.white,
//                       bottomRightShadowColor: Colors.grey.shade500,
//                       height: 40,
//                       width: MediaQuery.of(context).size.width * 0.4,
//                       padding: EdgeInsets.zero,
//                       margin: const EdgeInsets.only(right: 5, bottom: 5),
//                       bottomRightOffset: const Offset(4, 4),
//                       topLeftOffset: const Offset(-4, -4),
//                       child: const Center(
//                         child: Text(
//                           'Calculate',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 if (_daysRequired > 0) ...[
//                   Text("Days Required: $_daysRequired days"),
//                   if (_years > 0)
//                     Text(
//                         "Equivalent Time: $_years years, $_months months, and $_remainingDays days"),
//                   if (_years == 0)
//                     Text(
//                         "Equivalent Time: $_months months and $_remainingDays days"),
//                   Text(
//                       "Start Date: ${DateFormat('dd MMM yyyy').format(_startDate)}"),
//                   Text(
//                       "End Date: ${DateFormat('dd MMM yyyy').format(_endDate)}"),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _showTermsAndConditionsPopup,
//                     child: const Text("Continue"),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showTermsAndConditionsPopup() {
//     bool showMoreDetails = false;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               backgroundColor: Colors.white,
//               title: const Text(
//                 "Terms and Conditions",
//                 style: TextStyle(fontFamily: "font", fontSize: 25),
//               ),
//               content: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "By creating an account, you agree to our Terms and Conditions.",
//                       style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.black,
//                           overflow: TextOverflow.clip),
//                     ),
//                     if (showMoreDetails)
//                       const Padding(
//                         padding: EdgeInsets.only(top: 20.0),
//                         child: Text(
//                           "Terms and Conditions for Elio e-Com APK\n\n"
//                               "Effective Date: [Insert Date]\n\n"
//                               "These Terms and Conditions (\"Agreement\") govern your download, installation, and use of the Elio e-Com APK (\"App\"). By accessing or using the App, you agree to be bound by this Agreement. If you do not agree to these terms, do not use the App.\n\n"
//                               "1. Ownership\n\n"
//                               "1.1. The App is developed and owned by Saoirse IT Solutions LLP.\n"
//                               "1.2. All intellectual property rights related to the App, including logos, trademarks, and content, remain the exclusive property of Saoirse IT Solutions LLP.\n\n"
//                               "2. License to Use\n\n"
//                               "2.1. You are granted a limited, non-exclusive, non-transferable, and revocable license to use the App for personal purposes.\n"
//                               "2.2. You may not:\n"
//                               "    - Modify, copy, or distribute the App.\n"
//                               "    - Use the App for commercial purposes without authorization.\n\n"
//                               "3. Privacy and Data Protection\n\n"
//                               "3.1. Your data will be handled in accordance with our Privacy Policy.\n"
//                               "3.2. By using the App, you consent to the collection and use of your personal data as described in the Privacy Policy.\n\n"
//                               "4. Security and Misuse\n\n"
//                               "4.1. You agree not to misuse our services or attempt to compromise their security.\n"
//                               "4.2. The company reserves the right to take action if security is breached or misuse is detected.\n\n"
//                               "5. Modification of Terms\n\n"
//                               "5.1. The company reserves the right to modify these terms at any time.\n"
//                               "5.2. Any changes to the terms will be effective immediately upon posting the updated terms on the App or on the website.\n\n"
//                               "6. Contact Information\n\n"
//                               "6.1. If you have any questions regarding these Terms and Conditions, please contact us at support@eliotechno.com.\n\n"
//                               "Privacy Policy for EPI APK\n\n"
//                               "Effective Date: [Insert Date]\n\n"
//                               "This Privacy Policy governs the collection, use, and sharing of personal information by the Easy Purchase Investment (EPI) APK, an initiative of Elio e-Com, a subsidiary of Saoirse IT Solutions LLP. By using the EPI APK (\"App\"), you agree to the practices described in this Privacy Policy. If you do not agree to this policy, please do not use the App.\n\n"
//                               "1. Information We Collect\n\n"
//                               "1.1. Personal Information\n"
//                               "We collect personal information from users when they register, use the App, or engage with EPI services:\n"
//                               "  - Full name\n"
//                               "  - Email address\n"
//                               "  - Phone number\n"
//                               "  - Government-issued ID details (e.g., Aadhaar, PAN)\n"
//                               "  - Residential address\n\n"
//                               "1.2. Financial Information\n"
//                               "Payment details such as UPI, credit/debit card, or bank account information for processing transactions related to the EPI scheme.\n\n"
//                               "1.3. Usage Information\n"
//                               "We may collect information about your interactions with the App, including:\n"
//                               "  - Transaction history\n"
//                               "  - App usage patterns and preferences\n"
//                               "  - Referrals and commission tracking\n\n"
//                               "1.4. Device Information\n"
//                               "  - IP address\n"
//                               "  - Device type, model, and operating system version\n"
//                               "  - App version and crash logs\n\n"
//                               "2. How We Use Your Information\n\n"
//                               "We use the information collected for the following purposes:\n"
//                               "  - To register and manage your EPI account.\n"
//                               "  - To process your payments and investments for the EPI scheme.\n"
//                               "  - To deliver products upon successful scheme completion.\n"
//                               "  - To send you notifications about your investment progress, rewards, and any important updates related to the scheme.\n"
//                               "  - To respond to your customer service inquiries.\n"
//                               "  - To improve the functionality and user experience of the App.\n"
//                               "  - To comply with legal, regulatory, and security obligations.\n\n"
//                               "3. Sharing Your Information\n\n"
//                               "3.1. With Service Providers\n"
//                               "We may share your information with trusted third-party vendors and service providers to assist us in processing payments, managing products, or providing support services.\n\n"
//                               "3.2. Legal and Regulatory Requirements\n"
//                               "We may disclose your information when required by law, such as complying with a subpoena, court order, or other legal process, or when necessary to protect our rights and the safety of others.\n\n"
//                               "3.3. Business Transfers\n"
//                               "In the event of a merger, acquisition, or sale of assets, your personal information may be transferred to the new entity, and you will be notified via the App or email.\n\n"
//                               "4. Data Security\n\n"
//                               "4.1. We implement technical, administrative, and physical safeguards to protect your personal information.\n"
//                               "4.2. While we take reasonable measures to protect your data, no method of electronic transmission or storage is entirely secure, and we cannot guarantee 100% security.\n\n"
//                               "5. Retention of Information\n\n"
//                               "5.1. We retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required by law.\n"
//                               "5.2. After the retention period, your personal information will be securely deleted or anonymized.\n\n"
//                               "6. User Rights\n\n"
//                               "6.1. Access and Correction: You have the right to access and update your personal information through your EPI account.\n"
//                               "6.2. Data Deletion: You may request the deletion of your account and personal data, subject to any legal or contractual obligations.\n"
//                               "6.3. Opt-Out of Marketing: You can opt-out of receiving marketing communications at any time by changing your communication preferences within the App or contacting us directly.\n\n"
//                               "7. Cookies and Tracking Technologies\n\n"
//                               "7.1. We may use cookies, web beacons, and similar technologies to enhance your experience, analyze usage patterns, and improve the App's functionality.\n"
//                               "7.2. You can manage your cookie preferences by adjusting your browser or device settings.\n\n"
//                               "8. Third-Party Links\n\n"
//                               "The App may contain links to third-party websites or services. This Privacy Policy applies only to the EPI APK, and we are not responsible for the privacy practices of third-party websites. We encourage you to review their privacy policies before providing any personal information.\n\n"
//                               "9. Changes to This Privacy Policy\n\n"
//                               "We may update this Privacy Policy from time to time to reflect changes in our practices or legal requirements.\n"
//                               "Any changes will be posted within the App or communicated through email.\n"
//                               "We encourage you to periodically review this policy to stay informed about how we are protecting your information.\n\n"
//                               "10. Contact Us\n\n"
//                               "For any questions or concerns regarding this Privacy Policy, or to exercise your rights regarding your personal data, please contact us at:\n"
//                               "Email: [Insert Email Address]\n"
//                               "Phone: [Insert Phone Number]\n"
//                               "Website: [Insert Website URL]\n\n"
//                               "By using the EPI APK, you consent to the practices described in this Privacy Policy. Please ensure you review this policy periodically for updates.",
//                           style: TextStyle(fontSize: 12, color: Colors.black),
//                         ),
//                       ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           showMoreDetails = !showMoreDetails;
//                         });
//                       },
//                       child: Text(
//                         showMoreDetails
//                             ? "Show Less Details"
//                             : "Read Full Details",
//                         style: const TextStyle(color: Colors.deepPurpleAccent),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       children: [
//                         Checkbox(
//                           value: termsAccepted,
//                           onChanged: (value) {
//                             setState(() {
//                               termsAccepted = value!;
//                             });
//                           },
//                         ),
//                         // ignore: prefer_const_constructors
//                         SizedBox(width: 10),
//                         const Expanded(
//                           child: Text(
//                             "I agree to the Terms and Conditions.",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text(
//                     "Cancel",
//                     style: TextStyle(color: Colors.black, fontFamily: "font"),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: termsAccepted
//                       ? () {
//                     Navigator.of(context).pop();
//                     _proceedToNextPage();
//                   }
//                       : null,
//                   child: const Text(
//                     "Agree",
//                     style: TextStyle(color: Colors.black, fontFamily: "font"),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:epi/payscheme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Epicalc extends StatefulWidget {
  final String productId;
  final double price;
  final String? image;
  final String? name;
  final String? descprition;

  const Epicalc(
      {super.key,
      required this.productId,
      required this.price,
      this.image,
      this.descprition,
      this.name});

  @override
  State<Epicalc> createState() => _EpicalcState();
}

class _EpicalcState extends State<Epicalc> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  double _totalAmount = 0.0;
  double _dailyPayment = 200.0;
  final List<double> _dailyPaymentOptions = [200, 500, 1000];
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

  final List<bool> _checkboxValues = [false, false, false, false, false, false];

  bool get _canProceed {
    bool term5Selected = _checkboxValues[4];
    int selectedCount =
        _checkboxValues.sublist(0, 4).where((value) => value).length;
    return (term5Selected && selectedCount == 4);
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
      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   title: const Text("Make Your Plan"),
      // ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
                  height: 30,
                ),
                Text(
                  '${widget.name}',
                  style: const TextStyle(
                      fontFamily: "font", overflow: TextOverflow.ellipsis),
                  maxLines: 2,
                ),

                const Divider(),
                Row(
                  children: [
                    const Text(
                      "Amount :",
                      style: TextStyle(
                          fontFamily: "font",
                          overflow: TextOverflow.ellipsis,
                          fontSize: 18),
                    ),
                    const Spacer(),
                    Text(
                      " ₹${widget.price.toString()}",
                      style: const TextStyle(
                          fontFamily: "font",
                          overflow: TextOverflow.ellipsis,
                          fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  " ${widget.descprition}",
                  style: const TextStyle(
                      color: Colors.black54,
                      overflow: TextOverflow.clip,
                      fontSize: 12),
                ),
                const SizedBox(
                  height: 10,
                ),
                // TextFormField(
                //   enabled: false,
                //   controller: _productIdController,
                //   decoration: const InputDecoration(
                //     disabledBorder: OutlineInputBorder(),
                //     floatingLabelBehavior: FloatingLabelBehavior.always,
                //     labelText: 'Product ID',
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter the product ID';
                //     }
                //     return null;
                //   },
                // ),
                // const SizedBox(height: 20),
                // TextFormField(
                //   enabled: false,
                //   controller: _amountController,
                //   decoration: const InputDecoration(
                //     disabledBorder: OutlineInputBorder(),
                //     labelText: 'Total Amount',
                //   ),
                //   keyboardType: TextInputType.number,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter the total amount';
                //     }
                //     if (double.tryParse(value) == null ||
                //         double.parse(value) <= 0) {
                //       return 'Please enter a valid amount';
                //     }
                //     return null;
                //   },
                // ),
                const SizedBox(height: 20),
                const Text(
                  "Select Daily Payment Option:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF223043),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Center(
                        child: DropdownButton<double>(
                          alignment: AlignmentDirectional.topStart,
                          dropdownColor: const Color(0xFF223043),
                          value: _dailyPayment,
                          onChanged: (double? newValue) {
                            setState(() {
                              _dailyPayment = newValue!;
                            });
                          },
                          items: _dailyPaymentOptions
                              .map<DropdownMenuItem<double>>((double value) {
                            return DropdownMenuItem<double>(
                              value: value,
                              child: Text(
                                '₹${value.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _calculateEPI,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF223043),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: const Size(120, 40),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text(
                        'Calculate',
                        style:
                            TextStyle(color: Colors.white, fontFamily: "font"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_daysRequired > 0)
                  Center(
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Days Required: $_daysRequired days"),
                            if (_years > 0)
                              Text(
                                  "Equivalent Time: $_years years, $_months months, and $_remainingDays days"),
                            if (_years == 0)
                              Text(
                                  "Equivalent Time: $_months months and $_remainingDays days"),
                            Text(
                                "Start Date: ${DateFormat('dd MMM yyyy').format(_startDate)}"),
                            Text(
                                "End Date: ${DateFormat('dd MMM yyyy').format(_endDate)}"),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                   style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF223043),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: const Size(120, 40),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                                  onPressed: _showTermsAndConditionsPopup,
                                  child: const Text(
                                    "Continue",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
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
                          _canProceed ? const Color(0xFF84B5C2) : Colors.grey),
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
