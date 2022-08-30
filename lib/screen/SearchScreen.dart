import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouptea/helper/HelperFunctions.dart';
import 'package:grouptea/screen/ChatPage.dart';
import 'package:grouptea/services/Database_Service.dart';
import 'package:grouptea/shared/Shared.dart';
import 'package:grouptea/widgets/Colors.dart';
import 'package:grouptea/widgets/Widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  QuerySnapshot? SearchSnapshot;
  bool showLoading = false;
  bool hasUsersSearched =false;
  bool isJoined=false;
  TextEditingController SearchController = TextEditingController();
  String userName="";
  User? user;


  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }
  @override
  void initState() {
    getCurrentUserIdandName();
    super.initState();
  }


  getCurrentUserIdandName()async
  {
    await HelperFunctions.getUserName().then((value) {

      setState(() {
        userName=value;
      });
    });

    user =FirebaseAuth.instance.currentUser;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Search Group",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            // color: primary,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: SearchController,
                    decoration: InputDecoration(
                      labelText: "Search Group",
                      labelStyle: TextStyle(
                          color: primary, fontWeight: FontWeight.w600),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: AppColors.secondary,
                          )),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.secondary,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary.withOpacity(0.2),
                  ),
                  child: IconButton(
                      onPressed: () {
                        initiateSearchMethod();
                      },
                      icon: Icon(
                        Icons.search_rounded,
                        color: primary,
                        size: 30,
                      )),
                ),
              ],
            ),
          ),
          showLoading?Center(child: CircularProgressIndicator(color: primary,strokeWidth: 5,),):groupList(),
        ],
      ),
    );


  }

  groupList() {
    return hasUsersSearched? ListView.builder(
      shrinkWrap: true,
      itemCount: SearchSnapshot!.docs.length,
      itemBuilder: (context,index){
        return GroupTile(userName ,SearchSnapshot!.docs[index]['groupId'], SearchSnapshot!.docs[index]['groupName'], SearchSnapshot!.docs[index]['admin']);
      },):Container();

  }
  initiateSearchMethod()async {
    if(SearchController.text.isNotEmpty)
    {
      await DatabaseService().searchByName(SearchController.text.toString().trim()).then((snapshot) {
        setState(() {
          SearchSnapshot=snapshot;
          showLoading = false;
          hasUsersSearched=true;
        });
      });
    }

  }

  JoinedOrNot(
      String  userName,
      String groupId,
      String groupName,
      String admin,
      )async{

    await DatabaseService(uid: user!.uid).isUserJoined(groupName, groupId, userName).then((value) {
      setState(() {
        print("Is User Joined Value : ${value}");
        isJoined=value;
      });
    });

  }


  GroupTile(String UserName,String groupId,String groupName,String admin)
  {
    //Funtction to check either you are already a member fo this group of not
      JoinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: primary,
        child: Text(groupName.substring(0,1).toUpperCase(),style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),),
      ),

      title: Text("${groupName}",style: TextStyle(fontSize: 20,),),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: ()async{
          await DatabaseService(uid: user!.uid).toggleGroupJoin(groupId, userName, groupName);
        if(!isJoined){
          setState(() {
            isJoined=!isJoined;

          });
          showSnackBar(context, Colors.green, "Successfully joined ${groupName}");
          Future.delayed(Duration(seconds: 2),(){
            nextScreenReplacement(context, chatPage(groupId: groupId, groupName: groupName, userName: userName));
          });

        }else{
          setState(() {
            isJoined=!isJoined;
            showSnackBar(context, Colors.red, "Left the group ${groupName}");
          });
        }

        },
        child: isJoined?Container(
          padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text("Joined",style: TextStyle(color: Colors.white),),
        ):Container(
          padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child:const Text("Join Now"),
    ),
      ),
    );
  }
}
