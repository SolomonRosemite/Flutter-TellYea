import 'package:TellYea/pages/Settings/Preferences.dart';
import 'package:TellYea/backend/SmallFunctions.dart';
import 'package:TellYea/pages/ViewProfilePage.dart';
import 'package:TellYea/pages/PostYeetPage.dart';
import 'package:TellYea/common/YeetCard.dart';
import 'package:TellYea/backend/Backend.dart';
import 'package:TellYea/model/YeetModel.dart';
import 'package:TellYea/model/Profile.dart';
import 'package:TellYea/common/theme.dart';
import 'package:TellYea/SplashScreen.dart';
import 'package:TellYea/main.dart';

import 'package:flutter/material.dart';

import 'dart:async';

import 'package:logger/logger.dart';

class Yeets {
  static List<YeetModel> yeetModels = new List<YeetModel>();
}

class YeetListPage extends StatefulWidget {
  @override
  YeetListPageState createState() => YeetListPageState();
}

class YeetListPageState extends State<YeetListPage> with TickerProviderStateMixin {
  List<YeetModel> yeetModels = new List<YeetModel>();
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

    var newYeetUserListener = Backend.initListener('TellYeaUsers');
    newYeetUserListener.addCreateListener(addUser);

    var updatedYeetUserListener = Backend.initListener('TellYeaUsers');
    updatedYeetUserListener.addUpdateListener(updateUser);

    loadMessages();

    timeString = SmallFunctions.formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  void _getTime() {
    final String formattedDateTime = SmallFunctions.formatDateTime(DateTime.now());
    setState(() {
      timeString = formattedDateTime;
    });
  }

  void addUser(Map user) => Backend.tellYeaUsers.add(user);

  void addMessages(Map map) {
    index += 1;

    setState(() {
      yeetModels.insert(0, new YeetModel(id: index.toString(), dateTime: DateTime.parse(map["dateTime"]), displayname: map["displayname"], username: map["username"], imageUrl: map["imageUrl"], message: map["message"], verified: map["verified"], ownerId: map["ownerId"]));
    });
    Yeets.yeetModels = yeetModels;
  }

  void loadMessages() async {
    if (await Backend.hasInternet() == false) return;
    var yeets = await Backend.readTable("Yeets");

    yeets.sort((a, b) => DateTime.parse(b["dateTime"]).compareTo(DateTime.parse(a["dateTime"])));

    for (var i = 0; i < yeets.length; i++) {
      yeetModels.add(new YeetModel(id: i.toString(), dateTime: DateTime.parse(yeets[i]["dateTime"]), displayname: yeets[i]["displayname"], username: yeets[i]["username"], imageUrl: yeets[i]["imageUrl"], message: yeets[i]["message"], verified: yeets[i]["verified"], ownerId: yeets[i]["ownerId"]));
      this.index = i;
    }
    Yeets.yeetModels = yeetModels;
  }

  Future<void> reloadAllMessages() async {
    List<Map<dynamic, dynamic>> yeets = await Backend.readTable("Yeets");
    List<YeetModel> yeetModelsTemp = new List<YeetModel>();

    // Added all yeets
    yeets = await Backend.readTable("Yeets");
    yeets.sort((a, b) => DateTime.parse(b["dateTime"]).compareTo(DateTime.parse(a["dateTime"])));

    for (var i = 0; i < yeets.length; i++) {
      yeetModelsTemp.add(new YeetModel(id: i.toString(), dateTime: DateTime.parse(yeets[i]["dateTime"]), displayname: yeets[i]["displayname"], username: yeets[i]["username"], imageUrl: yeets[i]["imageUrl"], message: yeets[i]["message"], verified: yeets[i]["verified"], ownerId: yeets[i]["ownerId"]));
      this.index = i;
    }
    setState(() {
      yeetModels = yeetModelsTemp;
      Yeets.yeetModels = yeetModelsTemp;
    });
    print('done');
  }

  void updateUser(Map user) {
    print('hiiiiiiiii');
    for (var i = 0; i < Backend.tellYeaUsers.length; i++) {
      if (Backend.tellYeaUsers[i]['ownerId'] == user['ownerId']) {
        Backend.tellYeaUsers[i]['colorScheme'] = user['colorScheme'];
        return;
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
                    Icons.update,
                    size: 20,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    await reloadAllMessages();
                  }),
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
