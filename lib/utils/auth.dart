import 'package:flutter/material.dart';

import 'package:bandhu/utils/LoadingScreen.dart';
import 'package:bandhu/screens/LoginScreen.dart';

class AuthHandler extends StatefulWidget {

  @override
  _AuthHandlerState createState() => _AuthHandlerState();
}

class _AuthHandlerState extends State<AuthHandler> {

  bool hasLoaded = false;

  loadApp() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      hasLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadApp();
  }

  @override
  Widget build(BuildContext context) {
    return hasLoaded ? LoginScreen() : LoadingScreen();
  }
}