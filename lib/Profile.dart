import 'package:epi/api_service/auth_service.dart';
import 'package:epi/data/model/profile_view_model.dart';
import 'package:epi/locator/app_db.dart';
import 'package:epi/login/login_screen.dart';
import 'package:epi/sub_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> profileData = {}; // Holds user profile data
  PageController verificationViewController = PageController();
  bool isLoading = false;
  final AuthServices _authService = AuthServices();
  String? userName;
  String? email;
  late String userId;

  void _updateSystemUIOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Color(0xff013263),
          statusBarIconBrightness: Brightness.light,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    verificationViewController = PageController();
    _updateSystemUIOverlay();

    // _loadUserId();
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0),
          actionsPadding: EdgeInsets.fromLTRB(24, 0, 24, 20),

          // Icon
          icon: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF0A1F44).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.logout_rounded,
              color: Color(0xFF0A1F44),
              size: 32,
            ),
          ),

          // Title
          title: Text(
            'Logout',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Roboto",
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0A1F44),
              letterSpacing: 0,
            ),
          ),

          // Content
          content: Text(
            'Are you sure you want to logout from your account?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Roboto",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF5E5E5E),
              height: 1.5,
              letterSpacing: 0.25,
            ),
          ),

          // Actions
          actions: [
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFF0A1F44),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Color(0xFF0A1F44).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12),

                // Logout Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();

                      // Show loading
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Center(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CircularProgressIndicator(
                              color: Color(0xFF0A1F44),
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      );

                      await googleSignOut();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0A1F44),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  List<String> verificationImages = [
    "assets/image/get_verified_one.png",
    "assets/image/get_verified_two.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.maxFinite, 140),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff013263),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(8),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
              .copyWith(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "PROFILE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: "Roboto",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            name: appDB.user.name ?? "",
                            email: appDB.user.email ?? "",
                            onSave: () {},
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff2f2f2).withValues(alpha: 0.10),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Image.asset(
                        "assets/icon/edit_form.png",
                        height: 20,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /*  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xff0E263E),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Image.asset(
                        "assets/newui/avatar.png",
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),*/
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Color(0xff0E263E),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(
                            color: Color(0xff013263),
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  appDB.user.profilePicture ?? "",
                                  scale: 2))),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appDB.user.name ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Roboto",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xffffffff).withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(84),
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/image/google_logo.png",
                                scale: 3,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                appDB.user.email ?? "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  fontFamily: "Roboto",
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ))
                ],
              )
            ],
          ),
        ),
      ),
      /*AppBar(
        centerTitle: true,
        title: const Text(
          "PROFILE",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: "font",
          ),
        ),
      ),*/
      body: /* profileData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          :*/
          SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
              child: PageView.builder(
                allowImplicitScrolling: true,
                onPageChanged: (value) {},
                controller: verificationViewController,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: verificationImages.length,
                pageSnapping: true,
                itemBuilder: (context, index) {
                  return Image.asset(
                    verificationImages[index],
                    width: MediaQuery.of(context).size.width * 0.80,
                  );
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
              child: Column(
                children: [
                  Text(
                    "Get Help!",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          tapEvent(
                              title: getHelpList[index].title ?? "",
                              tapInfo: getHelpList[index].shortName ?? "");
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              getHelpList[index].leadingIcon ?? "",
                              scale: 3,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                getHelpList[index].title ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  fontFamily: "Roboto",
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: Colors.black,
                              size: 17,
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 15,
                    ),
                    itemCount: getHelpList.length,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          tapEvent(
                              title: settingsList[index].title ?? "",
                              tapInfo: settingsList[index].shortName ?? "");
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              settingsList[index].leadingIcon ?? "",
                              scale: 3,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                settingsList[index].title ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  fontFamily: "Roboto",
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: Colors.black,
                              size: 17,
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 15,
                    ),
                    itemCount: settingsList.length,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () => _showLogoutConfirmationDialog(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/profile_img/power.png",
                          scale: 3,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Log out",
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: "Roboto",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 25),
              child: Image.asset(
                "assets/profile_img/invest_logo.png",
                fit: BoxFit.fitWidth,
              ),
            )
          ],
        ),

        /*Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(
              color: Colors.grey.shade200,
            ),
            ListTile(
              leading: const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFF223043),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "$username",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "font",
                ),
              ),
              subtitle: Text(
                "$email",
                style: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        name: username,
                        email: email,
                        onSave: (String newName, String newEmail) {
                          _saveProfileData(newName, newEmail);
                        },
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BankAccountPage(),
                    ),
                  );
                },
                leading: const Icon(
                  Icons.account_balance_outlined,
                  color: Color(0xFF223043),
                ),
                title: const Text('Bank Account'),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.verified_outlined,
                  color: Color(0xFF223043),
                ),
                title: Text('KYC Verify'),
                trailing: Icon(Icons.keyboard_arrow_right_outlined),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => wishlisttab()));
                },
                leading: const Icon(
                  Icons.favorite_border,
                  color: Color(0xFF223043),
                ),
                title: const Text('Wishlist'),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xFF223043),
                ),
                title: Text('Cart'),
                trailing: Icon(Icons.keyboard_arrow_right_outlined),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const about()));
                },
                leading: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF223043),
                ),
                title: const Text('About'),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HelpPage()));
                },
                leading: const Icon(
                  Icons.help_outline,
                  color: Color(0xFF223043),
                ),
                title: const Text('Help'),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: ListTile(
                onTap: () {
                  logout(context);
                },
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.red),
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        )*/
      ),
    );
  }

  Future<void> tapEvent(
      {required String tapInfo, required String title}) async {
    switch (tapInfo) {
      case "intro":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SubProfileScreen(
              title: title,
              viewType: tapInfo,
            ),
          ),
        );
        break;

      case "epi_work":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SubProfileScreen(
              title: title,
              viewType: tapInfo,
            ),
          ),
        );
        break;
      case "invest":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SubProfileScreen(
              title: title,
              viewType: tapInfo,
            ),
          ),
        );
        break;
      case "referral":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SubProfileScreen(
              title: title,
              viewType: tapInfo,
            ),
          ),
        );
        break;
      case "gift":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SubProfileScreen(
              title: title,
              viewType: tapInfo,
            ),
          ),
        );
        break;
      case "withdraw":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SubProfileScreen(
              title: title,
              viewType: tapInfo,
            ),
          ),
        );
        break;
      case "faq":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SubProfileScreen(
              title: title,
              viewType: tapInfo,
            ),
          ),
        );
        break;
      case "support":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SubProfileScreen(
              title: title,
              viewType: tapInfo,
            ),
          ),
        );
        break;
      case "privacy":
        var privacyPolicyUrl = Uri.https("epielio.com", "/privacy/");
        if (await canLaunchUrl(privacyPolicyUrl)) {
          await launchUrl(privacyPolicyUrl);
        } else {
          throw ("can't launch url");
        }
      default:
    }
  }

  Widget buildMenuPoint(
    String? img,
    String? title,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          img ?? "",
          scale: 3,
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
            child: Text(
          title ?? "",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            fontFamily: "Roboto",
            color: Colors.black,
          ),
        )),
      ],
    );
  }

  Future<void> googleSignOut() async {
    await _authService.logout();
    appDB.logout();
    // Remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false, // this removes all previous routes
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final Function() onSave;

  const EditProfilePage(
      {super.key,
      required this.name,
      required this.email,
      required this.onSave});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 5,
            fontWeight: FontWeight.bold,
            fontFamily: "font",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .12,
              ),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFF223043),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .08,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelText: "Name",
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .04,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelText: "Email",
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .08,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                  fixedSize: const Size(600, 50),
                  backgroundColor: const Color(0xFF223043),
                ),
                onPressed: () {
                  /* widget.onSave(
                    _nameController.text,
                    _emailController.text,
                  );*/
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Profile updated successfully.")),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    letterSpacing: 3,
                    fontFamily: "font",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
