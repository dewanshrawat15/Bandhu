import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bandhu/utils/colors.dart';
import 'package:bandhu/utils/utils.dart';

class AddEditWatchlistItem extends StatefulWidget {
  final Map<String, dynamic> userDetails;
  final Map<String, dynamic> itemDetails;
  AddEditWatchlistItem({
    @required this.userDetails,
    @required this.itemDetails
  });

  @override
  _AddEditWatchlistItemState createState() => _AddEditWatchlistItemState();
}

class _AddEditWatchlistItemState extends State<AddEditWatchlistItem> {

  TextEditingController addEditTextEditingController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  FocusNode addEditFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();

  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101)
    );
    String refactoredDateTime = getDateFromTimestamp(picked);
    if (picked != null && picked != selectedDate){
      setState(() {
        selectedDate = picked;
        dateController.text = refactoredDateTime;
      });
    }
  }

  @override
  initState(){
    super.initState();
    DateTime currDateTime = DateTime.now();
    dateController.text = getDateFromTimestamp(currDateTime);
    if(widget.itemDetails.containsKey('description')){
      addEditTextEditingController.text = widget.itemDetails['description'];
    }
    if(widget.itemDetails.containsKey('timestamp')){
      Timestamp postTimeStamp = widget.itemDetails['timestamp'];
      DateTime postDateTime = postTimeStamp.toDate();
      dateController.text = getDateFromTimestamp(postDateTime);
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
                widget.itemDetails.containsKey('id') ? "Update task" : "Add Task",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  color: themeColor,
                  fontSize: 32
                ),
              ),
              spacer(size.height * 0.05, 0, null),
              TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                minLines: 2,
                maxLines: 3,
                controller: addEditTextEditingController,
                textCapitalization: TextCapitalization.sentences,
                focusNode: addEditFocusNode,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w300,
                  color: themeColor
                ),
                autocorrect: false,
                onEditingComplete: () {
                  addEditFocusNode.unfocus();
                },
                cursorColor: themeColor,
                decoration: InputDecoration(
                  labelText: 'Adding a new task',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor
                    )
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor,
                      width: 2
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor,
                      width: 2
                    )
                  ),
                ),
              ),
              spacer(32, 0, null),
              TextFormField(
                onTap: (){
                  dateFocusNode.unfocus();
                  _selectDate(context);
                },
                controller: dateController,
                focusNode: dateFocusNode,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w300,
                  color: themeColor
                ),
                cursorColor: themeColor,
                decoration: InputDecoration(
                  labelText: 'Date',
                  labelStyle: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w300,
                    color: themeColor
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor
                    )
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor,
                      width: 2
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor,
                      width: 2
                    )
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
            "description": addEditTextEditingController.text,
            "user": widget.userDetails['email'],
            "isCompleted": false,
            "timestamp": selectedDate
          };
          if(widget.itemDetails.containsKey('id')){
            await FirebaseFirestore.instance.collection("todos").doc(widget.itemDetails['id']).set(data);
          } else{
            await FirebaseFirestore.instance.collection("todos").add(data);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.itemDetails.containsKey("id") ? "Updated to-do item" : "Added a new to-do item",
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
          widget.itemDetails.containsKey('id') ? "Update item" : "Add item"
        )
      ),
    );
  }
}