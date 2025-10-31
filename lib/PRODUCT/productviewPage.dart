import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Productviewpage extends StatefulWidget {
  const Productviewpage({super.key});

  @override
  State<Productviewpage> createState() => _ProductviewpageState();
}

class _ProductviewpageState extends State<Productviewpage> {
  PageController page = PageController();

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: screenwidth * 0.10,
                  width: screenwidth * 0.10,
                  child: Icon(Icons.arrow_back_ios_new),
                ),
              ),
              // SizedBox(
              //   width: 15,
              // ),
              Text("Details"),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: screenwidth * 0.10,
                width: screenwidth * 0.10,
                child: Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/download.jpg")),
                  ),
                  // margin: EdgeInsets.symmetric(horizontal: 20),
                  height: 160,
                  width: double.infinity,
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
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "5.0",
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "(125 reviews)",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.thumb_up,
                            color: Color(0xFF013263),
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "94%",
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "liked",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                    style: TextStyle(
                        fontFamily: "font", fontWeight: FontWeight.bold),
                    "Bedsheet for Double Bed Include Pillow Covers Breathable | Wrinklefree and Soft Touch Flat Double Bedsheet (Tranquil Green Petals)"),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "5332",
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "for 6 months from ",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                      ),
                      Text(
                        "31990",
                        style: TextStyle(fontSize: 12),
                      ),
                      Spacer(),
                      Icon(
                        Icons.info_outline,
                        color: Color(0xFF013263),
                        size: 15,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                    "QUALITY CRAFTSMANSHIP: This sheet set is made of high quality 100% polyester. The high-quality dye is resistant to running and will be resistant to fading through many wash cycles"),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Offers",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: screenheight * .4,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey)),
                        child: Column(
                          children: [
 Row(
                          children: [
                        
                            Text(
                             'Pay INR 200 everyday',
                              style: TextStyle(fontSize: 14),
                            ),
                            
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Recommended',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 10),
                                ),
                              ),
                          ],
                        ),
                          ],
                        ),
                ),
                Container(
                  height: screenheight * .4,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey)),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: offerOptions.length,
                    itemBuilder: (context, index) {
                      final option = offerOptions[index];
                      return RadioListTile(
                        value: option.value,
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value!;
                          });
                        },
                        title: Row(
                          children: [
                            Text(
                              option.title,
                              style: TextStyle(fontSize: 14),
                            ),
                            if (option.value == 0)
                              Container(height: 50,
                                margin: EdgeInsets.only(left: 8),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: SizedBox(height: 10,
                                  child: Text(
                                    'Recommended',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 10),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (option.subtitle.isNotEmpty)
                              Text(
                                option.subtitle,
                                style: TextStyle(fontSize: 10),
                              ),
                            if (option.dateRange != null)
                              Text(
                                option.dateRange!,
                                style: TextStyle(fontSize: 10),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.maxFinite, 50),
                      backgroundColor: Color(0xFF013263),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                    ),
                    onPressed: () {
                      _showTermsAndConditionsPopup();
                    },
                    child: Text(
                      "Book Now",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _selectedOption = 0;

  final List<OfferOption> offerOptions = [
    OfferOption(
      title: 'Pay INR 200 everyday',
      subtitle: 'Equivalent time: 166 days',
      dateRange: '04 Apr, 2025 - 12 Jul, 2025',
      value: 0,
    ),
    OfferOption(
      title: 'Pay INR 2,600 for 12 months',
      subtitle: '',
      value: 1,
    ),
    OfferOption(
      title: 'Pay INR 5,332 for 6 months',
      subtitle: '',
      value: 2,
    ),
    OfferOption(
      title: 'Pay INR 10,663 for 3 months',
      subtitle: '',
      value: 3,
    ),
  ];

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
                        Navigator.of(context).pop();
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
                      onPressed: () {},
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
}

class OfferOption {
  final String title;
  final String subtitle;
  final String? dateRange;
  final int value;

  OfferOption({
    required this.title,
    required this.subtitle,
    this.dateRange,
    required this.value,
  });
}
