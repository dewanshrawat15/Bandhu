import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:sawo/sawo.dart';

import 'package:bandhu/utils/utils.dart';
import 'package:bandhu/utils/colors.dart';
import 'package:bandhu/utils/secrets.dart';

import 'package:bandhu/screens/HomeScreen.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailTextEditingController = TextEditingController();
  Map<String, dynamic> user = {};

  bool isDialogShowing = false;

  void _showDialog(bool isShowing){
    setState(() {
      isDialogShowing = isShowing;
    });
    if(isDialogShowing){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Row(
              children: [
                Container(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                  ),
                ),
                spacer(0, 12, null),
                Text(
                  "Signing in",
                  style: GoogleFonts.muktaMahee()
                ),
              ],
            ),
          );
        }
      );
    } else {
      Navigator.pop(context);
    }
  }

  payloadCallback(context, payload) async {
    if (payload == null || (payload is String && payload.length == 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Login failed, please try again later or contact support at help@bandhu.xyz",
            style: GoogleFonts.montserrat()
          )
        )
      );
    }
    setState(() {
      user = json.decode(payload);
    });
    _showDialog(false);
    await Future.delayed(Duration(seconds: 1));
    print(user);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen(
          userDetails: user
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              spacer(size.height * 0.12, 0, null),
              Text(
                "Bandhu",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  color: themeColor,
                  fontSize: 32
                ),
              ),
              spacer(12, 0, null),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 54
                ),
                child: Text(
                  "An online platform for people to connect, discuss and share",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    fontSize: 18
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              spacer(size.height * 0.084, 0, null),
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: themeColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 9
                  )
                ),
                label: Text(
                  "Login with email",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    color: whiteColor
                  ),
                ),
                icon: Icon(
                  Icons.person_rounded,
                  color: Colors.white
                ),
                onPressed: () async {
                  Sawo sawo = Sawo(
                    apiKey: sawoAuthKey,
                    secretKey: sawoSecretKey
                  );
                  _showDialog(true);
                  await Future.delayed(Duration(seconds: 2));
                  sawo.signIn(
                    context: context,
                    identifierType: 'email',
                    callback: payloadCallback
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}