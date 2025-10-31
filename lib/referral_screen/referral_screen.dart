import 'package:epi/common_widget/gradiant_border_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common_widget/common_back_button.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController referralController;
  late TabController tabController;
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
    tabController = TabController(length: 2, vsync: this);
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
  void dispose() {
    referralController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: referralController,
        physics: ClampingScrollPhysics(),
        scrollBehavior: ScrollBehavior(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 109,
              floating: false,
              pinned: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                    color: Color(0xff013263),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ValueListenableBuilder(
                          valueListenable: showTransactions,
                          builder: (context, transactionView, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CommonAppbarButton(
                                  buttonColor:
                                      Color(0xfff2f2f2).withValues(alpha: 0.20),
                                  iconColor: Colors.white,
                                ),
                                Expanded(
                                  child: transactionView
                                      ? SizedBox.shrink()
                                      : Text(
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
                                transactionView
                                    ? GradientBorderContainer(
                                        width: 100,
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
                                                Text("200.0")
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
                                        buttonColor: Color(0xfff2f2f2)
                                            .withValues(alpha: 0.20),
                                        iconColor: Colors.white,
                                        icon: Icons.more_vert,
                                      ),
                              ],
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
            /*    SliverPersistentHeader(
            pinned: false,
            delegate: StickyHeaderDelegate(
              child: ColoredBox(
                  color: Color(0xff013263),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 330,
                            width: 500,
                            decoration: BoxDecoration(
                              color: Color(0xFF013263),
                              border: Border.all(color: Color(0xFF013263)),
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
                                      fontFamily: 'font',
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                                Text(
                                  "Just share your referral code",
                                  style: TextStyle(
                                      fontFamily: 'font',
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 100,
                                  width: 400,
                                  child: Image.asset(
                                    "assets/image/img.png", // Assuming you have a support image in your assets
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    height: 60,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Copy Code :",
                                          style: TextStyle(
                                              fontFamily: 'font',
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          "WWLL25",
                                          style: TextStyle(
                                              fontFamily: 'font',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        SizedBox(
                                          width: 80,
                                        ),
                                        Icon(
                                          Icons.copy,
                                          color: Colors.white,
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 260),
                              child: Container(
                                height: 150,
                                width: 350,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Image.asset(
                                          "assets/image/wallet.png"),
                                      title: Text(
                                        "200.00",
                                        style: TextStyle(
                                            fontFamily: 'font',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        "Wallet Balance",
                                        style: TextStyle(fontFamily: 'font'),
                                      ),
                                      trailing:
                                          Icon(Icons.arrow_forward_ios_sharp),
                                    ),
                                    Divider(
                                      color: Colors.black,
                                    ),
                                    ListTile(
                                      title: Text("Copy Code"),
                                      trailing: Icon(Icons.copy),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 30,
                        width: 300,
                        child: Center(
                          child: Text(
                            "24,000 people referred and earned!",
                            style: TextStyle(
                                fontFamily: 'font', color: Color(0xFF013263)),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          //border: Border.all(color: Color(0xFF013263)),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate(
            [
              TabBar(
                controller: tabController,
                // labelColor: labelColor ?? primaryColor,
                // unselectedLabelColor: unselectedLabelColor ?? darkgreyColor,
                indicatorColor: Color(0xff013263),
                onTap: (value) {},
                physics: const NeverScrollableScrollPhysics(),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xff013263),
                    fontFamily: "Roboto"),
                unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xff5e5e5e),
                    fontFamily: "Roboto"),
                dividerColor: Color(0xff013263),
                dividerHeight: 2,
                indicatorWeight: 5.0,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
                // indicator: indicator ?? CustomTabIndicator(),
                tabs: [
                  Tab(
                    text: "Referral (3)",
                  ),
                  Tab(
                    text: "Transaction",
                  ),
                ],
              ),
              TabBarView(controller: tabController, children: [
                Expanded(child: Column()),
                Expanded(child: Column()),
              ])
            ],
          ))*/
          ];
        },
        body: Column(),
      ),
    );
  }
}

class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  StickyHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 299.0;

  @override
  double get minExtent => 20.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

// expanded view
/*
 Stack(
              children: [
                Container(
                  height: 330,
                  width: 500,
                  decoration: BoxDecoration(
                    color: Color(0xFF013263),
                    border: Border.all(color: Color(0xFF013263)),
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
                            fontFamily: 'font',
                            color: Colors.white,
                            fontSize: 15),
                      ),
                      Text(
                        "Just share your referral code",
                        style: TextStyle(
                            fontFamily: 'font',
                            color: Colors.white,
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 100,
                        width: 400,
                        child: Image.asset(
                          "assets/image/img.png", // Assuming you have a support image in your assets
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          height: 60,
                          width: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Copy Code :",
                                style: TextStyle(
                                    fontFamily: 'font',
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                              Text(
                                "WWLL25",
                                style: TextStyle(
                                    fontFamily: 'font',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                width: 80,
                              ),
                              Icon(
                                Icons.copy,
                                color: Colors.white,
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 260),
                    child: Container(
                      height: 150,
                      width: 350,
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
                                  fontFamily: 'font',
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Wallet Balance",
                              style: TextStyle(fontFamily: 'font'),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_sharp),
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          ListTile(
                            title: Text("Copy Code"),
                            trailing: Icon(Icons.copy),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 30,
              width: 300,
              child: Center(
                child: Text(
                  "24,000 people referred and earned!",
                  style:
                      TextStyle(fontFamily: 'font', color: Color(0xFF013263)),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                //border: Border.all(color: Color(0xFF013263)),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
*/

// collapsed view
/*
// wallet view
Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Container(
                height: 60,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 5),
                          Container(
                            height: 20,
                            width: 20,
                            child: Image.asset("assets/image/wallet.png"),
                          ),
                          SizedBox(width: 10),
                          Text("200.00"),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text("Wallet balance", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ),


 // how it work
 InkWell(
              child: Container(
                height: 40,
                width: 350,
                decoration: BoxDecoration(
                  color: Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      "How It Works",
                      style: TextStyle(
                        fontFamily: 'font',
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 190),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        //color: Color(0xFFF6F6F6),
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 20),
                            Image.asset(
                              "assets/image/works.png", // Ensure this path matches your assets
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 15),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                title: Text(
                                  'WWLL205',
                                  style: TextStyle(
                                    fontFamily: 'font',
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  "Refer your friend",
                                  style: TextStyle(
                                    fontFamily: 'font',
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Icon(Icons.copy),
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
            ),
*/
