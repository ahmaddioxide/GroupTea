import 'package:flutter/material.dart';
import 'package:grouptea/widgets/Colors.dart';

class messageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  messageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sentByMe})
      : super(key: key);

  @override
  State<messageTile> createState() => _messageTileState();
}

class _messageTileState extends State<messageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4,bottom: 4,left: widget.sentByMe?0:24,right: widget.sentByMe?24:0),
      alignment: widget.sentByMe?Alignment.centerRight:Alignment.centerLeft,

      child: Container(
        padding: EdgeInsets.only(top: 17,bottom: 17,left: 20,right: 20),
        margin: widget.sentByMe?EdgeInsets.only(left: 30):EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
          borderRadius: widget.sentByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))
              : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
          color: widget.sentByMe ? primary : AppColors.secondary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                letterSpacing: -0.3,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
