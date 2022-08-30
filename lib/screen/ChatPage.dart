import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouptea/screen/GroupInfoScreen.dart';
import 'package:grouptea/services/Database_Service.dart';
import 'package:grouptea/shared/Shared.dart';
import 'package:grouptea/widgets/Colors.dart';
import 'package:grouptea/widgets/messageTile.dart';

class chatPage extends StatefulWidget {
  String groupName;
  String groupId;
  String userName;

  chatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<chatPage> createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  String admin = "";
  TextEditingController messageController = TextEditingController();
  Stream<QuerySnapshot>? chats;
  ScrollController scrollController = ScrollController();
  getChatandAdmin() async {
    Stream<QuerySnapshot> snapshotStream =
        await DatabaseService().getChats(widget.groupId);
    setState(() {
      chats = snapshotStream;
    });

    await DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  void initState() {
    setState(() {

    });
    getChatandAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                        groupName: widget.groupName,
                        groupId: widget.groupId,
                        adminName: admin));
              },
              icon: const Icon(Icons.info_outline_rounded))
        ],
      ),
      body: Column(

        children: [
          chatMessages(),
          Expanded(
            flex: 1,
            child: Container(
              color: AppColors.secondary,
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                width: MediaQuery.of(context).size.width,
                color: Colors.deepPurple[200],
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                            hintText: "Send a message",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          scrollController.jumpTo(scrollController.position.maxScrollExtent);

                        });
                        sendMessage();
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                            child: Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {

    return Expanded(
      flex: 6,
      child: Container(
        child: StreamBuilder(
            stream: chats,
            builder: (context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
                      // reverse: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        // scrollController.animateTo(
                        //   0.0,
                        //   duration: const Duration(milliseconds: 300),
                        //   curve: Curves.easeOut,
                        // );

                        return messageTile(
                            message: snapshot.data.docs[index]['message'],
                            sender: snapshot.data.docs[index]['sender'],
                            sentByMe: widget.userName ==
                                snapshot.data.docs[index]['sender']);
                      },
                    )
                  : Container();
            }),
      ),
    );

  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessage = {
        "message": messageController.text.toString(),
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessage);
      setState(() {
        messageController.clear();
        // Navigator.of(context).pop();
        FocusScope.of(context).unfocus();
      });
    }
  }
}
