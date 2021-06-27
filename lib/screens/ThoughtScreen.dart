import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:bandhu/screens/AddEditThoughts.dart';
import 'package:bandhu/utils/colors.dart';
import 'package:bandhu/utils/utils.dart';

class ThoughtScreen extends StatefulWidget {
  final Map<String, dynamic> userDetails;
  ThoughtScreen({
    @required this.userDetails
  });

  @override
  _ThoughtScreenState createState() => _ThoughtScreenState();
}

class _ThoughtScreenState extends State<ThoughtScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacer(size.height * 0.075, 0, null),
              Text(
                "Thoughts",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  color: themeColor,
                  fontSize: 32
                )
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("thoughts").where("user", isEqualTo: widget.userDetails['email']).snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index){
                          return Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 18
                                  ),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data.docs[index]['title'],
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w700,
                                            color: themeColor,
                                            fontSize: 22
                                          )
                                        ),
                                        spacer(5, 0, null),
                                        Text(
                                          getDateFromTimestamp(snapshot.data.docs[index]['timestamp'].toDate()),
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w500,
                                            color: blackColor,
                                            fontSize: 15
                                          )
                                        )
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12
                                      ),
                                      child: Text(
                                        snapshot.data.docs[index]['description'],
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w300,
                                          color: blackColor
                                        )
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 9
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        onPressed: (){
                                          Map<String, dynamic> thoughtDetails = snapshot.data.docs[index].data();
                                          thoughtDetails['id'] = snapshot.data.docs[index].id;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) => AddEditThoughts(
                                                userDetails: widget.userDetails,
                                                thoughtDetails: thoughtDetails
                                              )
                                            )
                                          );
                                        },
                                        icon: Icon(
                                          Icons.edit_rounded,
                                          color: themeColor,
                                          size: 12,
                                        ),
                                        label: Text(
                                          "Edit thoughts",
                                          style: GoogleFonts.montserrat(
                                            color: themeColor,
                                            fontSize: 12
                                          )
                                        )
                                      ),
                                      TextButton.icon(
                                        onPressed: () async {
                                          String docID = snapshot.data.docs[index].id;
                                          await FirebaseFirestore.instance.collection("thoughts").doc(docID).delete();
                                        },
                                        icon: Icon(
                                          Icons.delete_rounded,
                                          color: themeColor,
                                          size: 12,
                                        ),
                                        label: Text(
                                          "Delete thought",
                                          style: GoogleFonts.montserrat(
                                            color: themeColor,
                                            fontSize: 12
                                          )
                                        )
                                      )
                                    ],
                                  ),
                                ),
                                spacer(9, 0, null)
                              ],
                            ),
                          );
                        },
                      );
                      break;
                    default:
                      return Container(
                        width: size.width,
                        height: size.height * 0.75,
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
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddEditThoughts(
                userDetails: widget.userDetails,
                thoughtDetails: {}
              )
            )
          );
        },
        label: Text(
          "Add new thought",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w300,
            color: Colors.white
          )
        )
      )
    );
  }
}