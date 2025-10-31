import 'dart:async';

import 'package:epi/locator/app_db.dart';
import 'package:epi/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:shared_preferences/shared_preferences.dart';

import 'Bottom_NavigationPage.dart';
import 'introduction.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
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
    checkLoginStatus();
    _updateSystemUIOverlay();
  }

  Future<void> checkLoginStatus() async {
    // Navigate after 5 seconds
    await Future.delayed(const Duration(seconds: 3));
    if (appDB.firstTime == true) {
      if (appDB.isLogin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigationPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const introductionPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: Duration(
                seconds: 5,
              ),
              alignment: Alignment.center,
              curve: Curves.linear,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/image/logo.png",
                    scale: 4,
                    alignment: Alignment.center,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40,
                    ).copyWith(top: 30),
                    child: Text(
                      "Invest small, Dream big, Own it!",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 28,
                        color: Color(0xff12111f),
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Copyright | Version 2.1",
                  style: TextStyle(
                    color: Color(0xff5e5e5e),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto",
                  ),
                )
              ],
            ),
          )
        ],
      ),

      /*Center(
        child: Stack(
          children: [
            Container(
              alignment: const Alignment(0, 0),
              decoration: const BoxDecoration(),
              child: const Text(
                "EPI",
                style: TextStyle(
                    fontFamily: "font", letterSpacing: 30, fontSize: 100),
              ),
            ),
            const Align(
              alignment: Alignment(0, .2),
              child: Text(
                "Invest Small, Dream Big Own It!",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "font",
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ).animate().fade(duration: const Duration(seconds: 2)),
      ),*/
    );
  }
}
