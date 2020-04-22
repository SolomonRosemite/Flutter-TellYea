import 'package:TellYea/backend/SmallFunctions.dart';
import 'package:TellYea/common/YeetCard.dart';
import 'package:TellYea/backend/Backend.dart';
import 'package:TellYea/model/YeetModel.dart';
import 'package:TellYea/SplashScreen.dart';
import 'package:TellYea/main.dart';

import 'package:TellYea/pages/PostYeetPage.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import '../common/theme.dart';

class YeetListPage extends StatefulWidget {
  @override
  YeetListPageState createState() => YeetListPageState();
}

class YeetListPageState extends State<YeetListPage> {
  String timeString = "";
  List<YeetModel> yeetModels = new List<YeetModel>();
  bool visible = false;

  @override
  void initState() {
    if (MyAppState.loadedSplashScreen == false) {
      Future.delayed(const Duration(milliseconds: 0), () {
        Navigator.pushNamed(context, Splash.routeName);
        visible = true;
      });
    }

    loadMessages();

    timeString = SmallFunctions.formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = SmallFunctions.formatDateTime(now);
    setState(() {
      timeString = formattedDateTime;
    });
  }

  void loadMessages() async {
    if (await Backend.hasInternet() == false) return;

    // Added all yeets
    List<Map<dynamic, dynamic>> yeets = await Backend.readTable("Yeets");
    yeets.sort((a, b) => DateTime.parse(b["dateTime"]).compareTo(DateTime.parse(a["dateTime"])));

    for (var i = 0; i < yeets.length; i++) {
      Color colorScheme;
      switch (yeets[i]["colorScheme"]) {
        case "primaryColor":
          colorScheme = ColorSchemes.primaryColor;
          break;
        case "red":
          colorScheme = ColorSchemes.red;
          break;
      }
      yeetModels.add(new YeetModel(id: i.toString(), dateTime: DateTime.parse(yeets[i]["dateTime"]), colorScheme: colorScheme, displayname: yeets[i]["displayname"], username: yeets[i]["username"], imageUrl: yeets[i]["imageUrl"], message: yeets[i]["message"], verified: yeets[i]["verified"], objectId: yeets[i]["objectId"]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorSchemes.primaryColor,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: Duration(seconds: 1),
        child: DefaultTabController(
          initialIndex: 1,
          length: 3,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                timeString,
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              elevation: 10,
              backgroundColor: Colors.white,
            ),
            body: TabBarView(
              children: <Widget>[
                // Page View 1: Profile
                new Container(
                  child: Center(
                    // TODO: Work the Profile Page
                    child: Text("Profile"),
                  ),
                ),
                // Page View 2: Main YeetList
                new Container(
                  child: ListView.builder(
                    itemCount: yeetModels.length,
                    padding: EdgeInsets.only(top: 20),
                    itemBuilder: (context, index) {
                      return Hero(tag: yeetModels[index].id, child: YeetCardWidget(yeetModel: yeetModels[index]));
                    },
                  ),
                ),
                // Page View 3: Direct Message and Friends
                new Container(
                  child: Center(
                    child: Text("Direct Message and Friends"),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: new TabBar(
              tabs: [
                Tab(
                  icon: new Icon(Icons.account_box),
                ),
                Tab(
                  icon: new Icon(Icons.home),
                ),
                Tab(
                  icon: new Icon(Icons.message),
                )
              ],
              labelColor: Colors.red,
              unselectedLabelColor: Colors.blue,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.all(5.0),
              indicatorColor: Colors.blueGrey[700],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, PostYeet.routeName);
              },
              child: Icon(Icons.ac_unit),
            ),
          ),
        ),
      ),
    );
  }
}
