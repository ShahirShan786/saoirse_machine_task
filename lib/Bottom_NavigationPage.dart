import 'package:epi/plan_screen.dart';
import 'package:epi/referral_screen/referal_page.dart';
import 'package:flutter/material.dart';

import 'HOME/home_screen.dart';
import 'PRODUCT/productpage.dart';
import 'Profile.dart';

class BottomNavigationPage extends StatefulWidget {
  final int navigateIndex;
  const BottomNavigationPage({super.key, this.navigateIndex = 0});

  @override
  BottomNavigationPageState createState() => BottomNavigationPageState();
  // State<Bottom_NavigationPage> createState() => _Bottom_NavigationPageState();
}

class BottomNavigationPageState extends State<BottomNavigationPage> {
  String? userId;
  int currentIndex = 0;

/*  Future<void> logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('id'); // Clear the user ID
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const logIn()),
    );
  }*/

  // Fetch userId on initialization
  @override
  void initState() {
    super.initState();
    currentIndex = widget.navigateIndex;
    // _loadUserId();
  }

/*  Future<void> _loadUserId() async {
    setState(() {
      userId = appDB.user.id; // Retrieve the user ID
    });
  }*/

  List<Widget> screens() {
    return [
      HomeScreen(),
      // PromotionalHomePage(),
      // const Homepage(),
      Productpage(),
      PlanScreen(),
      // SchemeAndPayment(userId: userId.toString()), // Pass userId here
      // const ReferralCode(),
      // const ReferralPage(),
      ReferralPage(),
      // const ReferralScreen(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavItem("assets/icon/home.png", "Home", 0),
            buildNavItem("assets/icon/menu.png", "Products", 1),
            buildNavItem("assets/icon/copy.png", "Plans", 2),
            buildNavItem("assets/icon/connect.png", "Referral", 3),
            buildNavItem("assets/icon/user.png", "Profile", 4),
          ],
        ),
      ),
      body: SafeArea(child: screens()[currentIndex]),
    );
  }

  Widget buildNavItem(String iconPath, String label, int index) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: isSelected
            ? EdgeInsets.symmetric(horizontal: 16, vertical: 8)
            : EdgeInsets.zero,
        decoration: isSelected
            ? BoxDecoration(
                color: Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: isSelected ? Color(0xFF0A245A) : Colors.grey,
            ),
            if (isSelected) SizedBox(width: 6),
            if (isSelected)
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0A245A),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
