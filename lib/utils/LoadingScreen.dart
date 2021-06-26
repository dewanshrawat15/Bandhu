import 'package:bandhu/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:bandhu/utils/colors.dart';

class LoadingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Center(
          child: spacer(
            4,
            54,
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(themeColor),
            ),
          )
        ),
      ),
    );
  }
}