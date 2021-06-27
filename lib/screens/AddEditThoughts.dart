import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bandhu/utils/utils.dart';
import 'package:bandhu/utils/colors.dart';

class AddEditThoughts extends StatefulWidget {
  final Map<String, dynamic> userDetails, thoughtDetails;
  AddEditThoughts({
    @required this.userDetails,
    @required this.thoughtDetails
  });

  @override
  _AddEditThoughtsState createState() => _AddEditThoughtsState();
}

class _AddEditThoughtsState extends State<AddEditThoughts> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  FocusNode titleFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    if(widget.thoughtDetails.containsKey('title')){
      titleController.text = widget.thoughtDetails['title'];
    }
    if(widget.thoughtDetails.containsKey('description')){
      descriptionController.text = widget.thoughtDetails['description'];
    }
    if(widget.thoughtDetails.containsKey('timestamp')){
      dateTime = widget.thoughtDetails['timestamp'].toDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacer(size.height * 0.08, 0, null),
              Text(
                widget.thoughtDetails.containsKey('id') ? "Update thought" : "Add thought",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  color: themeColor,
                  fontSize: 32
                ),
              ),
              spacer(18, 0, null),
              Text(
                getDateFromTimestamp(dateTime),
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: blackColor
                )
              ),
              spacer(size.height * 0.05, 0, null),
              TextFormField(
                keyboardType: TextInputType.text,
                autocorrect: false,
                controller: titleController,
                autofocus: true,
                style: GoogleFonts.montserrat(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: themeColor
                ),
                focusNode: titleFocusNode,
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  titleFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(descriptionFocusNode);
                },
                cursorColor: themeColor,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor
                    )
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor
                    )
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor,
                      width: 2
                    )
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor,
                      width: 2
                    )
                  ),
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: themeColor
                  ),
                  hintText: 'Title'
                ),
              ),
              SizedBox(
                height: 32,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 15,
                maxLines: 24,
                textInputAction: TextInputAction.newline,
                controller: descriptionController,
                textCapitalization: TextCapitalization.sentences,
                focusNode: descriptionFocusNode,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w300,
                  color: blackColor
                ),
                autocorrect: false,
                onEditingComplete: () {
                  descriptionFocusNode.unfocus();
                },
                cursorColor: blackColor,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: themeColor)),
                  disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: themeColor)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: themeColor, width: 2)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor,
                      width: 2
                    )
                  ),
                  hintText: 'Thoughts e.g. So we had planned to go out for....',
                  hintStyle: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w200,
                    color: Colors.black
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Map<String, dynamic> data = {
            "title": titleController.text,
            "description": descriptionController.text,
            "user": widget.userDetails['email'],
            "timestamp": dateTime
          };
          if(widget.thoughtDetails.containsKey('id')){
            await FirebaseFirestore.instance.collection("thoughts").doc(widget.thoughtDetails['id']).set(data);
          } else{
            await FirebaseFirestore.instance.collection("thoughts").add(data);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.thoughtDetails.containsKey("id") ? "Updated thought" : "Added a new thought",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w300
                )
              ),
            )
          );
          await Future.delayed(
            Duration(
              seconds: 2
            )
          );
          Navigator.pop(context);
        },
        label: Text(
          widget.thoughtDetails.containsKey("id") ? "Update thought" : "Add thought",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w300,
            color: Colors.white
          )
        )
      ),
    );
  }
}