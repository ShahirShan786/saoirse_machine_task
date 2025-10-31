import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class intro_page3 extends StatefulWidget {
  const intro_page3({super.key});

  @override
  State<intro_page3> createState() => _intro_page3State();
}

class _intro_page3State extends State<intro_page3> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .2),
          SizedBox(
              height: MediaQuery.of(context).size.height *.4,
              width: 300,
              child: Lottie.asset("assets/anim/intro3.json")),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Success Starts with One Click",
            style:  TextStyle(
              fontFamily: "font",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            
          ),
          const Text(
             "Time is money. Use it to build your dreams!",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 12,fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
