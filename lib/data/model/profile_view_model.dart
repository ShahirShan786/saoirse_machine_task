class ProfileViewModel {
  final String? leadingIcon, title, shortName;

  ProfileViewModel({this.leadingIcon, this.title, this.shortName});
}

List<ProfileViewModel> getHelpList = [
  ProfileViewModel(
    leadingIcon: "assets/profile_img/home.png",
    title: "Introduction to EPI",
    shortName: "intro",
  ),
  ProfileViewModel(
    leadingIcon: "assets/profile_img/settings.png",
    title: "How EPI works?",
    shortName: "epi_work",
  ),
  ProfileViewModel(
    leadingIcon: "assets/profile_img/award.png",
    title: "Investment Plans & Daily Earnings",
    shortName: "invest",
  ),
  ProfileViewModel(
    leadingIcon: "assets/profile_img/share.png",
    title: "Referral System & Commission Earnings",
    shortName: "referral",
  ),
  ProfileViewModel(
    leadingIcon: "assets/profile_img/gift.png",
    title: "90-Day Contest & Gift Rewards",
    shortName: "gift",
  ),
  ProfileViewModel(
    leadingIcon: "assets/profile_img/rupee_sign.png",
    title: "Withdrawal & Payment Process",
    shortName: "withdraw",
  ),
];

List<ProfileViewModel> settingsList = [
  ProfileViewModel(
      leadingIcon: "assets/profile_img/rupee_sign.png",
      title: "Privacy Policy",
      shortName: "privacy"),
  ProfileViewModel(
    leadingIcon: "assets/profile_img/faq.png",
    title: "Frequently Asked Questions (FAQs)",
    shortName: "faq",
  ),
  ProfileViewModel(
    leadingIcon: "assets/profile_img/phone.png",
    title: "Contact & Support",
    shortName: "support",
  ),
];
