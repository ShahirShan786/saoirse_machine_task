import 'dart:convert';
import 'package:epi/100epicalc.dart';
import 'package:epi/PRODUCT/100product_fetch.dart';
import 'package:epi/PRODUCT/kids_products.dart';
import 'package:epi/PRODUCT/teen_products.dart';
import 'package:epi/PRODUCT/youth_products.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../WISHLIST/wishlist_page.dart';
import '../logIn.dart';
import 'carousal_slider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  Set<String> hundredwishlist = {};
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  int? flippedIndex;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    loadWishlist();
    searchController.addListener(_filterProducts);
  }

  Future<void> loadWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hundredwishlist = (prefs.getStringList('hundredwishlist') ?? []).toSet();
    });
  }

  Future<void> toggleWishlist(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (hundredwishlist.contains(productId)) {
        hundredwishlist.remove(productId);
      } else {
        hundredwishlist.add(productId);
      }
      prefs.setStringList('hundredwishlist', hundredwishlist.toList());
    });
  }

//view products

  Future<void> fetchProducts() async {
    const String url = 'http://16.171.26.118/display_100product.php';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status_code'] == 200) {
          setState(() {
            products = data['products'];
            filteredProducts = products;
            isLoading = false;
          });
        } else {
          _showErrorDialog(message: 'Error: ${data['msg']}');
        }
      } else {
        _showErrorDialog(
            message:
                'Failed to fetch products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog(message: 'PLEASE CHECK YOUR INTERNET CONNECTION');
    }
  }

  void _filterProducts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((product) {
        final name = product['product_name'].toLowerCase();
        final description = product['description']?.toLowerCase() ?? '';
        return name.contains(query) || description.contains(query);
      }).toList();
    });
  }

  void _showErrorDialog(
      {String message = "An error occurred. Please try again."}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Error",
            style: TextStyle(fontFamily: "font"),
          ),
          content: Text(
            message,
            style: const TextStyle(fontFamily: "font"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  int currentindex = 0;
  bool ontap = false;
  bool fav = false;
  List<Widget> list = [
    BottomSheet(
        onClosing: () {},
        builder: (BuildContext) {
          return Container();
        })
  ];

  Future<void> logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('id'); // Clear the user ID
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const logIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Container(
          height: 40.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              prefixIcon: Padding(
                padding: EdgeInsets.only(right: 10.0, left: 20),
                child: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => wishlisttab(),
                ),
              );
            },
            icon: const Icon(Icons.favorite, color: Colors.red),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.card_giftcard,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : searchController.text.isNotEmpty
              ? GridView.builder(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 3.35 / 4,
                  ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HundredEpicalc(
                            productId: product['product_id'],
                            price:
                                double.parse(product['price'].toString()),
                            image: product['image'].toString(),
                            name: product['product_name'].toString(),
                            descprition: product['description'].toString(),
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          
                          width: MediaQuery.of(context).size.width *
                                        0.45,
                                        height: MediaQuery.of(context).size.width * 0.45,
                          child: product['image'] != null &&
                                  product['image'].isNotEmpty
                              ? Image.network(
                                  product['image'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                        Icons.image_not_supported);
                                  },
                                )
                              : const Icon(Icons.image_not_supported,
                                  color: Colors.grey),
                        ),
                        Padding(
                                  padding: const EdgeInsets.only(top: 3,
                                    bottom: 2,
                                    left: 10.0,
                                  ),
                                  child: Text(
                                    product['product_name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                      ],
                    ),
                  );
                },
              )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const caroual_slider(),
                      const SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Category",
                              style: TextStyle(
                                  color: Colors.black, fontFamily: "font1"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: SizedBox(
                          height: 30,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black,
                                  ),
                                  child: Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10)),
                                      onPressed: () {},
                                      child: const Text("All",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10)),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const hundredOperation()));
                                      },
                                      child: const Text("100 Combo",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10)),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const YouthProducts()));
                                      },
                                      child: const Text("Youth",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10)),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const TeenProducts()));
                                      },
                                      child: const Text("Teen",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10)),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const KidsProducts()));
                                      },
                                      child: const Text("Kids",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                    ),
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
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            spacing: MediaQuery.of(context).size.width * 0.05,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.18,
                                    width: MediaQuery.of(context).size.width *
                                        0.18,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(100),
                                      image: const DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            AssetImage("assets/images/pho.png"),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Mobles",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 8),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.18,
                                    width: MediaQuery.of(context).size.width *
                                        0.18,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(100),
                                      image: const DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            AssetImage("assets/images/f.png"),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Fashion",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 8),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.18,
                                    width: MediaQuery.of(context).size.width *
                                        0.18,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(100),
                                      image: const DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            AssetImage("assets/images/gad.jpg"),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Gadgets",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 8),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.18,
                                    width: MediaQuery.of(context).size.width *
                                        0.18,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(100),
                                      image: const DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            AssetImage("assets/images/g.png"),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Grocery",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 8),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.18,
                                    width: MediaQuery.of(context).size.width *
                                        0.18,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(100),
                                      image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        image:
                                            AssetImage("assets/images/h.png"),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Home & Furniture",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 8),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.18,
                                    width: MediaQuery.of(context).size.width *
                                        0.18,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(100),
                                      image: const DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            AssetImage("assets/images/e.png"),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Appliances",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 8),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "100 Combo Products",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.52,
                              width: MediaQuery.of(context).size.height * 0.52,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400)),
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 4 / 4,
                                ),
                                itemCount:
                                    products.length > 4 ? 4 : products.length,
                                // Show only 4 items
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  // final productId = product['product_id'].toString();
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HundredEpicalc(
                                            productId: product['product_id'],
                                            price: double.parse(
                                                product['price'].toString()),
                                            image: product['image'].toString(),
                                            name: product['product_name']
                                                .toString(),
                                            descprition: product['description']
                                                .toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: product['image'] != null &&
                                              product['image'].isNotEmpty
                                          ? Image.network(
                                              product['image'],
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Icon(
                                                    Icons.image_not_supported);
                                              },
                                            )
                                          : const Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Similar Products",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 180,
                            child: ListView.builder(
                              // physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  products.length > 4 ? products.length - 5 : 0,
                              // Show only 4 items
                              itemBuilder: (context, index) {
                                final product = products[index + 5];
                                // final productId = product['product_id'].toString();
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HundredEpicalc(
                                          productId: product['product_id'],
                                          price: double.parse(
                                              product['price'].toString()),
                                          image: product['image'].toString(),
                                          name: product['product_name']
                                              .toString(),
                                          descprition:
                                              product['description'].toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade400)),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 135,
                                            width: 135,
                                            child: product['image'] != null &&
                                                    product['image'].isNotEmpty
                                                ? Image.network(
                                                    product['image'],
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const Icon(Icons
                                                          .image_not_supported);
                                                    },
                                                  )
                                                : const Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey),
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                              product['product_name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                // fontSize: 14,
                                              ),
                                              // maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
