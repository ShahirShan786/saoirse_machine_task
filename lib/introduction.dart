import 'package:epi/intro/intro_page1.dart';
import 'package:epi/intro/intro_page2.dart';
import 'package:epi/intro/intro_page3.dart';
import 'package:epi/locator/app_db.dart';
import 'package:epi/logIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: camel_case_types
class introductionPage extends StatefulWidget {
  const introductionPage({super.key});

  @override
  State<introductionPage> createState() => _introductionPageState();
}

// ignore: camel_case_types
class _introductionPageState extends State<introductionPage> {
  PageController controller = PageController();
  bool onLastPage = false;

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
    _updateSystemUIOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              intro_page1(),
              intro_page2(),
              intro_page3(),
            ],
          ),
          const SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
          ),
          Container(
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      controller.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    child: Text(
                      "Back",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey.shade700),
                    )),
                const SizedBox(
                  width: 15,
                ),
                SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                  effect: ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      dotColor: Colors.grey.shade400,
                      activeDotColor: Colors.black),
                ),
                const SizedBox(
                  width: 30,
                ),
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          appDB.firstTime = true;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const logIn(),
                            ),
                          );
                        },
                        child: const Text(
                          "Start",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ))
                    : GestureDetector(
                        onTap: () {
                          controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey.shade700),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
