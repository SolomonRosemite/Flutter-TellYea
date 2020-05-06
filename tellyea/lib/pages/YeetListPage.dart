import 'package:TellYea/pages/Settings/Preferences.dart';
import 'package:TellYea/backend/SmallFunctions.dart';
import 'package:TellYea/pages/ViewProfilePage.dart';
import 'package:TellYea/pages/PostYeetPage.dart';
import 'package:TellYea/common/YeetCard.dart';
import 'package:TellYea/backend/Backend.dart';
import 'package:TellYea/model/YeetModel.dart';
import 'package:TellYea/model/Profile.dart';
import 'package:TellYea/SplashScreen.dart';
import 'package:TellYea/main.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import '../common/theme.dart';

class Yeets {
  static List<YeetModel> yeetModels = new List<YeetModel>();
}

class YeetListPage extends StatefulWidget {
  static const String routeName = "/home";

  @override
  YeetListPageState createState() => YeetListPageState();
}

class YeetListPageState extends State<YeetListPage> with TickerProviderStateMixin {
  List<YeetModel> yeetModels = new List<YeetModel>();
  List<Map<dynamic, dynamic>> yeets = new List();
  int index = 0;

  String timeString = "";
  bool visible = false;

  static TabController tabController;
  static Profile profile;

  @override
  void initState() {
    if (MyAppState.loadedSplashScreen == false) {
      Future.delayed(const Duration(milliseconds: 0), () {
        Navigator.pushNamed(context, Splash.routeName);
        visible = true;
      });
      tabController = new TabController(length: 3, initialIndex: 1, vsync: this);
    }
    var yeetListener = Backend.initListener('Yeets');
    yeetListener.addCreateListener(addMessages);

    // var updatedYeetListener = Backend.initListener('Yeets');
    // updatedYeetListener.addUpdateListener(updateYeet);

    var newYeetUserListener = Backend.initListener('TellYeaUsers');
    newYeetUserListener.addCreateListener(addUser);

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

  void addUser(Map user) => Backend.tellYeaUsers.add(user);

  void addMessages(Map map) {
    index += 1;
    Color colorScheme;
    switch (map["colorScheme"]) {
      case "primaryColor":
        colorScheme = ColorSchemes.primaryColor;
        break;
      case "red":
        colorScheme = ColorSchemes.red;
        break;
    }

    setState(() {
      yeetModels.insert(0, new YeetModel(id: index.toString(), dateTime: DateTime.parse(map["dateTime"]), colorScheme: colorScheme, displayname: map["displayname"], username: map["username"], imageUrl: map["imageUrl"], message: map["message"], verified: map["verified"], objectId: map["objectId"]));
    });
    Yeets.yeetModels = this.yeetModels;
  }

  void loadMessages() async {
    if (await Backend.hasInternet() == false) return;

    // Added all yeets
    yeets = await Backend.readTable("Yeets");
    yeets.sort((a, b) => DateTime.parse(b["dateTime"]).compareTo(DateTime.parse(a["dateTime"])));

    for (var i = 0; i < yeets.length; i++) {
      Color colorScheme = ColorSchemes.colorSchemesToColor(yeets[i]["colorScheme"]);
      yeetModels.add(new YeetModel(id: i.toString(), dateTime: DateTime.parse(yeets[i]["dateTime"]), colorScheme: colorScheme, displayname: yeets[i]["displayname"], username: yeets[i]["username"], imageUrl: yeets[i]["imageUrl"], message: yeets[i]["message"], verified: yeets[i]["verified"], objectId: yeets[i]["objectId"]));
      this.index = i;
    }
    Yeets.yeetModels = this.yeetModels;
  }

  void updateYeet(Map user) {
    print('update');
    for (var i = 0; i < yeetModels.length; i++) {
      if (yeetModels[i].objectId == user['objectId'] && yeetModels[i].dateTime == user['dateTime']) {
        print('here');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorSchemes.primaryColor,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: Duration(seconds: 1),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.settings,
                    size: 20,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pushNamed(context, Preferences.routeName)),
            ],
            title: Text(
              timeString,
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: TabBarView(
            controller: tabController,
            children: <Widget>[
              // Page View 1: Profile
              new Container(
                child: Center(
                  // TODO: Redesign 'Post YeetPage'
                  child: new ProfilePage(),
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
            controller: tabController,
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
            child: Icon(Icons.message),
          ),
        ),
      ),
    );
  }
}
