import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:epi/epiccalc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Operation extends StatefulWidget {
  const Operation({super.key});

  @override
  State<Operation> createState() => _OperationState();
}

class _OperationState extends State<Operation> {
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  Set<String> wishlist = {};
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
      wishlist = (prefs.getStringList('wishlist') ?? []).toSet();
    });
  }

  Future<void> toggleWishlist(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (wishlist.contains(productId)) {
        wishlist.remove(productId);
      } else {
        wishlist.add(productId);
      }
      prefs.setStringList('wishlist', wishlist.toList());
    });
  }

  Future<void> fetchProducts() async {
    const String url = 'http://16.171.26.118/display_product.php';
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
          backgroundColor: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
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
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.8 / 4,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      final productId = product['product_id'].toString();
                      return
                         
                          Stack(
                        children: [
                          Card(
                            color: Colors.white,
                            // elevation: 5,
                            shape: RoundedRectangleBorder(side: const BorderSide(width: .5,color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(25),
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
                                        : const Icon(Icons.image_not_supported,
                                            color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 5,
                                    left: 10.0,
                                  ),
                                  child: Text(
                                    product['product_name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 5, right: 5, bottom: 10),
                                      padding: const EdgeInsets.only(top: 5,bottom: 5,left: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        '₹${product['price']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                          // fontFamily: "font",
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Epicalc(
                                                descprition:
                                                    product['description']
                                                        .toString(),
                                                productId:
                                                    product['product_id'],
                                                price: double.parse(
                                                    product['price']
                                                        .toString()),
                                                image:
                                                    product['image'].toString(),
                                                name: product['product_name']
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF223043),tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            minimumSize: const Size(60, 30),
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        child: const Text(
                                          'Buy',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "font"),
                                        ),
                                      ),
                               
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                wishlist.contains(productId)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () => toggleWishlist(productId),
                            ),
                          ),
                        ],
                      );
                    
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
