// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
//
// class Firstpage extends StatefulWidget {
//   const Firstpage({super.key});
//
//   @override
//   State<Firstpage> createState() => _FirstpageState();
// }
//
// class _FirstpageState extends State<Firstpage> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           CarouselSlider(
//             items: [
//               Image.asset(
//                 "assets/image/s1.webp",
//                 fit: BoxFit.cover,
//               ),
//               Image.asset(
//                 "assets/image/s2.webp",
//                 fit: BoxFit.cover,
//               ),
//               Image.asset(
//                 "assets/image/s3.webp",
//                 fit: BoxFit.cover,
//               ),
//               Image.asset(
//                 "assets/image/s4.webp",
//                 fit: BoxFit.cover,
//               ),
//               Image.asset(
//                 "assets/image/s5.webp",
//                 fit: BoxFit.cover,
//               ),
//             ],
//             options: CarouselOptions(
//               viewportFraction: 1,
//               aspectRatio: 16 / 9,
//               enlargeCenterPage: true,
//               height: MediaQuery.of(context).size.height * .29,
//               autoPlay: true,
//               enableInfiniteScroll: true,
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(25),
//                 topRight: Radius.circular(25),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 const Text(
//                   'EASY PURCHASE INVESTMENT',
//                   style: TextStyle(
//                     letterSpacing: 2,
//                     wordSpacing: 3,
//                     fontFamily: "font",
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF223043),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 IntrinsicHeight(
//                   child: Row(
//                     children: [
//                       const VerticalDivider(
//                         color: Color(0xFF223043),
//                         thickness: 2,
//                       ),
//                       const SizedBox(
//                         width: 15,
//                       ),
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height * .15,
//                         width: MediaQuery.of(context).size.width * .79,
//                         child: const Text(
//                           'Easy Purchase Investment is an innovative savings and shopping plan that allows you to invest small amounts daily or weekly. Accumulate funds to purchase items like iPhones and more while enjoying discounts and rewards!',
//                           style: TextStyle(
//                               letterSpacing: 1,
//                               overflow: TextOverflow.clip,
//                               fontSize: 12,
//                               color: Colors.black87,
//                               fontStyle: FontStyle.italic),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 const Text(
//                   'Features',
//                   style: TextStyle(
//                     letterSpacing: 2,
//                     fontFamily: "font",
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF223043),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 15.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       RichText(
//                         text: const TextSpan(
//                           children: [
//                             TextSpan(
//                               text: "• ",
//                               style: TextStyle(
//                                   color: Color(0xFF223043), fontSize: 15),
//                             ),
//                             TextSpan(
//                               text: 'Invest small amounts daily/weekly',
//                               style: TextStyle(
//                                   letterSpacing: 1,
//                                   color: Colors.black87,
//                                   fontSize: 12,
//                                   fontStyle: FontStyle.italic),
//                             ),
//                           ],
//                         ),
//                       ),
//                       RichText(
//                         text: const TextSpan(
//                           children: [
//                             TextSpan(
//                               text: "• ",
//                               style: TextStyle(
//                                   color: Color(0xFF223043), fontSize: 15),
//                             ),
//                             TextSpan(
//                               text: 'Get discounts on market rates.',
//                               style: TextStyle(
//                                   letterSpacing: 1,
//                                   color: Colors.black87,
//                                   fontSize: 12,
//                                   fontStyle: FontStyle.italic),
//                             ),
//                           ],
//                         ),
//                       ),
//                       RichText(
//                         text: const TextSpan(
//                           children: [
//                             TextSpan(
//                               text: "• ",
//                               style: TextStyle(
//                                   color: Color(0xFF223043), fontSize: 15),
//                             ),
//                             TextSpan(
//                               text:
//                                   'Participate in lucky draws for exciting prizes.',
//                               style: TextStyle(
//                                   letterSpacing: 1,
//                                   color: Colors.black87,
//                                   fontSize: 12,
//                                   fontStyle: FontStyle.italic),
//                             ),
//                           ],
//                         ),
//                       ),
//                       RichText(
//                         text: const TextSpan(
//                           children: [
//                             TextSpan(
//                               text: "• ",
//                               style: TextStyle(
//                                   color: Color(0xFF223043), fontSize: 15),
//                             ),
//                             TextSpan(
//                               text: 'Refer friends and earn daily commissions.',
//                               style: TextStyle(
//                                   letterSpacing: 1,
//                                   color: Colors.black87,
//                                   fontSize: 12,
//                                   fontStyle: FontStyle.italic),
//                             ),
//                           ],
//                         ),
//                       ),
//                       RichText(
//                         text: const TextSpan(
//                           children: [
//                             TextSpan(
//                               text: "• ",
//                               style: TextStyle(
//                                   color: Color(0xFF223043), fontSize: 15),
//                             ),
//                             TextSpan(
//                               text:
//                                   'Flexible and user-friendly investment process..',
//                               style: TextStyle(
//                                   letterSpacing: 1,
//                                   color: Colors.black87,
//                                   fontSize: 12,
//                                   fontStyle: FontStyle.italic),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Image.asset(
//                   "assets/image/2.jpeg",
//                   scale: 2,
//                 ),
//                 const Text(
//                   "Every big business starts with a small step—click, invest, and grow!",
//                   style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12,
//                       fontStyle: FontStyle.italic,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 const Divider(
//                   color: Colors.grey,
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 const Text(
//                   "Products",
//                   style: TextStyle(
//                     letterSpacing: 1,
//                     wordSpacing: 2,
//                     fontFamily: "font",
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF223043),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 305,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Card(
//                           color: Colors.white,
//                           child: Column(
//                             children: [
//                               Image.asset("assets/image/watch.jpeg"),
//                               const ListTile(
//                                 title: Text(
//                                   "Obaku Watch",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 12),
//                                 ),
//                                 subtitle: Text(
//                                   "Elegant rose gold-tone chronograph with a blue dial and mesh strap for timeless sophistication and style.",
//                                   style: TextStyle(
//                                       letterSpacing: 1,
//                                       color: Colors.black87,
//                                       fontSize: 11,
//                                       fontStyle: FontStyle.italic),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Card(
//                           color: Colors.white,
//                           child: Column(
//                             children: [
//                               Image.asset("assets/image/lap.jpeg"),
//                               const ListTile(
//                                 title: Text(
//                                   "HP 15 Lap",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 12),
//                                 ),
//                                 subtitle: Text(
//                                   "A sleek design, 15.6-inch display, powerful performance, and long battery life for everyday computing.",
//                                   style: TextStyle(
//                                       letterSpacing: 1,
//                                       color: Colors.black87,
//                                       fontSize: 11,
//                                       fontStyle: FontStyle.italic),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 305,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Card(
//                           color: Colors.white,
//                           child: Column(
//                             children: [
//                               Image.asset("assets/image/phone.jpeg"),
//                               const ListTile(
//                                 title: Text(
//                                   "IPhone 12Pro",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 12),
//                                 ),
//                                 subtitle: Text(
//                                   "Super Retina XDR display,A14 Bionic chip,triple-camera system,and 5G support for exceptional performance and style.",
//                                   style: TextStyle(
//                                       letterSpacing: 1,
//                                       overflow: TextOverflow.clip,
//                                       color: Colors.black87,
//                                       fontSize: 11,
//                                       fontStyle: FontStyle.italic),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Card(
//                           color: Colors.white,
//                           child: Column(
//                             children: [
//                               Image.asset("assets/image/speaker.jpeg"),
//                               const ListTile(
//                                 title: Text(
//                                   "JBL Bluetooth\nSpeaker",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 12),
//                                 ),
//                                 subtitle: Text(
//                                   "BL Flip 3 Bluetooth Speaker: waterproof, rich bass, wireless, 10-hour battery life.",
//                                   style: TextStyle(
//                                       letterSpacing: 1,
//                                       color: Colors.black87,
//                                       fontSize: 11,
//                                       fontStyle: FontStyle.italic),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 const Center(
//                   child: Column(
//                     children: [
//                       Text(
//                         "SAOIRSE",
//                         style: TextStyle(
//                             fontFamily: 'font1',
//                             letterSpacing: 3,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF223043),
//                             shadows: [
//                               Shadow(
//                                 offset: Offset(.5, .5),
//                                 blurRadius: 2.0,
//                                 color: Color(0xFF385B7B),
//                               ),
//                               Shadow(
//                                 offset: Offset(.5, .5),
//                                 blurRadius: 2.0,
//                                 color: Color(0xFF385B7B),
//                               ),
//                             ]),
//                       ),
//                       Text(
//                         "IT SOLUTIONS LLP",
//                         style: TextStyle(
//                             fontFamily: 'font1',
//                             letterSpacing: 3,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF223043),
//                             fontSize: 10,
//                             shadows: [
//                               Shadow(
//                                 offset: Offset(.5, .5),
//                                 blurRadius: 2.0,
//                                 color: Color(0xFF385B7B),
//                               ),
//                               Shadow(
//                                 offset: Offset(.5, .5),
//                                 blurRadius: 2.0,
//                                 color: Color(0xFF385B7B),
//                               ),
//                             ]),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
