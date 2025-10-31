import 'dart:convert';

import 'package:epi/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api_service/auth_service.dart';

class PromotionalHomePage extends StatefulWidget {
  const PromotionalHomePage({super.key});

  @override
  _PromotionalHomePageState createState() => _PromotionalHomePageState();
}

class _PromotionalHomePageState extends State<PromotionalHomePage> {
  List<dynamic> products = [];
  bool isLoading = true;
  String? userName;
  String? email;

  Future<void> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    userName = prefs.getString('name');
    email = prefs.getString('email');
  }

  Future<void> fetchProducts() async {
    const String url = 'http://16.171.26.118/display_100product.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status_code'] == 200) {
          setState(() {
            products = data['products'];
            isLoading = false;
          });
        } else {
          showError(data['msg']);
        }
      } else {
        showError("Status code: ${response.statusCode}");
      }
    } catch (e) {
      showError("Internet error!");
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF010C15),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gradient Header
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF12111F),
                    Color(0xFF1E202C),
                    Color(0xFF444E5A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Avatar
                        Container(
                          width: 60,
                          // increased from 49
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xFF0D2D50),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.all(4),
                          // reduced to allow more image space
                          child: Image.asset(
                            'assets/newui/avatar.png',
                            fit: BoxFit.contain,
                          ),
                          /*Image.network(
                            user?.photoURL ?? "",
                            fit: BoxFit.contain,
                          ),*/
                        ),
                        SizedBox(width: 16),
                        // Greeting text
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Hi!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              userName ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Ribbon icon button
                        Container(
                          width: 50,
                          // increased from 42
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.all(6),
                          // reduced from 10
                          child: Image.asset(
                            'assets/newui/reward.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 10),
                        // Notification icon with red dot
                        Stack(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.all(6),
                              child: Image.asset(
                                'assets/newui/notification.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                width: 10, // slightly larger red dot
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Explore More Banner
            Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                color: Color(0xFF072849), // fallback color
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
                image: DecorationImage(
                  image: AssetImage("assets/newui/bg_image.png"),
                  // replace with your image path
                  fit: BoxFit
                      .cover, // or BoxFit.fill / BoxFit.fitWidth / BoxFit.fitHeight
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(
                          alpha: 0.5), // optional overlay for readability
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    right: 20,
                    child: Column(
                      children: [
                        Text(
                          "EXPLORE MORE !!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Just save minimum ₹100 everyday to get your desired product",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Image.asset("assets/newui/products.png", height: 150),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 99, vertical: 10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Start Purchasing",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_forward, color: Colors.black),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF4FC3F7), width: 1),
                color: Color(0xFF071730), // Dark background
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 1,
                    color: Color(0xFF4FC3F7).withValues(alpha: 0.5),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "24,000 people referred and earned!",
                    style: TextStyle(
                      color: Color(0xFF4FC3F7),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 30,
                    height: 1,
                    color: Color(0xFF4FC3F7).withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 45,
            ),
            // Refer & Earn Banner
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              height: 195,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFC396E8),
                    Color(0xFFB1BBBA),
                    Color(0xFFFFFFFF),
                    Color(0xFF60CAF3)
                  ],
                  // begin: Alignment.topLeft,
                  // end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Stack(
                children: [
                  // Background Image
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      "assets/newui/earn_money.png",
                      // Make sure this path is correct
                      height: 250,
                    ),
                  ),

                  // Text + CTA Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "REFER EPI",
                          style: TextStyle(
                            color: Color(0xFF4FC3F7),
                            fontSize: 12,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Earn Money\nEveryday!",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Refer A Friend Now",
                            style: TextStyle(
                              color: Color(0xFF023E8A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Inside your build method or wherever your widget tree goes:
            SizedBox(
              height: 45,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Quick Access',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 180,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        // Card 1
                        Container(
                          width: 180,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFF2C2B3F),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.shopping_basket,
                                      size: 40, color: Colors.amber),
                                  Spacer(),
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Color(0xFF3E3C53),
                                    child: Icon(Icons.arrow_forward_ios,
                                        size: 12, color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Lorem ipsum do',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Lorem ipsum dol sit ame, consect etur adi.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 30),

                        // Card 2
                        Container(
                          width: 180,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFF2C2B3F),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.account_balance_wallet,
                                      size: 40, color: Colors.lightBlue),
                                  Spacer(),
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Color(0xFF3E3C53),
                                    child: Icon(Icons.arrow_forward_ios,
                                        size: 12, color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Lorem ipsum do',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Lorem ipsum dol sit ame, consect etur adi.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 45,
            ),
            // Product Cards
            // Wrap everything in a Column or ListView if not already
            Stack(
              children: [
                // Small, Dream text
                Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 194.0 - 0.5,
                  top: 0,
                  child: Opacity(
                    opacity: 0.2,
                    child: SizedBox(
                      width: 388,
                      height: 83,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // "Small," with stroke only
                          Stack(
                            children: [
                              Text(
                                "Small,",
                                style: TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 1.5
                                    ..color = Color(0xFF60CAF3),
                                ),
                              ),
                              Text(
                                "Small,",
                                style: TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.transparent,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                              width: 8), // spacing between "Small," and "Dream"

                          // "Dream" filled
                          Text(
                            "Dream",
                            style: TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF60CAF3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Padding to leave space for "Small, Dream" and add "FOR SPECIAL PRICE"
                Padding(
                  padding: const EdgeInsets.only(
                      top: 100), // pushes the content down below "Small, Dream"
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100.0),
                        child: Text(
                          "FOR SPECIAL PRICE",
                          style: TextStyle(
                            color: Color(0xFF60CAF3),
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Roboto Condensed',
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // reduced spacing after "FOR SPECIAL PRICE"

                      // Your product cards or any following widgets go here
                      // Example:
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      //   child: Text(
                      //     "Here comes your first product...",
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        // child: Text(
                        //   "FOR SPECIAL PRICE",
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontWeight: FontWeight.w600,
                        //     letterSpacing: 1.2,
                        //     fontSize: 14,
                        //   ),
                        // ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 340,
                        child: PageView.builder(
                          itemCount: products.take(5).length,
                          controller: PageController(viewportFraction: 0.75),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            final title = product['product_name'] ?? 'No Title';
                            final image = product['image'] ??
                                'https://via.placeholder.com/150';

                            return Transform.scale(
                              scale: 0.95,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(image,
                                        height: 140, fit: BoxFit.contain),
                                    SizedBox(height: 16),
                                    Text(
                                      title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF023E8A),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 28, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        "Buy Now",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

            SizedBox(
              height: 60,
            ),

            Padding(
              padding: EdgeInsets.only(right: 300, bottom: 50),
              child: const Text(
                'Quest',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Quest Section
            Positioned(
              left: 20,
              top: 1503,
              child: Container(
                width: 400,
                height: 200,
                decoration: BoxDecoration(
                  color: Color(0xFF101D30), // main background
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Top section with trophy and text
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/newui/trophy.png",
                              // height:
                              //     130, // You can go up to 130-150 if space allows
                              // width: 150,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                "You’ve Unlocked\nA New Quest",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ),

                    // Bottom stripe
                    Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFF2C007F), // Purple stripe
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      // padding: EdgeInsets.symmetric(horizontal: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.bolt, color: Colors.yellow, size: 25),
                          SizedBox(width: 8),
                          Text(
                            "Refer and earn, never miss a chance!",
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 60,
            ),
            // Learn About Us
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                height: 230, // Increased height to avoid overflow
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF041C35),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Large Calendar Image
                    Positioned(
                      right: -10,
                      top: 10,
                      child: Image.asset(
                        'assets/newui/calendar.png',
                        height: 200, // Bigger image
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Big Text and Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Big Text
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Why Save\nOn ",
                                  style: TextStyle(
                                    fontSize: 40, // Bigger
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: "EPI ?",
                                  style: TextStyle(
                                    fontSize: 40, // Bigger
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF60CAF3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),

                          // Know More Button
                          Container(
                            width: 220, // Wider button
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_forward,
                                    size: 20, color: Colors.black),
                                SizedBox(width: 8),
                                Text(
                                  "Know More",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 20,
              top: 1919,
              child: Opacity(
                opacity: 0.4,
                child: SizedBox(
                  width: 345.7,
                  height: 230, // updated height
                  child: Stack(
                    clipBehavior:
                        Clip.none, // allow image to slightly overflow if needed
                    children: [
                      // Token Image (Right Side)
                      Positioned(
                        right: 0,
                        bottom: -10,
                        // pull down slightly if you want more dramatic visual
                        child: Image.asset(
                          'assets/newui/coins.png',
                          width: 160,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Text Content
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Text(
                                  "Invest small",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 47,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 1.8
                                      ..color = Color(0xFF60CAF3)
                                          .withValues(alpha: 0.4),
                                  ),
                                ),
                                const Text(
                                  "Invest small",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 55,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Dream big\nown it!",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF60CAF3),
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
