import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class intro_page2 extends StatefulWidget {
  const intro_page2({super.key});

  @override
  State<intro_page2> createState() => _intro_page2State();
}

class _intro_page2State extends State<intro_page2> {
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
              child: Lottie.asset("assets/anim/intro2.json")),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Your Store, Your Future!",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const Text(
             "You don’t need a shop—just a vision and a website!",
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
