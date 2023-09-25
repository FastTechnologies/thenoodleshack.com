import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

appToast({
  String text='',
  Color toastColor

}){
  return Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor:toastColor?? Colors.black,
      textColor: Colors.white,
      fontSize: 16.0
  );
}