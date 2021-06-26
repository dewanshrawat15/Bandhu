import 'package:flutter/material.dart';

Widget spacer(double h, double w, Widget widget){
  return SizedBox(
    height: h,
    width: w,
    child: widget != null ? widget : SizedBox(),
  );
}