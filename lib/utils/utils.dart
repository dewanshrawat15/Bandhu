import 'package:flutter/material.dart';

String getMonth(int n){
  List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  return months[n - 1];
}

String formatDate(int n){
  if(n < 10){
    return "0" + n.toString();
  } else {
    return n.toString();
  }
}

String getDateFromTimestamp(DateTime timestamp){
  return formatDate(timestamp.day) + " " + getMonth(timestamp.month) + ", " + timestamp.year.toString();
}

Widget spacer(double h, double w, Widget widget){
  return SizedBox(
    height: h,
    width: w,
    child: widget != null ? widget : SizedBox(),
  );
}