import 'dart:convert';

import 'package:bandhu/utils/colors.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:bandhu/utils/LoadingScreen.dart';
import 'package:bandhu/utils/utils.dart';

class QuoteScreen extends StatefulWidget {

  final Map<String, dynamic> userDetails;
  QuoteScreen({
    @required this.userDetails
  });

  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {

  Map<String, dynamic> randomQuote = {};
  List<Map<String, dynamic>> fetchQuotes = [];

  bool isQuoteFavorite = false;

  fetchQuotesFromApi() async {
    String fetchQuotesApiEndpoint = "https://zenquotes.io/api/quotes";
    String randomQuoteApiEndpoint = "https://zenquotes.io/api/random";
    http.Response randomQuoteApiRepsonse = await http.get(randomQuoteApiEndpoint);
    http.Response fetchQuotesApiResponse = await http.get(fetchQuotesApiEndpoint);
    Map<String, dynamic> randomQuoteApiData = json.decode(randomQuoteApiRepsonse.body.toString())[0];
    List<Map<String, dynamic>> fetchQuotesApiData = List.from(json.decode(fetchQuotesApiResponse.body.toString()));
    List<Map<String, dynamic>> newFetchQuotesApiData = [];
    for (var item in fetchQuotesApiData){
      item['shouldRender'] = true;
      newFetchQuotesApiData.add(item);
    }
    setState(() {
      randomQuote = randomQuoteApiData;
      fetchQuotes = newFetchQuotesApiData;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchQuotesFromApi();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return randomQuote.isEmpty && fetchQuotes.isEmpty ? LoadingScreen() : SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacer(size.height * 0.05, 0, null),
            Card(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 18,
                  bottom: 12
                ),
                child: ListTile(
                  trailing: InkWell(
                    onTap: () async {
                      DateTime postDateTime = DateTime.now();
                      Map<String, dynamic> data = {
                        "quote": randomQuote['q'],
                        "author": randomQuote['a'],
                        "user": widget.userDetails['email'],
                        "liked_on": postDateTime
                      };
                      if(isQuoteFavorite){
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("quotes").where("user", isEqualTo: widget.userDetails['email']).where("quote", isEqualTo: randomQuote['q']).get();
                        querySnapshot.docs.forEach((element) async{
                          String id = element.id;
                          await FirebaseFirestore.instance.collection("quotes").doc(id).delete();
                        });
                      } else {
                        await FirebaseFirestore.instance.collection("quotes").add(data);
                      }
                      setState(() {
                        isQuoteFavorite = !isQuoteFavorite;
                      });
                    },
                    child: Icon(
                      isQuoteFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                      color: lightThemeColor
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's quote",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          color: blackColor,
                          fontSize: 20
                        )
                      ),
                      spacer(9, 0, null),
                      Text(
                        randomQuote['q'],
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w300,
                          color: blackColor
                        )
                      ),
                      spacer(5, 0, null)
                    ],
                  ),
                  subtitle: Text(
                    "~ " + randomQuote['a'],
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      color: themeColor
                    ),
                    textAlign: TextAlign.right
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              "Favorite Quotes",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 22
              )
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("quotes").where("user", isEqualTo: widget.userDetails['email']).snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(
                          trailing: InkWell(
                            onTap: () async {
                              await FirebaseFirestore.instance.collection("quotes").doc(snapshot.data.docs[index].id).delete();
                            },
                            child: Icon(
                              Icons.favorite,
                              color: themeColor,
                            ),
                          ),
                          title: Text(
                            snapshot.data.docs[index]['quote'],
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w300,
                              color: blackColor
                            )
                          ),
                          subtitle: Text(
                            snapshot.data.docs[index]['author'],
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              color: blackColor
                            )
                          ),
                        );
                      },
                    );
                  default:
                    return SizedBox();
                }
              }
            ),
            spacer(24, 0, null),
            Text(
              "Quotes",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 22
              )
            ),
            ListView.builder(
              physics: ScrollPhysics(),
              itemCount: fetchQuotes.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index){
                if(fetchQuotes[index]['shouldRender']){
                  return ListTile(
                    trailing: InkWell(
                      onTap: () async {
                        DateTime postDateTime = DateTime.now();
                        Map<String, dynamic> data = {
                          "quote": fetchQuotes[index]['q'],
                          "author": fetchQuotes[index]['a'],
                          "user": widget.userDetails['email'],
                          "liked_on": postDateTime
                        };
                        await FirebaseFirestore.instance.collection("quotes").add(data);
                        setState((){
                          fetchQuotes[index]['shouldRender'] = false;
                        });
                      },
                      child: Icon(
                        Icons.favorite_outline_rounded,
                        color: themeColor
                      )
                    ),
                    title: Text(
                      fetchQuotes[index]['q'],
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w300,
                        color: blackColor
                      )
                    ),
                    subtitle: Text(
                      fetchQuotes[index]['a'],
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        color: blackColor
                      )
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}