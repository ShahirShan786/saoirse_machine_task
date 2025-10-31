import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class intro_page1 extends StatefulWidget {
  const intro_page1({super.key});

  @override
  State<intro_page1> createState() => _intro_page1State();
}

class _intro_page1State extends State<intro_page1> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
           SizedBox(
            height: MediaQuery.of(context).size.height *.2
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height *.4,
              width: 300,
              child: Lottie.asset("assets/anim/intro1.json")),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Turn Passion into Profits!",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const Text(
             "Your passion is valuable—share it with the world!",
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
