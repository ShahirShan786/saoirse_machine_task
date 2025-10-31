import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<String> faqs = [
    'What is EPI?',
    'Why choose EPI?',
    'How does EPI work?',
    'What is the referral program?',
    'How can I start my EPI journey?'
  ];

  final Map<String, String> answers = {
    'What is EPI?':
        'EPI (Easy Purchase Investment) is an innovative savings and shopping plan that allows you to invest small amounts daily or weekly. Accumulate funds to purchase items like iPhones and more while enjoying discounts and rewards!',
    'Why choose EPI?':
        'EPI offers several benefits such as investing small amounts daily or weekly, getting discounts on market rates, participating in lucky draws for exciting prizes, and earning commissions through the referral program.',
    'How does EPI work?':
        '1. Choose your plan: Select daily or weekly investment.\n2. Start investing: Make small payments effortlessly.\n3. Watch your savings grow: Monitor your progress on our app.\n4. Redeem & enjoy: Use your accumulated funds for purchases at a discounted rate.',
    'What is the referral program?':
        'The referral program allows you to invite up to 10 friends. Earn daily commissions on their investments, build your network, and maximize your benefits.',
    'How can I start my EPI journey?':
        'Download the Elio e-Com app now and join EPI! For more information, contact us at +91 6238 691 096 or email us at support@eliotechno.com.'
  };

  final Map<String, bool> expanded = {
    'What is EPI?': false,
    'Why choose EPI?': false,
    'How does EPI work?': false,
    'What is the referral program?': false,
    'How can I start my EPI journey?': false,
  };

  void toggleExpansion(String question) {
    setState(() {
      expanded[question] = !expanded[question]!;
    });
  }

  // Function to open the Helpdesk contact popup
  void openHelpdeskPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController reasonController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();
        String? selectedReason;
        String? selectedCategory;
        List<String> reasons = ['Issue A', 'Issue B', 'Issue C'];
        List<String> categories = ['Category 1', 'Category 2', 'Category 3'];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                'Contact Backup',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: selectedReason,
                      hint: const Text('Select a reason'),
                      items: reasons.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedReason = newValue;
                        });
                      },
                    ),
                    DropdownButton<String>(
                      value: selectedCategory,
                      hint: const Text('Select a category'),
                      items: categories.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Description (min 20 words)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 6,
                      minLines: 3,
                      maxLength: 200,
                    ),
                    const SizedBox(height: 10),
                    if (selectedReason == null ||
                        !reasons.contains(selectedReason))
                      TextField(
                        controller: reasonController,
                        decoration: const InputDecoration(
                            hintText: 'Enter your reason'),
                      ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    if (descriptionController.text.trim().split(' ').length >=
                        20) {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            content: Text('We will contact you soon'),
                          );
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Please enter at least 20 words in the description.'),
                      ));
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Help',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 8,
            fontWeight: FontWeight.bold,
            fontFamily: "font",
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Image.asset(
            "assets/images/support.png", // Assuming you have a support image in your assets
            scale: 5,
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: ListView(
              children: faqs.map(
                (faq) {
                  return Card(
                    color: Colors.black,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            faq,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          onTap: () => toggleExpansion(faq),
                        ),
                        if (expanded[faq]!)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Column(
                              children: [
                                Text(
                                  answers[faq]!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Was this answer helpful?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black),
                                      onPressed: () {
                                        toggleExpansion(faq);
                                        // Handle "Useful" action
                                      },
                                      child: const Text(
                                        'Useful',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black),
                                      onPressed: () {
                                        toggleExpansion(faq);
                                        // Handle "Not Useful" action
                                      },
                                      child: const Text(
                                        'Not Useful',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "For more help",
                  style: TextStyle(color: Colors.black),
                ),
                TextButton(
                  style: const ButtonStyle(
                      padding:
                          WidgetStatePropertyAll(EdgeInsets.only(left: 5))),
                  onPressed:
                      openHelpdeskPopup, // Now this works to open the helpdesk popup
                  child: const Text(
                    'Contact Us',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
