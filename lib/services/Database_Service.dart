import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //Reference for collections

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
//Saving the Userdata
  Future SavingUerData(
    String Fullname,
    String Email,
  ) async {
    return await userCollection.doc(uid).set({
      "fullname": Fullname,
      "email": Email,
      "groups": [],
      "profilepic": "",
      "uid": uid,
    });
  }

  Future gettingUserData(
    String Email,
  ) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: Email).get();
    return snapshot;
  }

  //getting user's groups joined
  getUserGroups() async {
    // DocumentSnapshot snapshot=userCollection.doc(uid).snapshots();
    return FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
  }

  Future crateGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": '',
      "admin": "${id}_${userName}",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    //Updating members by concatenating their id and username
    //updating groupId because it wasn't generated before the group creation
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_${userName}"]),
      "groupId": groupDocumentReference.id,
    });
//adding group to the user's group list
    DocumentReference userDocumentReference = userCollection.doc(uid);
    await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

//getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }
  //getting group admin
Future getGroupAdmin(String groupId) async
{
    DocumentReference d=groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot= await d.get();
    return documentSnapshot['admin'];
}
//getting group members

 getGroupMembers(String groupId)async
{
  return groupCollection.doc(groupId).snapshots();
}

//getting groups by groupname for search function

Future searchByName(String groupName)
{
  return groupCollection.where('groupName',isEqualTo: groupName).get();

}

Future isUserJoined(String groupName,String groupId,String userName)async
{
    DocumentReference userDocumentReference=userCollection.doc(uid);
    DocumentSnapshot documentSnapshot =await userDocumentReference.get();
    List groups=await documentSnapshot['groups'];
    if(groups.contains("${groupId}_${groupName}")){
      return true;
    }
    else{
      return false;
    }
}

Future toggleGroupJoin(String groupId, String userName, String groupName)async
{
  DocumentReference userDocumentReference =userCollection.doc(uid);
  DocumentReference groupDocumentReference =groupCollection.doc(groupId);

  DocumentSnapshot documentSnapshot=await userDocumentReference.get();
  List groups=await documentSnapshot['groups'];
if(groups.contains("${groupId}_${groupName}"))  {
  await userDocumentReference.update({
    'groups':FieldValue.arrayRemove(["${groupId}_${groupName}"])
  });
  await groupDocumentReference.update({
    'members':FieldValue.arrayRemove(["${uid}_${userName}"])
  });
}else{
  await userDocumentReference.update({
    'groups':FieldValue.arrayUnion(["${groupId}_${groupName}"])
  });
  await groupDocumentReference.update({
    'members':FieldValue.arrayUnion(["${uid}_${userName}"])
  });
}
}

Future sendMessage(String groupId,Map<String,dynamic> chatMessageData)async
{
  groupCollection.doc(groupId).collection('messages').add(chatMessageData);
  groupCollection.doc(groupId).update(
    {
      "recentMessage": chatMessageData['message'],
      "recentMessageSender":chatMessageData['sender'],
      "recentMessageTime":chatMessageData['time'].toString(),
    }
  );
}

}


