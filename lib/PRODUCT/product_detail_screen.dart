import 'dart:convert';

import 'package:epi/Bottom_NavigationPage.dart';
import 'package:epi/common_widget/common_back_button.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../api_service/api_endpoint.dart';
import '../common_widget/cached_network_image.dart';
import '../data/model/product_by_id_response_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
//VAr for Detail
  late ProductByIdResponseModel productByIdResponseModel;
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

  Widget _sizedContainer({Widget? child, double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(child: child),
    );
  }

  PageController imgController = PageController();
  bool isRecomndedRadio = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _updateSystemUIOverlay();
    fetchProductsById();
  }

  Future<void> addProductToWishList(String productId) async {
    String url = '';
    Map<String, String> prodId = {"productId": productId};
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(prodId),
      );
      debugPrint("Product detail response ${response.statusCode}");
      debugPrint("Product detail response body ${response.body}");
    } catch (e, s) {
      debugPrint("Error : $e");
      debugPrint("stack trace : $s");
    }
  }

  Future<void> fetchProductsById() async {
    String url = '${APIEndPoints.baseUrl}api/products/${widget.productId}';
    Map<String, dynamic> mappedWishList = {
      "wishlist": [],
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(mappedWishList),
      );
      debugPrint("Product detail response ${response.statusCode}");
      debugPrint("Product detail response body ${response.body}");

      if (response.statusCode == 200) {
        final data =
            ProductByIdResponseModel.fromJson(json.decode(response.body));
        debugPrint("BODY RUNTIME TYPE ${data.runtimeType}");
        debugPrint("Product ${data}");
        setState(() {
          productByIdResponseModel = data;

          isLoading = false;
        });
        debugPrint("NOW PRODUCT IS ${productByIdResponseModel}");
      } else {
        debugPrint("IN DETAIL PAGE STATUS CODE ${response.statusCode}");
        // showError("Status code: ${response.statusCode}");
      }
        } catch (e, s) {
      debugPrint("IN CATCH $s");
      debugPrint("IN CATCH Error $e");
    }
  }

  @override
  void dispose() {
    imgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: CommonAppbarButton(),
        ),
        leadingWidth: 60,
        toolbarHeight: 40,
        title: Text(
          "Detail",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          CommonAppbarButton(
            buttonClick: () {},
            icon: Icons.more_vert_rounded,
          ),
          SizedBox(
            width: 20,
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 305,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: imgController,
                          itemCount: productByIdResponseModel.images?.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: double.infinity,
                              height: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: cachedNetworkImageWidget(
                                  url: productByIdResponseModel.images![index],
                                ),
                              ),
                            );
                          },
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
                  SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmoothPageIndicator(
                          controller: imgController,
                          count: productByIdResponseModel.images?.length ?? 0,
                          effect: ExpandingDotsEffect(
                              dotHeight: 6,
                              dotWidth: 6,
                              expansionFactor: 2), // your preferred effect
                          onDotClicked: (index) {}),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xfff2f2f2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 20,
                                    color: Colors.yellow,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "${productByIdResponseModel.rating ?? 0.0} (${productByIdResponseModel.reviewCount} reviews)",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Roboto",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xfff2f2f2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.thumb_up,
                                    size: 20,
                                    color: Color(0xff013263),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    "${productByIdResponseModel.likePercentage ?? 0}% liked",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Roboto",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    productByIdResponseModel.name ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: "Roboto",
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xfff2f2f2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              productByIdResponseModel.installmentOptions !=
                                      null
                                  ? buildMRPText(
                                      amount: double.tryParse(
                                          productByIdResponseModel
                                              .installmentOptions!
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
                                              .toString())!,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    )
                                  : SizedBox.shrink(),
                              Text(
                                " for 6 months from ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Roboto",
                                  fontSize: 14,
                                  color: Color(0xff5e5e5e),
                                ),
                              ),
                              productByIdResponseModel.installmentOptions !=
                                      null
                                  ? buildMRPText(
                                      amount: double.tryParse(
                                          productByIdResponseModel
                                              .installmentOptions!
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
                                              .toString())!,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.info_outline,
                            size: 15,
                            color: Color(0xff5a5a5a),
                          ),
                        )
                      ],
                    ),
                  ),
                  ExpandableText(
                    productByIdResponseModel.description ?? "",
                    style: TextStyle(
                      color: Color(0xff5e5e5e),
                      fontSize: 14,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                    ),
                    expandText: "read more",
                    textAlign: TextAlign.start,
                    maxLines: 4,
                    animation: true,
                    collapseOnTextTap: true,
                    expandOnTextTap: false,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/newui/percent_vector.png",
                        scale: 3,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Offers",
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  productByIdResponseModel.installmentOptions != null
                      ? StatefulBuilder(builder: (context, planSetState) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xffd9d9d9),
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                bool isFirst = false;
                                final plan = productByIdResponseModel
                                    .installmentOptions?[index];

                                return Theme(
                                  data: ThemeData(
                                    splashColor: Colors.transparent,
                                  ),
                                  child: ExpansionTile(
                                    title: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Pay INR ${plan?.amount ?? 0.0} for ${plan?.period} ${plan?.periodUnit}",
                                          maxLines: 1,
                                        ),
                                        Spacer(),
                                        plan?.isRecommended == true
                                            ? Image.asset(
                                                "assets/image/recommended.png",
                                                width: 75,
                                                height: 19,
                                              )
                                            : const SizedBox.shrink(),
                                        Spacer(),
                                      ],
                                    ),
                                    showTrailingIcon: false,
                                    tilePadding: EdgeInsets.symmetric(
                                      vertical: 0,
                                    ),
                                    leading: GestureDetector(
                                      onTap: () {
                                        isRecomndedRadio = false;
                                        planSetState(
                                          () {
                                            for (var item
                                                in productByIdResponseModel
                                                    .installmentOptions!) {
                                              item.isSelected = false;
                                            }
                                            plan?.isSelected = true;
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 5,
                                            top: 15,
                                            bottom: 15,
                                            left: 15),
                                        child: Image.asset(
                                          isRecomndedRadio
                                              ? plan?.isRecommended == true
                                                  ? "assets/newui/selected_radio.png"
                                                  : "assets/newui/unselected_raio.png"
                                              : plan?.isSelected == true
                                                  ? "assets/newui/selected_radio.png"
                                                  : "assets/newui/unselected_raio.png",
                                          scale: 3,
                                        ),
                                      ),
                                    ),
                                    shape: Border(),
                                    collapsedShape: Border(),
                                    children: [],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => Divider(
                                height: 1,
                                color: Color(0xffd9d9d9),
                                endIndent: 0,
                                indent: 0,
                                thickness: 1,
                              ),
                              itemCount: productByIdResponseModel
                                      .installmentOptions?.length ??
                                  0,
                            ),
                          );
                        })
                      : const SizedBox.shrink(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff013263),
                            fixedSize: Size(
                              double.infinity,
                              50,
                            ),
                          ),
                          onPressed: () {
                            _showTermsAndConditionsPopup(context: context);
                          },
                          child: Text(
                            "Book Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Roboto",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  final List<bool> _checkboxValues = [false, false, false, false, false, false];

  void _showTermsAndConditionsPopup({required BuildContext context}) {
    // bool showMoreDetails = false;
    final parentContext = context;
    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (contextState, setState) {
            return Stack(
              children: [
                AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text(
                    "Investment and Product Purchase Agreement (Bond) Acknowledgment",
                    style: TextStyle(fontFamily: "font", fontSize: 15),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "By participating in the EPI (Easy Purchase Investment) program, I, the undersigned, acknowledge and agree to the following terms:",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontFamily: "font",
                              overflow: TextOverflow.clip),
                        ),
                        // if (showMoreDetails)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const Text(
                              //     style: TextStyle(
                              //         fontSize: 12, color: Colors.black),
                              //     "By participating in the EPI (Easy Purchase Investment) program, I, the undersigned, acknowledge and agree to the following terms:"),
                              const Text(
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                  "\n1. Investment Terms I understand that my daily investment of ₹[amount] will accumulate over the selected investment period (e.g., 6 months, 12 months) for the purpose of purchasing a product or earning commission rewards."),
                              const Text(
                                "\n2. Product Purchase I agree that at the end of the investment period, I will receive the product I have selected or an equivalent product, or if I choose, I can withdraw the invested amount (less applicable fees or penalties) within 7 days.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              const Text(
                                "\n3. Commission Earnings I understand that I will earn commissions based on my referrals and daily investment. If I choose not to purchase the product, I agree to the deduction from my earned commission as specified in the program.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              const Text(
                                "\n4. Withdrawal and Non-Purchase Clause If I decide not to purchase the product, I acknowledge that a portion of my earned commission will be deducted as per the conditions of this agreement, and the remaining balance will be credited back to me.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              const Text(
                                "\n5. Saoirse's Responsibility I understand that Saoirse IT Solutions LLP will manage the funds securely, and they are responsible for delivering the product or returning the invested funds within 7 days of the investment period’s completion.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              const Text(
                                "\n6. Legal Terms and Binding Agreement"
                                "\n6.1 Legal Binding Agreement: \nThis Agreement is a legally binding contract between the investor (hereinafter referred to as 'User') and Saoirse IT Solutions LLP (hereinafter referred to as 'Saoirse'). By accepting this Agreement, the User agrees to adhere to all the terms and conditions outlined herein.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              const Text(
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                  "\n6.2 Jurisdiction: \nThis Agreement shall be governed by and construed in accordance with the laws of India. Any disputes arising from this Agreement shall be resolved exclusively in the courts located in [location], India."),
                              const Text(
                                "\n6.3 Compliance with Laws: \nThe User agrees to comply with all applicable laws, regulations, and rules concerning investments, withdrawals, and earnings within the framework of the EPI program.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              const Text(
                                "\n6.4 Termination: \nSaoirse reserves the right to terminate this Agreement if the User engages in any fraudulent or illegal activity, violates the terms, or fails to meet the program's conditions.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              const Text(
                                "\n6.5 Legal Recourse: \nIf Saoirse fails to fulfill its obligations under this Agreement, including but not limited to the failure to deliver the product or return the invested funds within the specified time frame, the User has the right to seek legal recourse. The User may file a lawsuit against Saoirse IT Solutions LLP in accordance with Indian laws and regulations. Legal action must be initiated within 7 to 10 days from the date the User is notified of the failure to fulfill the obligation.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),

                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                "Digital Acknowledgment",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontFamily: "font"),
                              ),

                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                subtitle: const Text(
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black),
                                    "\n1. I acknowledge and agree to the terms and conditions of the Investment and Product Purchase Agreement (Bond) as outlined above."),
                                value: _checkboxValues[0],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _checkboxValues[0] = newValue ?? false;
                                  });
                                },
                              ),
                              // Checkbox for Term 2
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                subtitle: const Text(
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black),
                                    "\n2. I confirm that I am participating voluntarily and agree to the deductions from my commission if I choose not to purchase the product."),
                                value: _checkboxValues[1],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _checkboxValues[1] = newValue ?? false;
                                  });
                                },
                              ),
                              // Checkbox for Term 3
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                subtitle: const Text(
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black),
                                    "\n3. I understand that this Agreement is legally binding and governed by the laws of India."),
                                value: _checkboxValues[2],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _checkboxValues[2] = newValue ?? false;
                                  });
                                },
                              ),
                              // Checkbox for Term 4
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                subtitle: const Text(
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                  "\n4. I acknowledge that I have the right to seek legal recourse against Saoirse IT Solutions LLP in case of failure to fulfill their obligations, within 7 to 10 days from the notification of failure.",
                                ),
                                value: _checkboxValues[3],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _checkboxValues[3] = newValue ?? false;
                                  });
                                },
                              ),
                              const Text(
                                "Digital Signature",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontFamily: "font"),
                              ),
                              const Text(
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                                "\nBy clicking the 'I Agree' button below, I digitally sign this Agreement and confirm my understanding and acceptance of the terms outlined above.",
                              ),

                              // Checkbox for Term 5 (Agree to proceed)
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                subtitle: const Text(
                                  '5. I Agree',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                ),
                                value: _checkboxValues[4],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    // Deselect the 6th checkbox if 5th is selected
                                    if (newValue == true) {
                                      _checkboxValues[5] = false;
                                    }
                                    _checkboxValues[4] = newValue ?? false;
                                  });
                                },
                              ),
                              // Checkbox for Term 6 (Do not agree)
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                subtitle: const Text(
                                  '6. I Do Not Agree',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                ),
                                value: _checkboxValues[5],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    // Deselect the 5th checkbox if 6th is selected
                                    if (newValue == true) {
                                      _checkboxValues[4] = false;
                                    }
                                    _checkboxValues[5] = newValue ?? false;
                                  });
                                },
                              ),
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 10),
                                  text:
                                      "This updated version now specifies that users must initiate legal action within 7 to 10 days if Saoirse does not fulfill its obligations, giving clear timelines for users to act if necessary.",
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(double.maxFinite, 50),
                        backgroundColor: Color(0xFF013263),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                      onPressed: () {
                        // Navigator.of(context).pop();
                        if (_checkboxValues[0] == true &&
                            _checkboxValues[1] == true &&
                            _checkboxValues[2] == true &&
                            _checkboxValues[3] == true) {
                          if (_checkboxValues[4] == true) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => BottomNavigationPage(
                                  navigateIndex: 1,
                                ),
                              ),
                              (route) => false,
                            );
                          } else if (_checkboxValues[5] == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "to purchase product on EPI you have to agree terms and conditions and provide necessary information"),
                              ),
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Please agree terms and conditions for further process"),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Please checkmark our Digital acknowledgement conditions."),
                            ),
                          );
                        }
                        /* Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationPage(
                              navigateIndex: 1,
                            ),
                          ),
                          (route) => false,
                        );*/
                      },
                      child: Text(
                        "Agree",
                        style:
                            TextStyle(color: Colors.white, fontFamily: "font"),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 30,
                  top: 15,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey),
                          BoxShadow(color: Colors.grey)
                        ]),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close),
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildMRPText(
      {required double amount,
      required double fontSize,
      required FontWeight fontWeight}) {
    return Text(
      "₹$amount",
      style: TextStyle(
          color: Color(0xff013263),
          fontFamily: "Roboto",
          fontSize: fontSize,
          fontWeight: fontWeight),
    );
  }
}

/*
import 'package:epi/Bottom_NavigationPage.dart';
import 'package:epi/common_widget/common_back_button.dart';
import 'package:epi/data/model/product_plan_model.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productTitle;

  const ProductDetailScreen({super.key, required this.productTitle});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
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

  @override
  void initState() {
    super.initState();
    _updateSystemUIOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: CommonAppbarButton(),
        ),
        leadingWidth: 60,
        toolbarHeight: 40,
        title: Text(
          "Detail",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          CommonAppbarButton(
            buttonClick: () {},
            icon: Icons.more_vert_rounded,
          ),
          SizedBox(
            width: 20,
          )
        ],
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 305,
              child: Stack(
                children: [
                  PageView.builder(
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset(
                            "assets/images/product_detail_screen.png",
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 5,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonAppbarButton(
                          buttonClick: () {},
                          icon: Icons.favorite_border,
                          iconColor: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xfff2f2f2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 20,
                              color: Colors.yellow,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "5.0 (125 reviews)",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Roboto",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xfff2f2f2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.thumb_up,
                              size: 20,
                              color: Color(0xff013263),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "94% liked",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Roboto",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.productTitle,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                fontFamily: "Roboto",
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.start,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              margin: EdgeInsets.symmetric(
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Color(0xfff2f2f2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildMRPText(
                          amount: 5332,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                        Text(
                          " for 6 months from ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontSize: 14,
                            color: Color(0xff5e5e5e),
                          ),
                        ),
                        buildMRPText(
                          amount: 31990,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.info_outline,
                      size: 15,
                      color: Color(0xff5a5a5a),
                    ),
                  )
                ],
              ),
            ),
            ExpandableText(
              "Lorem ipsum dolor sit amet, consectetur adipisci elit. Etiam volutpat maximus quam. Donec ante ante, fringilla nec quam vel, tristique libero.Lorem ipsum dolor sit amet, consectetur adipisci elit. Etiam volutpat maximus quam. Donec ante ante, fringilla nec quam vel, tristique libero.Lorem ipsum dolor sit amet, consectetur adipisci elit. Etiam volutpat maximus quam. Donec ante ante, fringilla nec quam vel, tristique libero.",
              style: TextStyle(
                color: Color(0xff5e5e5e),
                fontSize: 14,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
              ),
              expandText: "read more",
              textAlign: TextAlign.start,
              maxLines: 4,
              animation: true,
              collapseOnTextTap: true,
              expandOnTextTap: false,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/newui/percent_vector.png",
                  scale: 3,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Offers",
                  style: TextStyle(
                    fontFamily: "Roboto",
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            StatefulBuilder(builder: (context, planSetState) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(0xffd9d9d9),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final plan = productPlanList[index];
                    return Theme(
                      data: ThemeData(
                        splashColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          "Pay INR ${plan.planPayment} for ${plan.duration}",
                        ),
                        tilePadding: EdgeInsets.symmetric(
                          vertical: 0,
                        ),
                        showTrailingIcon: false,
                        leading: GestureDetector(
                          onTap: () {
                            planSetState(
                              () {
                                for (var item in productPlanList) {
                                  item.isSelected = false;
                                }
                                plan.isSelected = true;
                              },
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 5, top: 15, bottom: 15, left: 15),
                            child: Image.asset(
                              plan.isSelected == true
                                  ? "assets/newui/selected_radio.png"
                                  : "assets/newui/unselected_raio.png",
                              scale: 3,
                            ),
                          ),
                        ),
                        shape: Border(),
                        collapsedShape: Border(),
                        children: [],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Color(0xffd9d9d9),
                    endIndent: 0,
                    indent: 0,
                    thickness: 1,
                  ),
                  itemCount: productPlanList.length,
                ),
              );
            }),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff013263),
                      fixedSize: Size(
                        double.infinity,
                        50,
                      ),
                    ),
                    onPressed: () {
                      _showTermsAndConditionsPopup();
                    },
                    child: Text(
                      "Book Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Roboto",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final List<bool> _checkboxValues = [false, false, false, false, false, false];

  void _showTermsAndConditionsPopup() {
    // bool showMoreDetails = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text(
                    "Investment and Product Purchase Agreement (Bond) Acknowledgment",
                    style: TextStyle(fontFamily: "font", fontSize: 15),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "By participating in the EPI (Easy Purchase Investment) program, I, the undersigned, acknowledge and agree to the following terms:",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontFamily: "font",
                              overflow: TextOverflow.clip),
                        ),
                        // if (showMoreDetails)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const Text(
                              //     style: TextStyle(
                              //         fontSize: 12, color: Colors.black),
                              //     "By participating in the EPI (Easy Purchase Investment) program, I, the undersigned, acknowledge and agree to the following terms:"),
                              const Text(
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                  "\n1. Investment Terms I understand that my daily investment of ₹[amount] will accumulate over the selected investment period (e.g., 6 months, 12 months) for the purpose of purchasing a product or earning commission rewards."),
                              const Text(
                                "\n2. Product Purchase I agree that at the end of the investment period, I will receive the product I have selected or an equivalent product, or if I choose, I can withdraw the invested amount (less applicable fees or penalties) within 7 days.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              const Text(
                                "\n3. Commission Earnings I understand that I will earn commissions based on my referrals and daily investment. If I choose not to purchase the product, I agree to the deduction from my earned commission as specified in the program.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              const Text(
                                "\n4. Withdrawal and Non-Purchase Clause If I decide not to purchase the product, I acknowledge that a portion of my earned commission will be deducted as per the conditions of this agreement, and the remaining balance will be credited back to me.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              const Text(
                                "\n5. Saoirse's Responsibility I understand that Saoirse IT Solutions LLP will manage the funds securely, and they are responsible for delivering the product or returning the invested funds within 7 days of the investment period’s completion.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              const Text(
                                "\n6. Legal Terms and Binding Agreement"
                                "\n6.1 Legal Binding Agreement: \nThis Agreement is a legally binding contract between the investor (hereinafter referred to as 'User') and Saoirse IT Solutions LLP (hereinafter referred to as 'Saoirse'). By accepting this Agreement, the User agrees to adhere to all the terms and conditions outlined herein.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              const Text(
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                  "\n6.2 Jurisdiction: \nThis Agreement shall be governed by and construed in accordance with the laws of India. Any disputes arising from this Agreement shall be resolved exclusively in the courts located in [location], India."),
                              const Text(
                                "\n6.3 Compliance with Laws: \nThe User agrees to comply with all applicable laws, regulations, and rules concerning investments, withdrawals, and earnings within the framework of the EPI program.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              const Text(
                                "\n6.4 Termination: \nSaoirse reserves the right to terminate this Agreement if the User engages in any fraudulent or illegal activity, violates the terms, or fails to meet the program's conditions.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              const Text(
                                "\n6.5 Legal Recourse: \nIf Saoirse fails to fulfill its obligations under this Agreement, including but not limited to the failure to deliver the product or return the invested funds within the specified time frame, the User has the right to seek legal recourse. The User may file a lawsuit against Saoirse IT Solutions LLP in accordance with Indian laws and regulations. Legal action must be initiated within 7 to 10 days from the date the User is notified of the failure to fulfill the obligation.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),

                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                "Digital Acknowledgment",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontFamily: "font"),
                              ),

                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                subtitle: const Text(
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black),
                                    "\n1. I acknowledge and agree to the terms and conditions of the Investment and Product Purchase Agreement (Bond) as outlined above."),
                                value: _checkboxValues[0],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _checkboxValues[0] = newValue ?? false;
                                  });
                                },
                              ),
                              // Checkbox for Term 2
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                subtitle: const Text(
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black),
                                    "\n2. I confirm that I am participating voluntarily and agree to the deductions from my commission if I choose not to purchase the product."),
                                value: _checkboxValues[1],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _checkboxValues[1] = newValue ?? false;
                                  });
                                },
                              ),
                              // Checkbox for Term 3
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                subtitle: const Text(
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black),
                                    "\n3. I understand that this Agreement is legally binding and governed by the laws of India."),
                                value: _checkboxValues[2],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _checkboxValues[2] = newValue ?? false;
                                  });
                                },
                              ),
                              // Checkbox for Term 4
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                subtitle: const Text(
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                  "\n4. I acknowledge that I have the right to seek legal recourse against Saoirse IT Solutions LLP in case of failure to fulfill their obligations, within 7 to 10 days from the notification of failure.",
                                ),
                                value: _checkboxValues[3],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _checkboxValues[3] = newValue ?? false;
                                  });
                                },
                              ),
                              const Text(
                                "Digital Signature",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontFamily: "font"),
                              ),
                              const Text(
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                                "\nBy clicking the 'I Agree' button below, I digitally sign this Agreement and confirm my understanding and acceptance of the terms outlined above.",
                              ),

                              // Checkbox for Term 5 (Agree to proceed)
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                subtitle: const Text(
                                  '5. I Agree',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                ),
                                value: _checkboxValues[4],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    // Deselect the 6th checkbox if 5th is selected
                                    if (newValue == true) {
                                      _checkboxValues[5] = false;
                                    }
                                    _checkboxValues[4] = newValue ?? false;
                                  });
                                },
                              ),
                              // Checkbox for Term 6 (Do not agree)
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                subtitle: const Text(
                                  '6. I Do Not Agree',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                ),
                                value: _checkboxValues[5],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    // Deselect the 5th checkbox if 6th is selected
                                    if (newValue == true) {
                                      _checkboxValues[4] = false;
                                    }
                                    _checkboxValues[5] = newValue ?? false;
                                  });
                                },
                              ),
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 10),
                                  text:
                                      "This updated version now specifies that users must initiate legal action within 7 to 10 days if Saoirse does not fulfill its obligations, giving clear timelines for users to act if necessary.",
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(double.maxFinite, 50),
                        backgroundColor: Color(0xFF013263),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                      onPressed: () {
                        // Navigator.of(context).pop();
                        if (_checkboxValues[0] == true &&
                            _checkboxValues[1] == true &&
                            _checkboxValues[2] == true &&
                            _checkboxValues[3] == true) {
                          if (_checkboxValues[4] == true) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => BottomNavigationPage(
                                  navigateIndex: 1,
                                ),
                              ),
                              (route) => false,
                            );
                          } else if (_checkboxValues[5] == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "to purchase product on EPI you have to agree terms and conditions and provide necessary information"),
                              ),
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Please agree terms and conditions for further process"),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Please checkmark our Digital acknowledgement conditions."),
                            ),
                          );
                        }
                        */
/* Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationPage(
                              navigateIndex: 1,
                            ),
                          ),
                          (route) => false,
                        );*/ /*

                      },
                      child: Text(
                        "Agree",
                        style:
                            TextStyle(color: Colors.white, fontFamily: "font"),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 30,
                  top: 15,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey),
                          BoxShadow(color: Colors.grey)
                        ]),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close),
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildMRPText(
      {required double amount,
      required double fontSize,
      required FontWeight fontWeight}) {
    return Text(
      "₹$amount",
      style: TextStyle(
          color: Color(0xff013263),
          fontFamily: "Roboto",
          fontSize: fontSize,
          fontWeight: fontWeight),
    );
  }
}
*/
