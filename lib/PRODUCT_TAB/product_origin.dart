import 'package:flutter/material.dart';
import 'package:epi/PRODUCT/100product_fetch.dart';
import 'package:epi/PRODUCT/product_fetch.dart';
import 'package:epi/PRODUCT/teen_products.dart';
import 'package:epi/PRODUCT/youth_products.dart';
import '../PRODUCT/kids_products.dart';

class ProductOrigin extends StatefulWidget {
  const ProductOrigin({super.key});

  @override
  State<ProductOrigin> createState() => _ProductOriginState();
}

class _ProductOriginState extends State<ProductOrigin> {
  String selectedItem = 'Youth'; // Default selected dropdown item
  int num = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Adjusted for available tabs
      child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0.0), // Increased height
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              num = 0;
                            });
                          },
                          child: Container(color: Colors.white,
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: Text(
                              "Products",
                              style: TextStyle(
                                color:
                                num == 0 ?const Color(0xFF223043): Colors.grey  ,
                                fontWeight: FontWeight.bold,
                                fontFamily: "font",
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              num = 1;
                            });
                          },
                          child: Container(color: Colors.white,
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: Text(
                              "100 Combo",
                              style: TextStyle(
                                color:
                                num == 1 ? const Color(0xFF223043): Colors.grey  ,
                                fontWeight: FontWeight.bold,
                                fontFamily: "font",
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(color: Colors.white,
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 60,
                          child: DropdownButton<String>(
                            style: TextStyle(
                              color:
                              num == 2 ?const Color(0xFF223043): Colors.grey  ,
                              fontWeight: FontWeight.bold,
                              fontFamily: "font",
                            ),
                            value: selectedItem,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedItem = newValue!;
                                num = 2;
                              });
                            },
                            items: ['Youth', 'Teen', 'Kids'].map((String key) {
                              return DropdownMenuItem<String>(
                                value: key,
                                child: Text(key),
                              );
                            }).toList(),
                            underline:
                            const SizedBox(), // Removes the dropdown underline
                            dropdownColor: Colors.white,
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
          body: (num == 0)
              ? const Operation()
              : (num == 1)
              ? const hundredOperation()
              : getPage(selectedItem)),
    );
  }

  Widget getPage(String page) {
    switch (page) {
      case 'Youth':
        return const YouthProducts();
      case 'Teen':
        return const TeenProducts();
      case 'Kids':
        return const KidsProducts();
      default:
        return const TeenProducts();
    }
  }
}
