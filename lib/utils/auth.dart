import 'package:flutter/material.dart';

import 'package:bandhu/utils/LoadingScreen.dart';
import 'package:bandhu/screens/LoginScreen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthHandler extends StatefulWidget {

  @override
  AuthHandlerState createState() => AuthHandlerState();
}

class AuthHandlerState extends State<AuthHandler> {

  bool hasLoaded = false;

  loadApp() async {
    await Future.delayed(Duration(seconds: 2));
    await Firebase.initializeApp();
    setState(() {
      hasLoaded = true;
    });
  }

  Future<void> loginUser(Map<String, dynamic> userData) async {
    userData['dailyWaterLimit'] = 2500;
    await FirebaseFirestore.instance.collection("users").doc(userData['email']).set(userData);
    await FirebaseFirestore.instance.collection("pedometer").doc(userData['email']).set({
      'email': userData['email'],
      'name': userData['name']
    });
  }

  @override
  void initState() {
    super.initState();
    loadApp();
  }

  @override
  Widget build(BuildContext context) {
    return hasLoaded ? LoginScreen(
      authHandlerState: this
    ) : LoadingScreen();
  }
}