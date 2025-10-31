// import 'dart:convert';
// import 'package:epi/100epicalc.dart';
// import 'package:flip_card/flip_card.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:epi/epiccalc.dart';
// import 'package:neumorphic_button/neumorphic_button.dart';
//
// class hundredOperation extends StatefulWidget {
//   const hundredOperation({Key? key}) : super(key: key);
//
//   @override
//   State<hundredOperation> createState() => _hundredOperationState();
// }
//
// class _hundredOperationState extends State<hundredOperation> {
//   List<dynamic> products = [];
//   List<dynamic> filteredProducts = [];
//   bool isLoading = true;
//   TextEditingController searchController = TextEditingController();
//   int? flippedIndex;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//     searchController.addListener(_filterProducts);
//   }
//
//   Future<void> fetchProducts() async {
//     const String url = 'http://16.171.26.118/display_100product.php';
//
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status_code'] == 200) {
//           setState(() {
//             products = data['products'];
//             filteredProducts = products;
//             isLoading = false;
//           });
//         } else {
//           _showErrorDialog(message: 'Error: ${data['msg']}');
//         }
//       } else {
//         _showErrorDialog(
//             message:
//                 'Failed to fetch products. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       _showErrorDialog(message: 'PLEASE CHECK YOUR INTERNET CONNECTION');
//     }
//   }
//
//   void _filterProducts() {
//     String query = searchController.text.toLowerCase();
//     setState(() {
//       filteredProducts = products.where((product) {
//         final name = product['product_name'].toLowerCase();
//         final description = product['description']?.toLowerCase() ?? '';
//         return name.contains(query) || description.contains(query);
//       }).toList();
//     });
//   }
//
//   void _showErrorDialog(
//       {String message = "An error occurred. Please try again."}) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             "Error",
//             style: TextStyle(fontFamily: "font"),
//           ),
//           content: Text(
//             message,
//             style: const TextStyle(fontFamily: "font"),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: TextField(
//                     controller: searchController,
//                     decoration: InputDecoration(
//                       hintText: "Search...",
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: GridView.builder(
//                     padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                       childAspectRatio: 5.5 / 6,
//                     ),
//                     itemCount: filteredProducts.length,
//                     itemBuilder: (context, index) {
//                       final product = filteredProducts[index];
//                       return FlipCard(
//                         //   onFlip: () {
//                         //   setState(() {
//                         //     if (flippedIndex == index) {
//                         //       flippedIndex = null; // Reset if the same card is tapped again
//                         //     } else {
//                         //       flippedIndex = index; // Set to current index
//                         //     }
//                         //   });
//                         // },
//                         //   flipOnTouch: flippedIndex == index,
//                         front: Card(
//                           color: Colors.white,
//                           elevation: 5,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   width: double.infinity,
//                                   child: product['image'] != null &&
//                                           product['image'].isNotEmpty
//                                       ? Image.network(
//                                           product['image'],
//                                           fit: BoxFit.cover,
//                                           errorBuilder:
//                                               (context, error, stackTrace) {
//                                             return const Icon(
//                                                 Icons.image_not_supported);
//                                           },
//                                         )
//                                       : const Icon(Icons.image_not_supported,
//                                           color: Colors.grey),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 5.0, top: 5, bottom: 5),
//                                 child: Text(
//                                   product['product_name'],
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 5.0),
//                                 child: Text('Price: ₹${product['price']}'),
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 8.0),
//                                     child: Text('ID: ${product['product_id']}'),
//                                   ),
//                                   NeumorphicButton(
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => HundredEpicalc(
//                                             productId: product['product_id'],
//                                             price: double.parse(
//                                                 product['price'].toString()),
//                                             image: product['image'].toString(),
//                                             name: product['product_name']
//                                                 .toString(),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     bottomRightShadowBlurRadius: 15,
//                                     bottomRightShadowSpreadRadius: 1,
//                                     borderWidth: 5,
//                                     backgroundColor: const Color(0xFF84B5C2),
//                                     topLeftShadowBlurRadius: 15,
//                                     topLeftShadowSpreadRadius: 1,
//                                     topLeftShadowColor: Colors.white,
//                                     bottomRightShadowColor:
//                                         Colors.grey.shade500,
//                                     height: 30,
//                                     width: 70,
//                                     padding: EdgeInsets.zero,
//                                     margin: const EdgeInsets.only(
//                                         right: 5, bottom: 5),
//                                     bottomRightOffset: const Offset(4, 4),
//                                     topLeftOffset: const Offset(-4, -4),
//                                     child: const Center(
//                                       child: Text(
//                                         'Buy',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         back: Card(
//                           color: Colors.white,
//                           elevation: 5,
//                           child: Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: const BoxDecoration(
//                               // color: Color(0xFF84B5C2),
//                               borderRadius: BorderRadius.vertical(
//                                   bottom: Radius.circular(10)),
//                             ),
//                             child: SingleChildScrollView(
//                               child: Text(
//                                 '${product['description']}',
//                                 style: const TextStyle(
//                                     overflow: TextOverflow.clip,
//                                     fontSize: 12,
//                                     color: Color(0xFF84B5C2),
//                                     fontFamily: "font"),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

import 'dart:convert';
import 'package:epi/100epicalc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class hundredOperation extends StatefulWidget {
  const hundredOperation({super.key});

  @override
  State<hundredOperation> createState() => _hundredOperationState();
}

class _hundredOperationState extends State<hundredOperation> {
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
                      return Stack(
                        children: [
                          Card(
                            color: Colors.white,
                            // elevation: 5,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: .5, color: Colors.black),
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
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 2),
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
                                              builder: (context) =>
                                                  HundredEpicalc(
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
                                                const Color(0xFF223043),
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
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
                              icon: Icon(
                                hundredwishlist.contains(productId)
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
