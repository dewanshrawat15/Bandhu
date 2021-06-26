import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:bandhu/utils/LoadingScreen.dart';
import 'package:bandhu/utils/colors.dart';

class ChecklistScreen extends StatefulWidget {
  final Map<String, dynamic> userDetails;
  ChecklistScreen({
    @required this.userDetails
  });

  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("todos").where("user", isEqualTo: widget.userDetails['email']).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          
        }
      ),
    );
  }
}