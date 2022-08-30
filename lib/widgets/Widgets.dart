import 'package:flutter/material.dart';
import 'package:grouptea/widgets/Colors.dart';

void showSnackBar(context,color,message)  {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,style:const  TextStyle(
    fontSize: 14,
  ),),backgroundColor:primary,
  duration: const Duration(seconds: 4),
    action: SnackBarAction(label: "OK",onPressed: (){},textColor: Colors.white,),

  ));
}