import 'package:flutter/material.dart';

class about extends StatelessWidget {
  const about({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "About",
          style: TextStyle(fontFamily: "font"),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Easy Purchase Investment (EPI) ",
                style: TextStyle(fontFamily: "font"),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                  style: TextStyle(
                      overflow: TextOverflow.clip,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic),
                  "EPI is an innovative savings and shopping platform that helps you achieve your dreams by making luxury items affordable. By investing small amounts daily or weekly, you can accumulate funds to purchase items like iPhones and more, all while enjoying exclusive discounts and rewards. EPI transforms your daily savings into a smart investment, making it easier to turn your aspirations into reality."),
              SizedBox(
                height: 25,
              ),
              Text("Affordable Luxury Made Easy",
                  style: TextStyle(fontFamily: "font")),
              SizedBox(
                height: 5,
              ),
              Text(
                  style: TextStyle(
                      overflow: TextOverflow.clip,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic),
                  " With EPI, luxury is no longer out of reach. Our unique plan breaks down payments into manageable daily or weekly increments, allowing you to save for high-value items effortlessly. Whether it’s a gadget, appliance, or any other product, EPI ensures affordability while making the process seamless and stress-free."),
              SizedBox(
                height: 25,
              ),
              Text("Unbeatable Benefits ",
                  style: TextStyle(fontFamily: "font")),
              SizedBox(
                height: 5,
              ),
              Text(
                  style: TextStyle(
                      overflow: TextOverflow.clip,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic),
                  " • Exclusive Discounts \n • Daily Commissions \n • Guaranteed Authenticity"),
              SizedBox(
                height: 25,
              ),
              Text(
                "Flexible and User-Friendly ",
                style: TextStyle(fontFamily: "font"),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                  style: TextStyle(
                      overflow: TextOverflow.clip,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic),
                  "EPI’s investment plans are designed with your convenience in mind. The process is simple, flexible, and tailored to suit your financial goals. With just a small daily or weekly contribution, you can watch your savings grow and take a step closer to your dream purchase"),
              SizedBox(
                height: 25,
              ),
              Text("Where Saving Meets Shopping ",
                  style: TextStyle(fontFamily: "font")),
              SizedBox(
                height: 5,
              ),
              Text(
                  style: TextStyle(
                      overflow: TextOverflow.clip,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic),
                  "EPI is more than a savings plan—it’s a journey where saving meets shopping and dreams come true. Experience hassle-free shopping, guaranteed product authenticity, and unmatched flexibility with EPI. Start investing today and turn your daily savings into something extraordinary!"),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("SAOIRSE IT SOLUTION LLP"),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("(ACE-4958)"),
                  ],
                  )
            ],
          ),
        ),
      ),
    );
  }
}
