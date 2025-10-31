import 'package:epi/transaction.dart';
import 'package:epi/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
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
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(400, 50), // Updated size: width 400, height 70
              backgroundColor: Color(0xFF013263),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8), // Maintains rounded corners
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Transactions()),
              );
            },
            child: Text(
              "Invite Your Friends",
              style: TextStyle(
                  fontFamily: 'font', fontSize: 15, color: Colors.white),
            ),
          ),
        ),
        backgroundColor: Color(0xFFF6F6F6),
        appBar: AppBar(
          backgroundColor: Color(0xFF013263),
          centerTitle: true,
          title: Text(
            'Referral',
            style: TextStyle(fontFamily: 'font', color: Colors.white),
          ),
          // leading: Padding(
          //   padding: const EdgeInsets.all(10),
          //   child: Container(
          //     height: 30,
          //     width: 30,
          //     child: Center(
          //       child: Icon(
          //         Icons.arrow_back_ios_new,
          //         color: Colors.white,
          //       ),
          //     ),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       color: Colors.white24,
          //     ),
          //   ),
          // ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white24,
                ),
                child: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Column(
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
                      SizedBox(
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
                            trailing: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => WalletScreen(),
                                  ));
                                },
                                child: Icon(Icons.arrow_forward_ios_sharp)),
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
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                //border: Border.all(color: Color(0xFF013263)),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Text(
                  "24,000 people referred and earned!",
                  style:
                      TextStyle(fontFamily: 'font', color: Color(0xFF013263)),
                ),
              ),
            ),

            SizedBox(height: 10),
            // Space between second container and TabBar
            TabBar(
              tabs: [
                Tab(text: "Referrals"),
                Tab(text: "Transactions"),
              ],
              indicatorColor: Color(0xFF013263),
              labelColor: Color(0xFF013263),
              unselectedLabelColor: Colors.grey,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 500,
                      child: Image.asset(
                        "assets/image/img2.png", // Assuming you have a support image in your assets
                        //scale: 10,
                      ),
                    ),
                  ),
                  // Replace the Text widget with the Transactions widget
                  //TransactionsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
