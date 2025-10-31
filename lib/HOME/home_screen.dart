import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:epi/api_service/auth_service.dart';
import 'package:epi/common_widget/gradiant_border_container.dart';
import 'package:epi/data/model/product_response_model.dart';
import 'package:epi/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../Bottom_NavigationPage.dart';
import '../PRODUCT/product_detail_screen.dart';
import '../api_service/api_endpoint.dart';
import '../common_widget/cached_network_image.dart';
import '../locator/app_db.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> products = [];
  bool isLoading = true;
  final AuthServices _authService = AuthServices();
  String? userName;
  String? email;
  List<Product>? productsList = [];

  Future<void> getUserDetails() async {
    final user = appDB.user;
  log("User from appDB: ${user.name}, Profile: ${user.profilePicture}"); 
    setState(() {
      userName = appDB.user.name;
      email = appDB.user.email;
    });
  }

  Future<void> fetchProducts() async {
    String url = '${APIEndPoints.baseUrl}api/products?isSpecialPrice=true';
    Map<String, dynamic> mappedWishList = {
      "wishlist": [],
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(mappedWishList),
      );
      debugPrint("Product list response ${response.statusCode}");
      debugPrint("Product list response body ${response.body}");

      if (response.statusCode == 200) {
        final data =
            ProductResponseModel.fromJson(json.decode(response.body));
        debugPrint("BODY RUNTIME TYPE ${data.runtimeType}");
        debugPrint("Product ${data.products}");
        setState(() {
          productsList = data.products;
          isLoading = false;
        });
        debugPrint("NOW PRODUCT LIST ${productsList?.length}");
      } else {
        showError("Status code: ${response.statusCode}");
      }
        } catch (e, s) {
      debugPrint("IN CATCH $s");
      debugPrint("IN CATCH Error $e");
    }
  }

  Widget _sizedContainer({Widget? child, double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(child: child),
    );
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
      ),
    );
  }

  void _updateSystemUIOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Color(0xff1E202C),
          statusBarIconBrightness: Brightness.light,
        ),
      );
    });
  }

 ImageProvider _buildImageProvider(String? path) {
  log("Building image provider for path: $path"); // Add debug log
  
  if (path == null || path.isEmpty) {
    return const AssetImage('assets/images/default_avatar.png');
  } else if (path.startsWith('http')) {
    // It's a URL
    return NetworkImage(path);
  } else {
    // It's a local file - THIS MIGHT BE THE ISSUE
    return FileImage(File(path));
  }
}

  @override
  void initState() {
    super.initState();
    getUserDetails();
    fetchProducts();
    _updateSystemUIOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size(double.maxFinite, 75),
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff444E5A),
                  Color(0xff1E202C),
                  Color(0xff12111F),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15)
                .copyWith(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /* CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      NetworkImage(appDB.user.profilePicture ?? "", scale: 3),
                  */ /* child: Image.network(
                    appDB.user.profilePicture ?? "",
                    height: 40,
                    width: 40,
                  ),*/ /*
                ),*/
                // SizedBox(
                //   height: 40,
                //   width: 40,
                //   child: DecoratedBox(
                //     decoration: BoxDecoration(
                //         color: Color(0xff0E263E),
                //         borderRadius: BorderRadius.all(
                //           Radius.circular(10),
                //         ),
                //         border: Border.all(
                //           color: Color(0xff013263),
                //           style: BorderStyle.solid,
                //           width: 1,
                //         ),
                //         image: DecorationImage(
                //             image: NetworkImage(appDB.user.profilePicture ?? "",
                //                 scale: 2))),
                //   ),
                // ),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xff0E263E),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: const Color(0xff013263),
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                      image: DecorationImage(
                        image: _buildImageProvider(appDB.user.profilePicture),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi!",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Roboto",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        userName ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                buildActionWidget(
                  img: 'assets/newui/reward.png',
                  isNotify: false,
                ),
                SizedBox(
                  width: 8,
                ),
                buildActionWidget(
                  isNotify: true,
                  img: 'assets/newui/notification.png',
                ),
              ],
            )),
      ),
      backgroundColor: Color(0xff0C0B1A),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xff072849),
                image: DecorationImage(
                  image: AssetImage(
                    "assets/newui/bg_image.png",
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              padding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(
                top: 90,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "EXPLORE MORE !!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Just save minimum ₹100 everyday to get your desired product",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Image.asset("assets/newui/products.png", height: 150),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => BottomNavigationPage(
                          navigateIndex: 1,
                        ),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 99, vertical: 10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Start Purchasing",
                            style:
                                TextStyle(color: Colors.black, fontSize: 15)),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward, color: Colors.black),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                color: Color(0xff020B16).withValues(alpha: 0.60),
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xff60CAF3),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  left: BorderSide(
                    color: Color(0xff60CAF3),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  right: BorderSide(
                    color: Color(0xff60CAF3),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  top: BorderSide.none,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/newui/left_arrow_line.png",
                    scale: 3,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "24000 people reffered and earned!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff60caf3),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Image.asset(
                    "assets/newui/right_arrow_line.png",
                    scale: 3,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ).copyWith(bottom: 2),
              child: SizedBox(
                height: 210,
                width: MediaQuery.of(context).size.width * 1.0,
                child: Stack(
                  children: [
                    GradientBorderContainer(
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
                      bottomLeftRadius: 10,
                      bottomRightRadius: 10,
                      topLeftRadius: 10,
                      topRightRadius: 10,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15).copyWith(left: 20),
                      containerColor: Color(0xff000000).withValues(alpha: 0.8),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Refer EPI",
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w800,
                              color: Color(0xff60caf3),
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Earn Money \nEveryday",
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Roboto",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => BottomNavigationPage(
                                    navigateIndex: 3,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Refer A Friend Now",
                              style: TextStyle(
                                color: Color(0xFF023E8A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        "assets/newui/refer_epi.png",
                        scale: 2.9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ).copyWith(bottom: 10),
              child: Text(
                "Quick Access",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 135,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 145,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xff1f1f2c),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/newui/quick_access_one.png",
                                  scale: 4,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffffffff)
                                            .withValues(alpha: 0.10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Lorem ipsum do",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                              ),
                            ),
                            Text(
                              "Lorem ipsum dol sit ame, consect etur adi.",
                              style: TextStyle(
                                color: Color(0xff939393),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                              ),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  width: 10,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                itemCount: 5,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
              ),
            ),*/
            Opacity(
              opacity: 0.25,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // "Small," with stroke only
                  Text(
                    "Small,",
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1.5
                        ..color = Color(0xFF60CAF3),
                    ),
                  ),
                  // "Dream" filled
                  Text(
                    "Dream",
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF60CAF3),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "FOR SPECIAL PRICE",
                    style: TextStyle(
                      color: Color(0xFF60CAF3),
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Roboto Condensed',
                      letterSpacing: 3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 320,
                    child: PageView.builder(
                      itemCount:
                          productsList!.length > 5 ? 6 : productsList?.length,
                      // itemCount: productsList?.take(5).length,
                      controller: PageController(viewportFraction: 0.75),
                      itemBuilder: (context, index) {
                        final product = productsList?[index];
                        // final title = productsList?[index] ?? 'No Title';
                        // final image = product['image'] ??
                        // 'https://via.placeholder.com/150';

                        return (index == 5)
                            ? Center(
                                child: Text(
                                  "VIEW MORE",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      productId: productsList![index].id!,
                                    ),
                                  ));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _sizedContainer(
                                        width: 140,
                                        height: 140,
                                        child: cachedNetworkImageWidget(
                                            url: product?.images?[0] ?? ""),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        product?.name ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF023E8A),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 28, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          "Buy Now",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      },
                    ),
                  ),

            /* Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Quest',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xff261067),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff101D30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/newui/trophy.png",
                          scale: 12,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            "You’ve Unlocked\nA New Quest",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffffffff).withValues(alpha: 0.10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(Icons.arrow_forward_ios,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.bolt, color: Colors.yellow, size: 25),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Refer and earn, never miss a chance!",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Learn About Us',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              // height: 210,
              padding: EdgeInsets.only(bottom: 10, left: 20, top: 0, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xff0C2238),
              ),
              width: MediaQuery.of(context).size.width * 1.0,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Why Save\nOn ",
                              style: TextStyle(
                                fontSize: 35, // Bigger
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: "EPI ?",
                              style: TextStyle(
                                fontSize: 35, // Bigger
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF60CAF3),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Know more",
                          style: TextStyle(
                            color: Color(0xFF023E8A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    top: 5,
                    right: 10,
                    child: Image.asset(
                      "assets/newui/why_save_epi.png",
                      scale: 3.2,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              "assets/newui/dream_big_dark_mode.png",
              fit: BoxFit.fitWidth,
            )
          ],
        ),
      ),
    );
  }

  Widget buildActionWidget({String? img, bool? isNotify}) {
    return SizedBox(
      width: 40,
      height: 50,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10,
                ),
                color: Color(0xfff2f2f2).withValues(alpha: 0.02),
                border: Border.all(
                  color: Color(0xff60CAF3),
                  style: BorderStyle.solid,
                  width: 1,
                ),
                shape: BoxShape.rectangle,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                child: Image.asset(
                  img ?? "",
                  scale: 3,
                ),
              ),
            ),
          ),
          Positioned(
              top: 0,
              right: 4,
              child: isNotify == true
                  ? Icon(
                      Icons.brightness_1,
                      size: 10,
                      color: Color(0xffFF070B),
                    )
                  : SizedBox.shrink())
        ],
      ),
    );
  }
}

/*
import 'dart:convert';

import 'package:epi/api_service/auth_service.dart';
import 'package:epi/common_widget/gradiant_border_container.dart';
import 'package:epi/data/model/product_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Bottom_NavigationPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> products = [];
  bool isLoading = true;
  final AuthService _authService = AuthService();
  String? userName;
  String? email;
  List<Products>? productsList = [];

  Future<void> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name');
      email = prefs.getString('email');
    });
  }

  Future<void> fetchProducts() async {
    const String url =
        'https://epi-backend-production.up.railway.app/api/products?isSpecialPrice=true';

    try {
      final response = await http.get(Uri.parse(url));
      debugPrint("Product list response ${response.statusCode}");
      debugPrint("Product list response body ${response.body}");

      if (response != null) {
        if (response.statusCode == 200) {
          final data =
              ProductResponseModel.fromJson(json.decode(response.body));
          debugPrint("BODY RUNTIME TYPE ${data.runtimeType}");
          debugPrint("Product ${data.products}");
          setState(() {
            productsList = data.products;

            isLoading = false;
          });
          debugPrint("NOW PRODUCT LIST ${productsList?.length}");
        } else {
          showError("Status code: ${response.statusCode}");
        }
      }
    } catch (e, s) {
      debugPrint("IN CATCH $s");
      debugPrint("IN CATCH Error $e");
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
      ),
    );
  }

  void _updateSystemUIOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Color(0xff1E202C),
          statusBarIconBrightness: Brightness.light,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    fetchProducts();
    _updateSystemUIOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size(double.maxFinite, 75),
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff444E5A),
                  Color(0xff1E202C),
                  Color(0xff12111F),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15)
                .copyWith(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xff0E263E),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Image.asset(
                      "assets/newui/avatar.png",
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi!",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Roboto",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        userName ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                buildActionWidget(
                  img: 'assets/newui/reward.png',
                  isNotify: false,
                ),
                SizedBox(
                  width: 8,
                ),
                buildActionWidget(
                  isNotify: true,
                  img: 'assets/newui/notification.png',
                ),
              ],
            )),
      ),
      backgroundColor: Color(0xff0C0B1A),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xff072849),
                image: DecorationImage(
                  image: AssetImage(
                    "assets/newui/bg_image.png",
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              padding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(
                top: 90,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "EXPLORE MORE !!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Just save minimum ₹100 everyday to get your desired product",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Image.asset("assets/newui/products.png", height: 150),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => BottomNavigationPage(
                          navigateIndex: 1,
                        ),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 99, vertical: 10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Start Purchasing",
                            style:
                                TextStyle(color: Colors.black, fontSize: 15)),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward, color: Colors.black),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                color: Color(0xff020B16).withValues(alpha: 0.60),
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xff60CAF3),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  left: BorderSide(
                    color: Color(0xff60CAF3),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  right: BorderSide(
                    color: Color(0xff60CAF3),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  top: BorderSide.none,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/newui/left_arrow_line.png",
                    scale: 3,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "24000 people reffered and earned!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff60caf3),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Image.asset(
                    "assets/newui/right_arrow_line.png",
                    scale: 3,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ).copyWith(bottom: 2),
              child: SizedBox(
                height: 210,
                width: MediaQuery.of(context).size.width * 1.0,
                child: Stack(
                  children: [
                    GradientBorderContainer(
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
                      bottomLeftRadius: 10,
                      bottomRightRadius: 10,
                      topLeftRadius: 10,
                      topRightRadius: 10,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15).copyWith(left: 20),
                      containerColor: Color(0xff000000).withValues(alpha: 0.8),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Refer EPI",
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w800,
                              color: Color(0xff60caf3),
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Earn Money \nEveryday",
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Roboto",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => BottomNavigationPage(
                                    navigateIndex: 3,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Refer A Friend Now",
                              style: TextStyle(
                                color: Color(0xFF023E8A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        "assets/newui/refer_epi.png",
                        scale: 2.9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            */
/*Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ).copyWith(bottom: 10),
              child: Text(
                "Quick Access",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 135,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 145,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xff1f1f2c),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/newui/quick_access_one.png",
                                  scale: 4,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffffffff)
                                            .withValues(alpha: 0.10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Lorem ipsum do",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                              ),
                            ),
                            Text(
                              "Lorem ipsum dol sit ame, consect etur adi.",
                              style: TextStyle(
                                color: Color(0xff939393),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                              ),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  width: 10,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                itemCount: 5,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
              ),
            ),*/ /*

            Opacity(
              opacity: 0.25,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // "Small," with stroke only
                  Text(
                    "Small,",
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1.5
                        ..color = Color(0xFF60CAF3),
                    ),
                  ),
                  // "Dream" filled
                  Text(
                    "Dream",
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF60CAF3),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "FOR SPECIAL PRICE",
                    style: TextStyle(
                      color: Color(0xFF60CAF3),
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Roboto Condensed',
                      letterSpacing: 3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 320,
                    child: PageView.builder(
                      itemCount: productsList?.length,
                      // itemCount: productsList?.take(5).length,
                      controller: PageController(viewportFraction: 0.75),
                      itemBuilder: (context, index) {
                        final product = productsList?[index];
                        // final title = productsList?[index] ?? 'No Title';
                        // final image = product['image'] ??
                        'https://via.placeholder.com/150';

                        return */
/* (index + 1) == productsList?.length
                            ? Center(
                                child: Text(
                                  "VIEW MORE",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            :*/ /*

                            Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(product?.images?[0],
                                  height: 140, fit: BoxFit.contain),
                              SizedBox(height: 16),
                              Text(
                                product?.name ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF023E8A),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 28, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "Buy Now",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            */
/* Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Quest',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xff261067),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff101D30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/newui/trophy.png",
                          scale: 12,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            "You’ve Unlocked\nA New Quest",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffffffff).withValues(alpha: 0.10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(Icons.arrow_forward_ios,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.bolt, color: Colors.yellow, size: 25),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Refer and earn, never miss a chance!",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),*/ /*

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Learn About Us',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              // height: 210,
              padding: EdgeInsets.only(bottom: 10, left: 20, top: 0, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xff0C2238),
              ),
              width: MediaQuery.of(context).size.width * 1.0,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Why Save\nOn ",
                              style: TextStyle(
                                fontSize: 35, // Bigger
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: "EPI ?",
                              style: TextStyle(
                                fontSize: 35, // Bigger
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF60CAF3),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Know more",
                          style: TextStyle(
                            color: Color(0xFF023E8A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    top: 5,
                    right: 10,
                    child: Image.asset(
                      "assets/newui/why_save_epi.png",
                      scale: 3.2,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              "assets/newui/dream_big_dark_mode.png",
              fit: BoxFit.fitWidth,
            )
          ],
        ),
      ),
    );
  }

  Widget buildActionWidget({String? img, bool? isNotify}) {
    return SizedBox(
      width: 40,
      height: 50,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10,
                ),
                color: Color(0xfff2f2f2).withValues(alpha: 0.02),
                border: Border.all(
                  color: Color(0xff60CAF3),
                  style: BorderStyle.solid,
                  width: 1,
                ),
                shape: BoxShape.rectangle,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                child: Image.asset(
                  img ?? "",
                  scale: 3,
                ),
              ),
            ),
          ),
          Positioned(
              top: 0,
              right: 4,
              child: isNotify == true
                  ? Icon(
                      Icons.brightness_1,
                      size: 10,
                      color: Color(0xffFF070B),
                    )
                  : SizedBox.shrink())
        ],
      ),
    );
  }
}
*/
