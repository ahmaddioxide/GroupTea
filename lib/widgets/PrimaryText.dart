import 'package:flutter/material.dart';
import 'package:grouptea/widgets/Colors.dart';

class PrimaryText extends StatelessWidget {
  String text='';
  double fontSize=22.0;

  PrimaryText({Key? key,required String this.text,double this.fontSize=22.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: AppColors.secondary,
    ),);
  }
}
