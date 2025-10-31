import 'package:epi/WISHLIST/wishlist.dart';
import 'package:flutter/material.dart';
import '100wishlist.dart';

class wishlisttab extends StatelessWidget {
  const wishlisttab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Favorite",style: TextStyle(fontFamily: "font"),),
          centerTitle: true,
          bottom: const TabBar(indicatorColor:  Color(0xFF223043),
            tabs: [
              Tab( text: "product"),
              Tab( text: "100 Combo"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WishlistPage(),
            
            HundredWishlistPage(),
          ],
        ),
      ),
    );
  }
}
