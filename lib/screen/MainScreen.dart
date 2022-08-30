import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouptea/helper/HelperFunctions.dart';
import 'package:grouptea/screen/LoginScreen.dart';
import 'package:grouptea/screen/ProfilePage.dart';
import 'package:grouptea/screen/SearchScreen.dart';
import 'package:grouptea/services/AuthenticationService.dart';
import 'package:grouptea/services/Database_Service.dart';
import 'package:grouptea/shared/Shared.dart';
import 'package:grouptea/widgets/Colors.dart';
import 'package:grouptea/widgets/Widgets.dart';
import 'package:grouptea/widgets/groupTile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String userName = "";
  String Email = "";
  String newGroupName = "";
  Stream? groups;
  bool shoeCircle = false;
  AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserName().then((value) {
      userName = value;
    });
    await HelperFunctions.getEmail().then((value) {
      Email = value;
    });

    //getting list of snapshot in your stream
    Stream snapshotStream =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .getUserGroups();
    setState(() {
      groups = snapshotStream;
    });
  }

  //String Manipulation
  String getId(String res) {
    return res.substring(0,res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 30,
        backgroundColor: primary,
        centerTitle: true,
        title:const Text(
          "Groups",
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
          padding:const EdgeInsets.symmetric(vertical: 50),
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
                  Navigator.pop(context);
                },
                leading:const Icon(
                  Icons.groups_rounded,
                  color: Colors.white,
                ),
                title:const Text(
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
                  nextScreen(context,const ProfilePage());
                },
                leading:const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: const Text(
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
                leading:const Icon(
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          popUpDialog(context);
        },
        label:const Text("GROUP"),
        icon: const Icon(Icons.add),
      ),
      body: groupList(),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              elevation: 20,
              title:const Text(
                "Create Group",
                textAlign: TextAlign.center,
              ),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                shoeCircle
                    ? Center(
                        child: CircularProgressIndicator(
                          color: primary,
                          strokeWidth: 5,
                        ),
                      )
                    : TextFormField(
                        onChanged: (value) {
                          newGroupName = value;
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: primary,
                                )),
                            labelText: "Group Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                      )
              ]),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel")),
                ElevatedButton(
                    onPressed: () async {
                      if (newGroupName != "") {
                        setState(() {
                          shoeCircle = true;
                        });
                        DatabaseService(
                                uid: FirebaseAuth.instance.currentUser!.uid)
                            .crateGroup(
                                userName,
                                FirebaseAuth.instance.currentUser!.uid,
                                newGroupName)
                            .whenComplete(() {
                          setState(() {
                            shoeCircle = false;
                          });
                          Navigator.of(context).pop();
                          showSnackBar(
                              context, primary, "Group created Successfully");
                        });
                      }
                    },
                    child: const Text("Create")),
              ],
            );
          });
        });
  }

  addGroup() {}
  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        //checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                   int reverseIndex=snapshot.data['groups'].length-index-1;
                    return groupTile(
                        groupId: getId(snapshot.data['groups'][reverseIndex]),
                        groupName: getName(snapshot.data['groups'][reverseIndex]),
                        userName: snapshot.data['fullname']);
                  });
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: primary,
              strokeWidth: 5,
            ),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                popUpDialog(context);
              },
              child: Icon(
                Icons.add_circle,
                color: primary,
                size: 75.0,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "You haven't joined any group yet, tap on above icon to create one",
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  void SignOutPressed() {
    AuthService.SignOut().whenComplete(() {
      nextScreenReplacement(context, const LoginScreen());
    });
  }
}
