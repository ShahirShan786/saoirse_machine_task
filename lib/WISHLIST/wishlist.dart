import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<dynamic> wishlistProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> wishlist = prefs.getStringList('wishlist') ?? [];
    if (wishlist.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    const String url = 'http://16.171.26.118/display_product.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status_code'] == 200) {
          setState(() {
            wishlistProducts = data['products']
                .where((product) => wishlist.contains(product['product_id'].toString()))
                .toList();
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Wishlist')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : wishlistProducts.isEmpty
          ? Center(child: Text("No items in wishlist"))
          : ListView.builder(
        itemCount: wishlistProducts.length,
        itemBuilder: (context, index) {
          final product = wishlistProducts[index];
          return Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ListTile(
              leading: Image.network(product['image'], width: 60, height: 60),
              title: Text(product['product_name'], style: const TextStyle(fontSize: 12,
                        fontFamily: "font", overflow: TextOverflow.ellipsis),
                    maxLines: 2,),
             
                        trailing:Text("₹${product['price']}", style: const TextStyle(
                        fontFamily: "font", overflow: TextOverflow.ellipsis),) ,
            ),
          );
        },
      ),
    );
  }
}
