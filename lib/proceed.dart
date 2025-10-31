import 'package:flutter/material.dart';
import 'package:epi/PRODUCT/product_fetch.dart';


// ignore: camel_case_types
class proceed extends StatefulWidget {
  const proceed({super.key});

  @override
  State<proceed> createState() => _proceedState();
}

// ignore: camel_case_types
class _proceedState extends State<proceed> {
  final controller = ScrollController();
  var _currentIndex = 0.0;
  bool end = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(scrollPosition);
  }

  void scrollPosition() {
    final isStop = controller.position.pixels;

    setState(() {
      _currentIndex = isStop;
    });
    print(isStop);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: controller,
          // scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              // CarouselSlider(
              //   items: [
              //     Image.asset(
              //       "assets/image/s1.jpeg",
              //       fit: BoxFit.cover,
              //     ),
              //     Image.asset(
              //       "assets/image/s2.jpeg",
              //       fit: BoxFit.cover,
              //     ),
              //     Image.asset(
              //       "assets/image/s3.jpeg",
              //       fit: BoxFit.cover,
              //     ),
              //   ],
              //   options: CarouselOptions(
              //     padEnds: false,
              //     viewportFraction: 1,
              //     enlargeCenterPage: true,
              //     height: 200,
              //     autoPlay: true,
              //     enableInfiniteScroll: true,
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What is EPI ?',
                      style: TextStyle(
                        fontFamily: "font",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'EPI (Easy Purchase Investment) is an innovative savings and shopping plan that allows you to invest small amounts daily or weekly. Accumulate funds to purchase items like iPhones and more while enjoying discounts and rewards!',
                      style: TextStyle(
                          overflow: TextOverflow.clip,
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16),
                    // Container(
                    //   width: double.infinity,
                    //   height: 240,
                    //   decoration: const BoxDecoration(
                    //       image: DecorationImage(
                    //           fit: BoxFit.fill,
                    //           image: AssetImage(
                    //               "assets/image/WhatsApp Image 2025-01-22 at 5.00.42 PM (1).jpeg"))),
                    // ),
                    const SizedBox(height: 16),
                    const Text(
                      'Why Choose EPI ?',
                      style: TextStyle(
                        fontFamily: "font",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "• ",
                            style: TextStyle(
                                color: Colors.amberAccent, fontSize: 15),
                          ),
                          TextSpan(
                            text: 'Invest small amounts daily/weekly',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "• ",
                            style: TextStyle(
                                color: Colors.amberAccent, fontSize: 15),
                          ),
                          TextSpan(
                            text: 'Get discounts on market rates.',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "• ",
                            style: TextStyle(
                                color: Colors.amberAccent, fontSize: 15),
                          ),
                          TextSpan(
                            text:
                                'Participate in lucky draws for exciting prizes.',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "• ",
                            style: TextStyle(
                                color: Colors.amberAccent, fontSize: 15),
                          ),
                          TextSpan(
                            text: 'Refer friends and earn daily commissions.',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "• ",
                            style: TextStyle(
                                color: Colors.amberAccent, fontSize: 15),
                          ),
                          TextSpan(
                            text:
                                'Flexible and user-friendly investment process..',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Our Products',
                      style: TextStyle(
                        fontFamily: "font",
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.amberAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 320,
                  child: _currentIndex > 50
                      ? Row(
                          children: [
                            Expanded(
                                child: Card(
                              margin: const EdgeInsets.all(10),
                              color: Colors.grey.shade50,
                              child: Column(
                                children: [
                                  Image.asset("assets/image/watch.jpeg"),
                                  const ListTile(
                                    title: Text(
                                      "Obaku Watch",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    subtitle: Text(
                                      "Elegant rose gold-tone chronograph with a blue dial and mesh strap for timeless sophistication and style.",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  )
                                ],
                              ),
                            )),
                            Expanded(
                              child: Card(
                                margin: const EdgeInsets.all(10),
                                color: Colors.grey.shade50,
                                child: Column(
                                  children: [
                                    Image.asset("assets/image/lap.jpeg"),
                                    const ListTile(
                                      title: Text(
                                        "HP 15 Lap",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      subtitle: Text(
                                        "A sleek design, 15.6-inch display, powerful performance, and long battery life for everyday computing.",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      // .animate().fade(duration: const Duration(seconds: 2))
                      : Row(
                          children: [
                            Expanded(
                              child: Card(
                                margin: const EdgeInsets.all(10),
                                color: Colors.grey.shade50,
                                child: Column(
                                  children: [
                                    Image.asset("assets/image/watch.jpeg"),
                                    const ListTile(
                                      title: Text(
                                        "Obaku Watch",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      subtitle: Text(
                                        "Elegant rose gold-tone chronograph with a blue dial and mesh strap for timeless sophistication and style.",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                margin: const EdgeInsets.all(10),
                                color: Colors.grey.shade50,
                                child: Column(
                                  children: [
                                    Image.asset("assets/image/lap.jpeg"),
                                    const ListTile(
                                      title: Text(
                                        "HP 15 Lap",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      subtitle: Text(
                                        "A sleek design, 15.6-inch display, powerful performance, and long battery life for everyday computing.",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 330,
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          color: Colors.grey.shade50,
                          child: Column(
                            children: [
                              Image.asset("assets/image/phone.jpeg"),
                              const ListTile(
                                title: Text(
                                  "IPhone 12Pro",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                subtitle: Text(
                                  "Super Retina XDR display,A14 Bionic chip,triple-camera system,and 5G support for exceptional performance and style.",
                                  style: TextStyle(
                                      overflow: TextOverflow.clip,
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          color: Colors.grey.shade50,
                          child: Column(
                            children: [
                              Image.asset("assets/image/speaker.jpeg"),
                              const ListTile(
                                title: Text(
                                  "JBL Bluetooth\nSpeaker",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                subtitle: Text(
                                  "BL Flip 3 Bluetooth Speaker: waterproof, rich bass, wireless, 10-hour battery life.",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  // color: Colors.amberAccent.shade400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Stack(
                      //   children: [
                      //     Opacity(
                      //       opacity: .5,
                      //       child: Container(
                      //         height: 350,
                      //         width: 250,
                      //         decoration: const BoxDecoration(
                      //           image: DecorationImage(
                      //             fit: BoxFit.cover,
                      //             image: AssetImage("assets/image/cover.jpeg"),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(
                      //       height: 350,
                      //       width: 250,
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Text(
                      //                 'For More',
                      //                 style: TextStyle(
                      //                   fontFamily: "font",
                      //                   fontSize: 25,
                      //                   fontWeight: FontWeight.bold,
                      //                   color: Colors.black,
                      //                 ),
                      //               ),
                      //             ],
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      // ignore: prefer_const_constructors
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Operation(),
                            ),
                          );
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 20,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(60),
      //   child: AppBar(
      //     surfaceTintColor: Colors.transparent,
      //     automaticallyImplyLeading: false,
      //     flexibleSpace: Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
      //       child: ListTile(
      //         contentPadding: EdgeInsets.zero,
      //         title: Text(
      //           "Easy Purchse Investment",
      //           style: GoogleFonts.robotoCondensed(
      //             textStyle: const TextStyle(
      //                 fontSize: 25,
      //                 fontFamily: "font",
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.amberAccent),
      //           ),
      //         ),
      //         subtitle: Text(
      //           "Invest Small, Dream Big  Own It",
      //           style: GoogleFonts.lato(
      //             textStyle: const TextStyle(
      //                 color: Colors.grey,
      //                 fontSize: 12,
      //                 fontWeight: FontWeight.bold),
      //           ),
      //         ),
      //       ),
      //     ),
      //     centerTitle: true,
      //     backgroundColor: Colors.white,
      //     shadowColor: Colors.white,
      //   ),
      // ),
    );
  }
}
