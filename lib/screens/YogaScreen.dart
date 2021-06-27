import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bandhu/utils/yoga.dart';
import 'package:bandhu/utils/colors.dart';

class YogaScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: yogaData.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            leading: Container(
              height: 42,
              width: 42,
              child: SvgPicture.network(
                yogaData[index]['img_url'],
                placeholderBuilder: (BuildContext context) => Container(
                  padding: const EdgeInsets.all(30.0),
                  child: const CircularProgressIndicator()
                ),
              ),
            ),
            title: Text(
              yogaData[index]['sanskrit_name'],
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w300,
                color: themeColor
              )
            ),
          );
        },
      ),
    );
  }
}