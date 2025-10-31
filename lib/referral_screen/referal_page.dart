import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common_widget/common_back_button.dart';
import '../common_widget/gradiant_border_container.dart';
import '../locator/app_db.dart';
import '../wallet_screen.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  late ScrollController referralController;
  late ValueNotifier<bool> showTransactions;

  void _updateSystemUIOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Color(0xFF013263),
          statusBarIconBrightness: Brightness.light,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _updateSystemUIOverlay();
    showTransactions = ValueNotifier(false);
    referralController = ScrollController();
    referralController.addListener(
      () {
        if (referralController.offset > 200 &&
            showTransactions.value == false) {
          showTransactions.value = true;
        } else if (referralController.offset <= 200 &&
            showTransactions.value == true) {
          showTransactions.value = false;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(400, 50),
            backgroundColor: Color(0xFF013263),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {},
          child: Text(
            "Invite Your Friends",
            style: TextStyle(
                fontFamily: 'Roboto', fontSize: 15, color: Colors.white),
          ),
        ),
      ),
      backgroundColor: Color(0xFFF6F6F6),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          controller: referralController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              ValueListenableBuilder(
                valueListenable: showTransactions,
                builder: (context, titleView, child) {
                  return SliverAppBar(
                    pinned: true,
                    floating: true,
                    expandedHeight: 480,
                    collapsedHeight: 120,
                    backgroundColor: Colors.white,
                    /*toolbarHeight: 60,
                    backgroundColor: Color(0xFF013263),
                    centerTitle: true,
                    excludeHeaderSemantics: true,
                    automaticallyImplyLeading: false,
                    title: Text(
                      titleView ? "" : "Reference",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Roboto",
                      ),
                    ),*/
                    bottom: PreferredSize(
                      preferredSize: Size(double.infinity, 50),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            style: BorderStyle.none,
                          ),
                        ),
                        child: TabBar(
                          indicatorColor: Color(0xFF013263),
                          dividerColor: Colors.transparent,
                          labelColor: Color(0xFF013263),
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(text: "Referrals"),
                            Tab(text: "Transactions"),
                          ],
                        ),
                      ),
                    ),
                    /* actions: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 18.0,
                        ),
                        child: titleView
                            ? GradientBorderContainer(
                                width: 120,
                                containerColor: Color(0xff013263),
                                topLeftRadius: 10,
                                bottomLeftRadius: 10,
                                bottomRightRadius: 10,
                                topRightRadius: 10,
                                contentPadding: EdgeInsets.all(8),
                                content: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/newui/wallet_balance_small.png",
                                          scale: 3,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          "200.0",
                                          style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "Wallet Balance",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                borderGradient: LinearGradient(
                                  colors: [
                                    Color(0xffC396E8),
                                    Color(0xff60CAF3),
                                    Color(0xffB1BBBA),
                                    Color(0xffFFFFFF),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              )
                            : CommonAppbarButton(
                                icon: Icons.more_vert_outlined,
                                iconColor: Colors.white,
                                buttonColor:
                                    Color(0xfff2f2f2).withValues(alpha: 0.20),
                              ),
                      )
                    ],*/
                    flexibleSpace: titleView == false
                        ? Container(
                            height: 440,
                            /* padding: EdgeInsets.only(
                              top: 70,
                            ), */
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 60,
                                  width: double.infinity,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color(0xff013263),
                                      border:
                                          Border.all(style: BorderStyle.none),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Referral",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Roboto",
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          CommonAppbarButton(
                                            icon: Icons.more_vert_outlined,
                                            iconColor: Colors.white,
                                            buttonColor: Color(0xfff2f2f2)
                                                .withValues(alpha: 0.20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 370,
                                  child: Stack(
                                    children: [
                                      Container(
                                        // height: 350,
                                        padding: EdgeInsets.only(bottom: 100),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF013263),
                                          border: Border.all(
                                              style: BorderStyle.none,
                                              color: Colors.transparent),
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(15),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Invite your friend",
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              "Just share your referral code",
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Image.asset(
                                              scale: 1.5,
                                              "assets/image/img.png", // Assuming you have a support image in your assets
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 20,
                                        right: 20,
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    leading: Image.asset(
                                                        "assets/image/wallet.png"),
                                                    title: Text(
                                                      "${appDB.user.wallet?.balance}",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    subtitle: Text(
                                                      "Wallet Balance",
                                                      style: TextStyle(
                                                          fontFamily: 'font'),
                                                    ),
                                                    trailing: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                WalletScreen(),
                                                          ));
                                                        },
                                                        child: Icon(Icons
                                                            .arrow_forward_ios_sharp)),
                                                  ),
                                                  Divider(
                                                    color: Colors.black,
                                                  ),
                                                  ListTile(
                                                    title: Text(
                                                        "Copy Code : ${appDB.user.referralCode}"),
                                                    trailing: GestureDetector(
                                                        onTap: () {
                                                          copyToClipboard(appDB
                                                                  .user
                                                                  .referralCode ??
                                                              "");
                                                        },
                                                        child:
                                                            Icon(Icons.copy)),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              padding: EdgeInsets.symmetric(
                                                vertical: 5,
                                              ),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Color(0xffABE8FF),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: Text(
                                                "24,000 people referred and earned!",
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                    color: Color(0xFF013263)),
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
                          )
                        : DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color(0xfff2f2f2),
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xff013263),
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(15),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 7)
                                      .copyWith(bottom: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WalletScreen(),
                                            ),
                                          );
                                        },
                                        child: GradientBorderContainer(
                                          width: 120,
                                          containerColor: Color(0xff013263),
                                          topLeftRadius: 10,
                                          bottomLeftRadius: 10,
                                          bottomRightRadius: 10,
                                          topRightRadius: 10,
                                          contentPadding: EdgeInsets.all(8),
                                          content: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/newui/wallet_balance_small.png",
                                                    scale: 3,
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    "${appDB.user.wallet?.balance}",
                                                    style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Text(
                                                "Wallet Balance",
                                                style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                          borderGradient: LinearGradient(
                                            colors: [
                                              Color(0xffC396E8),
                                              Color(0xff60CAF3),
                                              Color(0xffB1BBBA),
                                              Color(0xffFFFFFF),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "How it works?",
                                          style: TextStyle(
                                            fontFamily: "Roboto",
                                            color: Color(0xff101010),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: SizedBox(
                                                    width: double.infinity,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(height: 20),
                                                        Image.asset(
                                                          "assets/image/works.png",
                                                          // Ensure this path matches your assets
                                                          fit: BoxFit.cover,
                                                        ),
                                                        SizedBox(height: 15),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border:
                                                                Border.all(),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: ListTile(
                                                            title: Text(
                                                              appDB.user
                                                                      .referralCode ??
                                                                  "",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            subtitle: Text(
                                                              "Refer your friend",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            trailing:
                                                                GestureDetector(
                                                              onTap: () {
                                                                copyToClipboard(
                                                                    appDB.user
                                                                            .referralCode ??
                                                                        "");
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Icon(
                                                                  Icons.copy),
                                                            ),
                                                          ),
                                                        ),
                                                        // Container(
                                                        //   height: 70,
                                                        //   width: 300,
                                                        //   decoration: BoxDecoration(
                                                        //     border: Border.all(),
                                                        //     borderRadius: BorderRadius.circular(18),

                                                        //   ),
                                                        // )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: Colors.black,
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                  );
                },
              ),
            ];
          },
          body: Column(
            children: [
              Expanded(
                // Adjust height as needed for scrollability
                child: TabBarView(
                  children: [
                    Center(
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
                            "Waiting for users to register with your referral code.",
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
                    )),
                    Center(
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
                            "There is no transaction in your account",
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
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to copy the coupon code to the clipboard
  void copyToClipboard(String couponCode) async {
    await Clipboard.setData(
      ClipboardData(text: couponCode),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "You have copied your Referral Code.",
        ),
      ),
    );
  }
}

// new code

//  old code
/*class _ReferralPageState extends State<ReferralPage> {
  void _updateSystemUIOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Color(0xFF013263),
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
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(400, 50),
            backgroundColor: Color(0xFF013263),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {},
          child: Text(
            "Invite Your Friends",
            style: TextStyle(fontFamily: 'font', fontSize: 15, color: Colors.white),
          ),
        ),
      ),
      backgroundColor: Color(0xFFF6F6F6),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: false,
                expandedHeight: 200   ,
                backgroundColor: Color(0xFF013263),
               flexibleSpace: FlexibleSpaceBar(
                 titlePadding: EdgeInsetsDirectional.only(start: 16, bottom: 16),
                 title: innerBoxIsScrolled
                     ? Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(
                       "Referral",
                       style: TextStyle(color: Colors.white, fontFamily: 'font'),
                     ),
                     Container(
                       padding: EdgeInsets.all(6),
                       decoration: BoxDecoration(
                         color: Colors.white24,
                         borderRadius: BorderRadius.circular(8),
                       ),
                       child: Icon(Icons.more_vert, color: Colors.white),
                     ),
                   ],
                 )
                     : Text( // Add a placeholder or null for the expanded state title if needed
                   "HIIIIII",
                   style: TextStyle(color: Colors.transparent), // Make it transparent
                 ),
              */ /*   background: Stack(
                   children: [
                     Container(
                       padding: EdgeInsets.only(top: 80),
                       width: double.infinity,
                       decoration: BoxDecoration(
                         color: Color(0xFF013263),
                         borderRadius: BorderRadius.only(
                           bottomLeft: Radius.circular(20),
                           bottomRight: Radius.circular(20),
                         ),
                       ),
                       child: Column(
                         children: [
                           Text(
                             "Invite your friend",
                             style: TextStyle(
                                 fontFamily: 'font', color: Colors.white, fontSize: 16),
                           ),
                           Text(
                             "Just share your referral code",
                             style: TextStyle(
                                 fontFamily: 'font', color: Colors.white, fontSize: 20),
                           ),
                           SizedBox(height: 20),
                           Container(
                             height: 100,
                             width: 400,
                             child: Image.asset("assets/image/img.png"),
                           ),
                           SizedBox(height: 10),
                         ],
                       ),
                     ),
                     Positioned(
                       bottom: 80,
                       left: 20,
                       right: 20,
                       child: Container(
                         height: 147,
                         decoration: BoxDecoration(
                           color: Colors.white,
                           border: Border.all(),
                           borderRadius: BorderRadius.circular(20),
                         ),
                         child: Column(
                           children: [
                             ListTile(
                               leading: Image.asset("assets/image/wallet.png"),
                               title: Text(
                                 "200.00",
                                 style: TextStyle(
                                     fontFamily: 'font', fontWeight: FontWeight.bold),
                               ),
                               subtitle: Text(
                                 "Wallet Balance",
                                 style: TextStyle(fontFamily: 'font'),
                               ),
                               trailing: Icon(Icons.arrow_forward_ios_sharp),
                             ),
                             Divider(color: Colors.black),
                             ListTile(
                               title: Text("Copy Code"),
                               trailing: Icon(Icons.copy),
                             )
                           ],
                         ),
                       ),
                     ),
                   ],
                 ),*/ /*
               ),
               */ /* flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsetsDirectional.only(start: 16, bottom: 16),
                  title: innerBoxIsScrolled
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Referral",
                        style: TextStyle(color: Colors.white, fontFamily: 'font'),
                      ),
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.more_vert, color: Colors.white),
                      ),
                    ],
                  )
                      : null,
                 */ /**/ /* background: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 80),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFF013263),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Invite your friend",
                              style: TextStyle(
                                  fontFamily: 'font', color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              "Just share your referral code",
                              style: TextStyle(
                                  fontFamily: 'font', color: Colors.white, fontSize: 20),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 100,
                              width: 400,
                              child: Image.asset("assets/image/img.png"),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 60,
                              width: 300,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Copy Code:",
                                    style: TextStyle(
                                        fontFamily: 'font',
                                        color: Colors.white,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "WWLL25",
                                    style: TextStyle(
                                        fontFamily: 'font',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                  Icon(Icons.copy, color: Colors.white),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 80,
                        left: 20,
                        right: 20,
                        child: Container(
                          height: 147,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Image.asset("assets/image/wallet.png"),
                                title: Text(
                                  "200.00",
                                  style: TextStyle(
                                      fontFamily: 'font', fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "Wallet Balance",
                                  style: TextStyle(fontFamily: 'font'),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios_sharp),
                              ),
                              Divider(color: Colors.black),
                              ListTile(
                                title: Text("Copy Code"),
                                trailing: Icon(Icons.copy),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),*/ /**/ /*
                ),*/ /*
                */ /*bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Container(
                    color: Colors.lightBlue,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "24,000 people referred and earned!",
                      style: TextStyle(
                        fontFamily: 'font',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),*/ /*
              ),
            ];
          },
          body: Column(
            children: [
             */ /* TabBar(
                indicatorColor: Color(0xFF013263),
                labelColor: Color(0xFF013263),
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Referrals"),
                  Tab(text: "Transactions"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/image/img2.png",
                        width: 200,
                        height: 500,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Transactions List Here",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),*/ /*
            ],
          ),
        ),
      ),
    );
  }
}*/
