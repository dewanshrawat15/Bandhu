import 'package:bandhu/screens/YogaScreen.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:bandhu/utils/colors.dart';
import 'package:bandhu/utils/utils.dart';

import 'package:bandhu/screens/PedometerActivity.dart';
import 'package:bandhu/screens/WaterRecords.dart';

class HealthActivity extends StatefulWidget {
  final Map<String, dynamic> userDetails;
  HealthActivity({
    @required this.userDetails
  });

  @override
  _HealthActivityState createState() => _HealthActivityState();
}

class _HealthActivityState extends State<HealthActivity> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacer(size.height * 0.05, 0, null),
              Text(
                "Health",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  color: themeColor
                )
              ),
              spacer(32, 0, null),
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 20
                  ),
                  child: ListTile(
                    title: Text(
                      "Water activity logs",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 24
                      ),
                    ),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => WaterRecords(
                            userDetails: widget.userDetails
                          )
                        )
                      );
                    },
                    subtitle: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5
                      ),
                      child: Text(
                        "Click here to update and maintain water activity logs",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300
                        )
                      ),
                    ),
                  ),
                ),
              ),
              spacer(20, 0, null),
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 20
                  ),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => PedometerActivity(
                            userDetails: widget.userDetails
                          )
                        )
                      );
                    },
                    title: Text(
                      "Health activity logs",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 24
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5
                      ),
                      child: Text(
                        "Click here to update and maintain your pedometer logs",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300
                        )
                      ),
                    ),
                  ),
                ),
              ),
              spacer(20, 0, null),
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 20
                  ),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => YogaScreen()
                        )
                      );
                    },
                    title: Text(
                      "Learn Yoga",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 24
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5
                      ),
                      child: Text(
                        "Click here to practice Yoga and lead a healthy lifestyle",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300
                        )
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}