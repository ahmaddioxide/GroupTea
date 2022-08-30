import 'package:flutter/material.dart';
import 'package:grouptea/screen/ChatPage.dart';
import 'package:grouptea/shared/Shared.dart';
import 'package:grouptea/widgets/Colors.dart';

class groupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;

  const groupTile(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<groupTile> createState() => _groupTileState();
}

class _groupTileState extends State<groupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        nextScreen(context,chatPage(groupId: widget.groupId, groupName: widget.groupName, userName: widget.userName));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color:AppColors.secondary.withOpacity(0.2),
      ),
        padding: const EdgeInsets.symmetric(vertical: 5,),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: primary,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            widget.groupName,
            style:const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "Join the conversation as ${widget.userName}",
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
