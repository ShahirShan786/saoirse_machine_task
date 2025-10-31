import 'package:epi/common_widget/common_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'locator/app_db.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
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
        preferredSize: Size(double.infinity, 230),
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
                    CommonAppbarButton(
                      buttonColor: Color(0xfff2f2f2).withValues(alpha: 0.20),
                      iconColor: Colors.white,
                    ),
                    Expanded(
                      child: Text(
                        "Wallet",
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
                Text(
                  "Total Wallet Balance",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Roboto",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/image/wallet.png",
                      scale: 3,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${appDB.user.wallet?.balance ?? ""}",
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "Reedem Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Roboto",
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transactions",
              style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xff013263),
              ),
            ),
            Expanded(
              child: Center(
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
                        "There is no transaction to show",
                        style: TextStyle(
                          color: Color(0xff101010),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /* ListView.separated(
          itemCount: 5,
          separatorBuilder: (context, index) => SizedBox(
            height: 15,
          ),
          padding: EdgeInsets.symmetric(vertical: 20),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return Row();
          },
        )*/
          ],
        ),
      ),
    );
  }
}
