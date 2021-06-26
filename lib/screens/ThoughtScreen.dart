import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:bandhu/utils/utils.dart';

class ThoughtScreen extends StatefulWidget {

  @override
  _ThoughtScreenState createState() => _ThoughtScreenState();
}

class _ThoughtScreenState extends State<ThoughtScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          spacer(0.3 * size.height, 0, null),
          Text(
            "Thoughts Screen",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500
            )
          )
        ],
      ),
    );
  }
}