import 'package:bandhu/utils/colors.dart';
import 'package:flutter/material.dart';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:bandhu/screens/ChecklistScreen.dart';
import 'package:bandhu/screens/ThoughtScreen.dart';
import 'package:bandhu/screens/QuoteScreen.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userDetails;
  HomeScreen({
    @required this.userDetails
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          children: [
            QuoteScreen(
              userDetails: widget.userDetails
            ),
            ThoughtScreen(
              userDetails: widget.userDetails
            ),
            ChecklistScreen(
              userDetails: widget.userDetails
            ),
            Icon(
              Icons.fitness_center_rounded
            ),
            Icon(
              Icons.people_rounded
            ),
            Icon(
              Icons.headset_mic_rounded
            )
          ],
        )
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        backgroundColor: whiteColor,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            activeColor: lightThemeColor,
            inactiveColor: blackColor,
            title: Center(
              child: Text(
                "Quotes",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                )
              ),
            ),
            icon: Center(
              child: Icon(
                Icons.format_quote_rounded
              ),
            )
          ),
          BottomNavyBarItem(
            activeColor: lightThemeColor,
            inactiveColor: blackColor,
            title: Center(
              child: Text(
                "Thoughts",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500
                )
              ),
            ),
            icon: Icon(
              Icons.edit_rounded
            )
          ),
          BottomNavyBarItem(
            activeColor: lightThemeColor,
            inactiveColor: blackColor,
            title: Center(
              child: Text(
                "Checklist",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500
                )
              ),
            ),
            icon: Icon(
              Icons.check_box_outlined
            )
          ),
          BottomNavyBarItem(
            activeColor: lightThemeColor,
            inactiveColor: blackColor,
            title: Center(
              child: Text(
                "Health",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500
                )
              ),
            ),
            icon: Icon(
              Icons.fitness_center_rounded
            )
          ),
          BottomNavyBarItem(
            activeColor: lightThemeColor,
            inactiveColor: blackColor,
            title: Center(
              child: Text(
                "Engage",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500
                )
              ),
            ),
            icon: Icon(
              Icons.people_rounded
            )
          ),
          BottomNavyBarItem(
            activeColor: lightThemeColor,
            inactiveColor: blackColor,
            title: Center(
              child: Text(
                "Discuss",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500
                )
              ),
            ),
            icon: Icon(
              Icons.headset_mic_rounded
            )
          )
        ],
      )
    );
  }
}