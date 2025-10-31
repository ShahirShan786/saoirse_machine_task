import 'package:flutter/material.dart';

import 'common_widget/common_back_button.dart';

class SubProfileScreen extends StatefulWidget {
  final String title;
  final String viewType;

  const SubProfileScreen({
    super.key,
    required this.title,
    required this.viewType,
  });

  @override
  State<SubProfileScreen> createState() => _SubProfileScreenState();
}

class _SubProfileScreenState extends State<SubProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 10),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(
                0xff013263,
              ),
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 7, left: 18, top: 6),
          child: CommonAppbarButton(
            buttonColor: Color(0xfff2f2f2).withValues(alpha: 0.20),
            iconColor: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff013263),
        title: Text(widget.title),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          fontFamily: "Roboto",
          color: Colors.white,
        ),
        leadingWidth: 60,
        toolbarHeight: 50,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: getView(widget.viewType),
      ),
    );
  }

  Widget getView(type) {
    switch (type) {
      case "intro":
        return buildEpiDetailsWidget();
      case "epi_work":
        return buildHowEpiWorksWidget();
      case "invest":
        return buildInvestAndEarningPlanWidget();
      case "referral":
        return buildReferralSystemAndEarningWidget();
      case "gift":
        return buildContestAndRewardWidget();
      case "withdraw":
        return withdrawalAndPaymentWidget();
      case "faq":
        return faqSectionWidget();
      case "support":
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "For queries, assistance, or account issues, reach out to our support team. \n at \n Support Email: support@epi.com",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            )
          ],
        );
      default:
        return Center(
          child: Text(
            "Something went wrong",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        );
    }
  }

  Widget buildEpiDetailsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to EPI (Easy Purchase Investment)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'A unique investment-based platform where users can invest small amounts daily to accumulate funds for purchasing essential tech products, smartphones, gadgets, and more. Along with investment benefits, users can earn daily commissions by referring others, making EPI a dual-earning opportunity through investment growth and referral commissions.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Text(
          'Key Features of EPI:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        ...[
          'Flexible Investment Plans – Start with as low as ₹200 per day.',
          'Guaranteed Earnings – Earn up to 25% commission on your referrals\' investments.',
          'Tech Product-Based Investment – Invest towards essential products you want to buy.',
          'Referral Program – The more you refer, the more you earn!',
          'Exclusive 90-Day Contest – Win gifts by achieving milestones.',
          'Zero-Risk, High-Return Strategy – Invest wisely and maximize earnings.',
        ].map(
          (feature) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u25CF ',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1,
                  ),
                ),
                Expanded(
                  child: Text(
                    feature,
                    style: TextStyle(fontSize: 16, height: 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHowEpiWorksWidget() {
    final steps = [
      'User Registers & Selects a Plan – Choose an investment amount (₹200, ₹500, ₹1,000, etc.).',
      'Daily Investment Contribution – Deposit the chosen amount daily.',
      'Referral Program Activation – Refer friends & earn 25% of their daily investment.',
      'Earnings Accumulate – Daily earnings increase as investments and referrals grow.',
      'Redeem Products or Withdraw Earnings – Use your balance to buy products or withdraw as cash.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How EPI Works',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'EPI is designed to provide daily investment opportunities while ensuring users can purchase products affordably over time. The platform follows these steps:',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        ...steps.asMap().entries.map((entry) {
          int index = entry.key + 1;
          String step = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$index. ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                Expanded(
                  child: Text(
                    step,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget buildInvestAndEarningPlanWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Users can invest daily in different plans based on their affordability and product goals.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          SizedBox(height: 10),
          Text(
            'Investment Plans & Earnings Example:',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          SizedBox(height: 10),
          Text(
            'Bonus: Users can withdraw earnings anytime or use them to purchase gadgets, accessories, and other products through EPI.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget buildReferralSystemAndEarningWidget() {
    final examplePoints = [
      'No referral limit – More referrals = More earnings!',
      'Commissions are added daily, boosting total earnings.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Referral System & Earning',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'EPI rewards users for referring friends, offering 25% of each referral’s daily investment as commission. The more referrals you have, the higher your earnings.',
          style: TextStyle(fontSize: 16, height: 1),
        ),
        const SizedBox(height: 16),
        Text(
          'Example Earnings Based on Referrals',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        ...examplePoints.map((point) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\u25CF ',
                    style: TextStyle(fontSize: 15, height: 1),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style: TextStyle(fontSize: 16, height: 1),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget buildContestAndRewardWidget() {
    final rewardPoints = [
      'Invest & Stay Active: Maintain daily investments for 90 days.',
      'Refer Friends & Earn: Get minimum 10 active referrals who invest daily.',
      'Reach High Earnings Milestones: Users earning ₹10,000+ per month qualify for top-tier rewards.',
      'Lucky Draw for Bonus Prizes: Extra chances to win gadgets & cashback bonuses.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* Text(
          'Contest & Reward',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),*/
        Text(
          'EPI offers a 90-day contest where users can win exciting tech gadgets, smartphones, and bonus rewards based on their investment & referral performance.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 16),
        Text(
          'How to Win Rewards?',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        ...rewardPoints.map((point) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\u25CF ',
                    style: TextStyle(fontSize: 20, height: 0.9),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style: TextStyle(fontSize: 16, height: 1.2),
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 12),
        Text(
          '💡 Bonus Tip: The more referrals you have, the faster you qualify for bigger prizes!',
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget withdrawalAndPaymentWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Withdrawal & Payment Process',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'EPI ensures smooth withdrawals & payments, allowing users to cash out earnings anytime or use funds for product purchases.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 12),
        bulletPoint('Minimum Withdrawal: ₹1,000'),
        bulletPoint('Payout Methods: Bank Transfer, UPI, or EPI Wallet'),
        bulletPoint('Processing Time: 24-48 Hours'),
        SizedBox(height: 12),
        Text(
          'Users can track their earnings & withdrawals from the EPI Dashboard.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('\u25CF ', style: TextStyle(fontSize: 18, height: 0.8)),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget faqSectionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions (FAQs)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        faqItem(
          'Q1: How much can I earn from EPI?',
          'There is no limit! The more you invest & refer, the higher your earnings. Example: If you refer 10 people investing ₹1,000 daily, you earn ₹2,500 per day, i.e., ₹75,000 per month.',
        ),
        faqItem(
          'Q2:  Can I withdraw my earnings anytime?',
          'Yes! Withdrawals are processed within 24-48 hours after a minimum balance of ₹1,000 is reached.',
        ),
        faqItem(
          'Q3: What if my referrals stop investing?',
          'Your commission is based on active referrals. If they stop investing, your earnings from them stop. Encourage consistency for maximum benefits.',
        ),
        faqItem(
          'Q4: What happens after 90 days?',
          'You can continue investing, referring, and earning rewards! The system remains active for continuous profits.',
        ),
        faqItem(
          'Q5: Can I refer more than 10 people',
          'Yes! You earn 25% of EVERY referral’s daily investment – the more you refer, the more you earn!',
        ),
      ],
    );
  }

  Widget faqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              answer,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
