import 'package:flutter/material.dart';

import 'package:bandhu/utils/colors.dart';
import 'package:bandhu/utils/auth.dart';

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: themeColor,
        accentColor: lightThemeColor
      ),
      home: AuthHandler(),
    )
  );
}