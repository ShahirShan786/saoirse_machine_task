import 'package:flutter/material.dart';

class Transactions extends StatelessWidget {
  const Transactions({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(400, 60), // Updated size: width 400, height 70
              backgroundColor: Color(0xFF013263),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8,
                ), // Maintains rounded corners
              ),
            ),
            onPressed: () {
            },
            child: Text(
              "Invite Your Friends",
              style: TextStyle(
                fontFamily: 'font',
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 100),
                child: Text(
                  "Hi..!",
                  style: TextStyle(fontFamily: 'font', fontSize: 20),
                ),
              ),
              Text(
                "William Mays",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          toolbarHeight: 100,
          leading: Icon(Icons.arrow_back_ios_new_rounded),
          actions: [
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
                          SizedBox(
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
          ],
        ),
        body: Column(
          children: [
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
                      content: SizedBox(
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
            SizedBox(height: 10), // Space between Container and TabBar
            TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [Tab(text: "Referrals"), Tab(text: "Transactions")],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Image.asset(
                    "assets/image/img2.png", // Assuming you have a support image in your assets
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
