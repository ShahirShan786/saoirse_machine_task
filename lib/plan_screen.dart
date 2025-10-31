import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common_widget/common_back_button.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  void _updateSystemUIOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Color(0xff013263),
          statusBarIconBrightness: Brightness.light,
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
    _updateSystemUIOverlay();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 133),
        child: SafeArea(
          top: true,
          bottom: false,
          right: false,
          left: false,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
              color: Color(0xff013263),
            ),
            padding: EdgeInsets.only(left: 20, bottom: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: Text(
                        "Plan",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Roboto",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    CommonAppbarButton(
                      buttonColor: Color(0xfff2f2f2).withValues(alpha: 0.20),
                      iconColor: Colors.white,
                      icon: Icons.more_vert,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                IntrinsicHeight(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildMRPText(amount: 0),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Amount to be paid",
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      width: 10,
                      color: Colors.white.withValues(alpha: 0.20),
                      thickness: 1,
                      indent: 5,
                      endIndent: 5,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildMRPText(
                            amount: 0,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Paid Amount",
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/newui/no_data.png",
              scale: 3,
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                "There is no ongoing plan",
                style: TextStyle(
                  color: Color(0xff101010),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Roboto",
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMRPText({
    required double amount,
  }) {
    return Text(
      "₹$amount",
      style: TextStyle(
          color: Color(0xffFFFFFF),
          fontFamily: "Roboto",
          fontSize: 20,
          fontWeight: FontWeight.w800),
    );
  }
}
