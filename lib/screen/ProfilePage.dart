import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:grouptea/screen/MainScreen.dart';
import 'package:grouptea/widgets/PrimaryText.dart';
import 'package:grouptea/widgets/SecondaryText.dart';

import '../helper/HelperFunctions.dart';
import '../services/AuthenticationService.dart';
import '../shared/Shared.dart';
import '../widgets/Colors.dart';
import 'LoginScreen.dart';
import 'SearchScreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName='';
  String Email='';
  bool showLoading=true;

  @override
  void initState() {
    gettingUserData();
    super.initState();

  }

  gettingUserData() async {
    Email = await HelperFunctions.getEmail();
    userName = await HelperFunctions.getUserName();
    setState(() {
      showLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 30,
        backgroundColor: primary,
        centerTitle: true,
        title:const Text(
          "Profile",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchScreen());
              },
              icon:const Icon(Icons.search_rounded)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(
              Icons.account_circle_rounded,
              size: 130,
              color: primary,
            ),
            SizedBox(
              child: Center(
                  child: Text(
                userName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              )),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: Divider(
                color: AppColors.secondary,
                thickness: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: ListTile(
                tileColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  // side: BorderSide(
                  //     width: 2,
                  //     style: BorderStyle.solid,
                  //     ),
                  borderRadius: BorderRadius.circular(20),
                ),
                onTap: () {
                  nextScreenReplacement(context, MainScreen());
                },
                leading:const Icon(
                  Icons.groups_rounded,
                  color: Colors.white,
                ),
                title: const Text(
                  "Groups",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: ListTile(
                tileColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  // side: BorderSide(
                  //     width: 2,
                  //     style: BorderStyle.solid,
                  //     color: AppColors.secondary),
                  borderRadius: BorderRadius.circular(20),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // nextScreen(context, ProfilePage());
                },
                leading:const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title:const Text(
                  "Profile",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: ListTile(
                tileColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  // side: BorderSide(
                  //     width: 2,
                  //     style: BorderStyle.solid,
                  //     color: AppColors.secondary),
                  borderRadius: BorderRadius.circular(20),
                ),
                onTap: () {
                  AwesomeDialog(
                      dialogType: DialogType.INFO,
                      title: "Logout",
                      context: context,
                      desc: "Do you want to logout?",
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        SignOutPressed();
                      },
                      btnOkColor: AppColors.secondary,
                      btnCancelColor: primary,
                      btnOkText: "Yes",
                      btnCancelText: "No",
                      dismissOnTouchOutside: false,
                      headerAnimationLoop: false,
                      autoHide: Duration(seconds: 10),
                      buttonsBorderRadius: BorderRadius.circular(15),
                      descTextStyle: TextStyle(
                        fontSize: 16,
                      ))
                    ..show();
                  // SignOutPressed();
                },
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                ),
                title:const Text(
                  "Logout",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      body: showLoading?Center(child: CircularProgressIndicator(color: primary,strokeWidth: 3,),):Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding:const EdgeInsets.symmetric(vertical: 30,horizontal: 20),
              child: Column(
                children: [
                  Icon(
                    Icons.account_circle_rounded,
                    color: primary,
                    size: 200,
                  ),
                  const SizedBox(height: 30,),
                 Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     RichText(
                       // textAlign: TextAlign.end
                       text: TextSpan(
                         text: 'Name :',
                         style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                           color: primary,
                         ),
                         children:  <TextSpan>[
                           TextSpan(text: " "+userName, style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.secondary)),
                         ],
                       ),
                     ),
                     SizedBox(height: 20,),
                     RichText(
                       text: TextSpan(
                         text: 'Email :',
                         style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                           color: primary,
                         ),
                         children:  <TextSpan>[
                           TextSpan(text: " "+Email, style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.secondary,fontSize: 18)),
                         ],
                       ),
                     ),
                   ],
                 )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void SignOutPressed() {
    AuthService.SignOut().whenComplete(() {
      nextScreenReplacement(context, const LoginScreen());
    });
  }
}
