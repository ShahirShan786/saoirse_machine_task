import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:epi/PRODUCT/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../api_service/api_endpoint.dart';
import '../common_widget/cached_network_image.dart';
import '../common_widget/common_back_button.dart';
import '../data/model/product_response_model.dart';
import 'productviewPage.dart';

class Productpage extends StatefulWidget {
  const Productpage({super.key});

  @override
  State<Productpage> createState() => _ProductpageState();
}

class _ProductpageState extends State<Productpage> {
  PageController page = PageController();

  bool isLoading = true;
  List<Product>? productsList = [];

  void _updateSystemUIOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    });
  }

  Future<void> fetchProducts() async {
    String url = '${APIEndPoints.baseUrl}api/products?isCombo=true';
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

  void showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _updateSystemUIOverlay();
    fetchProducts();
  }

  Widget _sizedContainer({Widget? child, double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: screenwidth * 0.10,
                width: screenwidth * 0.10,
                child: Icon(Icons.menu),
              ),
              SizedBox(
                width: 15,
              ),
              Text("EPI"),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: screenwidth * 0.10,
              width: screenwidth * 0.10,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Productviewpage(),
                    ),
                  );
                },
                child: Icon(Icons.favorite_outline),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: screenwidth * 0.10,
              width: screenwidth * 0.10,
              child: Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(90),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(right: 10.0, left: 20),
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: screenheight * 0.022,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Deliver to: ",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Text("100 Combo Products"),
                    Spacer(),
                    Text("See all"),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : productsList?.isEmpty == true
                      ? const SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: Text(
                            "No Data Found",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 320,
                          child: PageView.builder(
                            itemCount: productsList?.take(5).length,
                            controller: PageController(viewportFraction: 0.75),
                            itemBuilder: (context, index) {
                              final product = productsList?[index];
                              final title = product?.name ?? 'No Title';
                              final image = product?.images?[0] ??
                                  'https://via.placeholder.com/150';
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      productId: productsList![index].id!,
                                    ),
                                  ));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 15,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 145,
                                        width: double.maxFinite,
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: _sizedContainer(
                                                child: cachedNetworkImageWidget(
                                                  url: image,
                                                ),
                                                width: 140,
                                                height: 140,
                                              ),
                                            ),
                                            Positioned(
                                              top: 5,
                                              right: 0,
                                              child: CommonAppbarButton(
                                                buttonClick: () {},
                                                icon: Icons.favorite_border,
                                                iconColor: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.visible,
                                              softWrap: true,
                                              maxLines: 3,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 18,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "${product?.rating.toString() ?? 0.0}",
                                            style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        product?.installmentOptions!
                                                .firstWhere(
                                                  (element) {
                                                    if (element.isRecommended ==
                                                        true) {
                                                      return true;
                                                    } else {
                                                      return false;
                                                    }
                                                  },
                                                )
                                                .totalAmount
                                                .toString() ??
                                            "0.0",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Spacer(),
                                      Text(
                                        "Price Per Day",
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        product?.installmentOptions!
                                                .firstWhere(
                                                  (element) {
                                                    if (element.isRecommended ==
                                                        true) {
                                                      return true;
                                                    } else {
                                                      return false;
                                                    }
                                                  },
                                                )
                                                .amount
                                                .toString() ??
                                            "0.0",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
              /* Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: CarouselSlider(
                    options: CarouselOptions(
                      padEnds: false,
                      enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                      height: 300.0,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                    ),
                    items: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          "assets/images/bedsheetad.png")),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                ),
                                height: 190,
                                width: double.infinity,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(image,
                                        height: 140, fit: BoxFit.contain),
                                    SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Text(
                                          title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          rating,
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "Price Per Day",
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      perDayPrice,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          "assets/images/bedsheetad.png")),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                ),
                                height: 190,
                                width: double.infinity,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Bedsheet, Curtains & \nPillow cover Combo",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "Price Per Day",
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "4200",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          "assets/images/bedsheetad.png")),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                ),
                                height: 190,
                                width: double.infinity,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Bedsheet, Curtains & \nPillow cover Combo",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "Price Per Day",
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "4200",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ]),
              ),*/
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CarouselSlider(
                  items: [
                    Image.asset(
                      "assets/images/exploreproductpage.png",
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      "assets/images/slider3.jpg",
                      fit: BoxFit.cover,
                    ),
                  ],
                  options: CarouselOptions(
                    viewportFraction: 1,
                    aspectRatio: 16 / 9,
                    enlargeCenterPage: true,
                    height: 140,
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    padEnds: false,
                    // enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              /* Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmoothPageIndicator(
                      controller: page,
                      count: 4,
                      effect: ExpandingDotsEffect(
                          dotHeight: 6,
                          dotWidth: 6,
                          expansionFactor: 2), // your preferred effect
                      onDotClicked: (index) {}),
                ],
              ),*/
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Text("Similar Products"),
                    Spacer(),
                    Text("See all"),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 15),
                // margin: EdgeInsets.zero,
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  height: screenheight * .15,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  AssetImage("assets/images/bedsheetad.png")),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 70,
                        width: 70,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bedsheet, Curtains & \nPillow cover Combo",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                          Text(
                            "Price Per Day",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 10),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "4200",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "5.0",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                  // margin: EdgeInsets.zero,
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    height: screenheight * .15,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    AssetImage("assets/images/bedsheetad.png")),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 70,
                          width: 70,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bedsheet, Curtains & \nPillow cover Combo",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            Text(
                              "Price Per Day",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 10),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "4200",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "5.0",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

/*
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:epi/PRODUCT/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../data/model/product_response_model.dart';
import 'productviewPage.dart';

class Productpage extends StatefulWidget {
  const Productpage({super.key});

  @override
  State<Productpage> createState() => _ProductpageState();
}

class _ProductpageState extends State<Productpage> {
  PageController page = PageController();

  bool isLoading = true;
  List<Products>? productsList = [];

  void _updateSystemUIOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    });
  }

  Future<void> fetchProducts() async {
    const String url =
        'https://epi-backend-production.up.railway.app/api/products?isCombo=true';

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

  @override
  void initState() {
    super.initState();
    _updateSystemUIOverlay();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: screenwidth * 0.10,
                width: screenwidth * 0.10,
                child: Icon(Icons.menu),
              ),
              SizedBox(
                width: 15,
              ),
              Text("EPI"),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: screenwidth * 0.10,
              width: screenwidth * 0.10,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Productviewpage(),
                    ),
                  );
                },
                child: Icon(Icons.favorite_outline),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: screenwidth * 0.10,
              width: screenwidth * 0.10,
              child: Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(90),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(right: 10.0, left: 20),
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: screenheight * 0.022,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Deliver to: ",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Text("100 Combo Products"),
                    Spacer(),
                    Text("See all"),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: 320,
                      child: PageView.builder(
                        itemCount: productsList?.take(5).length,
                        controller: PageController(viewportFraction: 0.75),
                        itemBuilder: (context, index) {
                          final product = productsList?[index];
                          final title = product?.name ?? 'No Title';
                          final image = product?.images?[0] ??
                              'https://via.placeholder.com/150';
                          final rating = product?.rating ?? '5.0';
                          final perDayPrice = */
/*product?.p ?? */ /*
 "4000";
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailScreen(productTitle: title),
                              ));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(image,
                                      height: 140, fit: BoxFit.contain),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.visible,
                                          softWrap: true,
                                          maxLines: 3,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        // rating,
                                        "5",
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "31,500",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                  Spacer(),
                                  Text(
                                    "Price Per Day",
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    perDayPrice,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              */
/* Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: CarouselSlider(
                    options: CarouselOptions(
                      padEnds: false,
                      enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                      height: 300.0,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                    ),
                    items: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          "assets/images/bedsheetad.png")),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                ),
                                height: 190,
                                width: double.infinity,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(image,
                                        height: 140, fit: BoxFit.contain),
                                    SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Text(
                                          title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          rating,
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "Price Per Day",
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      perDayPrice,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          "assets/images/bedsheetad.png")),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                ),
                                height: 190,
                                width: double.infinity,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Bedsheet, Curtains & \nPillow cover Combo",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "Price Per Day",
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "4200",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          "assets/images/bedsheetad.png")),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                ),
                                height: 190,
                                width: double.infinity,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Bedsheet, Curtains & \nPillow cover Combo",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "Price Per Day",
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "4200",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ]),
              ),*/ /*

              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CarouselSlider(
                  items: [
                    Image.asset(
                      "assets/images/exploreproductpage.png",
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      "assets/images/slider3.jpg",
                      fit: BoxFit.cover,
                    ),
                  ],
                  options: CarouselOptions(
                    viewportFraction: 1,
                    aspectRatio: 16 / 9,
                    enlargeCenterPage: true,
                    height: 140,
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    padEnds: false,
                    // enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmoothPageIndicator(
                      controller: page,
                      count: 4,
                      effect: ExpandingDotsEffect(
                          dotHeight: 6,
                          dotWidth: 6,
                          expansionFactor: 2), // your preferred effect
                      onDotClicked: (index) {}),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Text("Similar Products"),
                    Spacer(),
                    Text("See all"),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 15),
                // margin: EdgeInsets.zero,
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  height: screenheight * .15,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  AssetImage("assets/images/bedsheetad.png")),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 70,
                        width: 70,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bedsheet, Curtains & \nPillow cover Combo",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                          Text(
                            "Price Per Day",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 10),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "4200",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "5.0",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                  // margin: EdgeInsets.zero,
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    height: screenheight * .15,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    AssetImage("assets/images/bedsheetad.png")),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 70,
                          width: 70,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bedsheet, Curtains & \nPillow cover Combo",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            Text(
                              "Price Per Day",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 10),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "4200",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "5.0",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
*/
