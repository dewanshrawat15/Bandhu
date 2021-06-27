import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:bandhu/utils/colors.dart';
import 'package:bandhu/utils/utils.dart';

import 'package:bandhu/screens/AddEditChecklistItem.dart';

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("todos").where("user", isEqualTo: widget.userDetails['email']).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                List<Widget> checklistItems = [];
                List<Map<String, dynamic>> listOfItems = [];
                int tasksCompleted = 0;
                for (var item in snapshot.data.docs) {
                  Map<String, dynamic> itemData = item.data();
                  itemData['id'] = item.id;
                  listOfItems.add(itemData);
                  if(item['isCompleted']){
                    tasksCompleted += 1;
                  }
                }
                listOfItems.sort((a, b){
                  return b['timestamp'].compareTo(a['timestamp']);
                });
                for (var item in listOfItems) {
                  Widget newListTile = Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5
                    ),
                    child: ListTile(
                      tileColor: item['isCompleted'] ? lightThemeColor.withOpacity(0.32) : Colors.transparent,
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => AddEditWatchlistItem(
                              userDetails: widget.userDetails,
                              itemDetails: item
                            )
                          )
                        );
                      },
                      title: Text(
                        item['description'],
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500
                        )
                      ),
                      subtitle: Text(
                        getDateFromTimestamp(item['timestamp'].toDate()),
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w300
                        )
                      ),
                      trailing: Checkbox(
                        value: item['isCompleted'],
                        onChanged: (bool updatedBool) async {
                          item['isCompleted'] = updatedBool;
                          await FirebaseFirestore.instance.collection("todos").doc(item['id']).set(item);
                        }
                      ),
                    )
                  );
                  checklistItems.add(newListTile);
                }
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      spacer(size.height * 0.084, 0, null),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Checklist",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                fontSize: 32,
                                color: themeColor
                              )
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              tasksCompleted.toString() + " of " + checklistItems.length.toString() + " tasks completed",
                              style: GoogleFonts.montserrat(
                                color: lightBlackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 18
                              )
                            )
                          ],
                        ),
                      ),
                      spacer(12, 0, null),
                      Column(
                        children: checklistItems
                      )
                    ],
                  ),
                );
                break;
              default:
                return Container(
                  width: size.width,
                  height: size.height,
                  child: Center(
                    child: spacer(
                      4,
                      54,
                      LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                    )
                  ),
                );
            }
          }
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddEditWatchlistItem(
                userDetails: widget.userDetails,
                itemDetails: {}
              )
            )
          );
        },
        label: Text(
          "Add to-do item",
          style: GoogleFonts.montserrat(
            color: whiteColor,
            fontWeight: FontWeight.w400
          )
        ),
        icon: Icon(
          Icons.edit_rounded,
          color: whiteColor
        )
      ),
    );
  }
}