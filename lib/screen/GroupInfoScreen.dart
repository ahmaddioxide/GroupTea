import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouptea/screen/MainScreen.dart';
import 'package:grouptea/services/Database_Service.dart';
import 'package:grouptea/shared/Shared.dart';
import 'package:grouptea/widgets/Colors.dart';

class GroupInfo extends StatefulWidget {
  String groupName;
  String groupId;
  String adminName;
  GroupInfo(
      {Key? key,
      required this.groupName,
      required this.groupId,
      required this.adminName})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  //String Manipulation

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }



  @override
  void initState() {
    getMembers();
    super.initState();
  }
  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
              AwesomeDialog(
                dialogType: DialogType.INFO,
                title: "Exit",
                context: context,
                desc: "Do you want leave this group?",
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).toggleGroupJoin(widget.groupId, getName(widget.adminName), widget.groupName).whenComplete(() {
                    nextScreenReplacement(context, const MainScreen());
                    });
                },
                btnOkColor: AppColors.secondary,
                btnCancelColor: primary,
                btnOkText: "Yes",
                btnCancelText: "No",
                dismissOnTouchOutside: false,
                headerAnimationLoop: false,
                autoHide: Duration(seconds: 10),
                buttonsBorderRadius: BorderRadius.circular(15),
                descTextStyle:const  TextStyle(
                  fontSize: 16,
                ))
              ..show();
          }, icon: const Icon(Icons.exit_to_app_rounded)),
        ],
        title: const Text(
          "Group Info",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: primary,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style:const  TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group : ${widget.groupName}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                       Text("Admin : ${getName(widget.adminName)}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Divider(thickness: 3,color: AppColors.secondary,),
           const SizedBox(height: 10,),

            memberList(),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            // print("sanapshot has data");
            if (snapshot.data['members'] != null) {
              if (snapshot.data['members'].length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data['members'].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: primary,
                              child: Text(
                                getName(snapshot.data['members'][index])
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style:const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            title: Text(getName(
                              snapshot.data['members'][index],
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,

                            ),)),
                      );
                    });
              } else {
                return const Center(
                  child: Text("No Members"),
                );
              }
            } else {
              return const Center(
                child: Text("No Members"),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: primary,
              ),
            );
          }
        });
  }
}
