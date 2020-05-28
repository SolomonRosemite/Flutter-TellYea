import 'package:TellYea/pages/Settings/Preferences.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:TellYea/backend/SmallFunctions.dart';
import 'package:TellYea/pages/ViewProfilePage.dart';
import 'package:TellYea/pages/FollowingPage.dart';
import 'package:TellYea/pages/PostYeetPage.dart';
import 'package:TellYea/common/YeetCard.dart';
import 'package:TellYea/backend/backend.dart';
import 'package:TellYea/model/YeetModel.dart';
import 'package:TellYea/model/Message.dart';
import 'package:TellYea/model/ThisUser.dart';
import 'package:TellYea/SplashScreen.dart';
import 'package:TellYea/common/theme.dart';
import 'package:TellYea/main.dart';

import 'package:flutter/material.dart';
import 'dart:async';

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

  // Listener
  bool assigned = false;

  EventHandler<Map<dynamic, dynamic>> yeetListener;
  EventHandler<Map<dynamic, dynamic>> newUserListener;
  EventHandler<Map<dynamic, dynamic>> updateUserListener;

  List<Message> messages = new List<Message>();

  @override
  void initState() {
    tabController = new TabController(length: 3, initialIndex: 1, vsync: this);
    if (MyAppState.loadedSplashScreen == false) {
      Future.delayed(const Duration(milliseconds: 0), () {
        Navigator.pushNamed(context, Splash.routeName);
        visible = true;
      });
    }

    loadYeets();

    timeString = SmallFunctions.formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  void _getTime() {
    if (assigned == false && Backend.userLoaded) {
      assigned = true;

      yeetListener = Backend.initListener('Yeets');
      yeetListener.addCreateListener(addYeet);

      newUserListener = Backend.initListener('TellYeaUsers');
      newUserListener.addCreateListener(addUser);

      updateUserListener = Backend.initListener('TellYeaUsersUpdater');
      updateUserListener.addCreateListener(updateUser);
    }

    final String formattedDateTime = SmallFunctions.formatDateTime(DateTime.now());
    setState(() {
      timeString = formattedDateTime;
    });
  }

  void addUser(Map user) => Backend.tellYeaUsers.add(user);

  void addYeet(Map map) {
    index += 1;

    setState(() {
      yeetModels.insert(0, new YeetModel(id: index.toString(), dateTime: DateTime.parse(map["dateTime"]), displayname: map["displayname"], username: map["username"], imageUrl: map["imageUrl"], message: map["message"], verified: map["verified"], ownerId: map["ownerId"]));
    });
    Yeets.yeetModels = yeetModels;
  }

  void loadYeets() async {
    if (await Backend.hasInternet() == false) return;
    var yeets = await Backend.readTable("Yeets");

    yeets.sort((a, b) => DateTime.parse(b["dateTime"]).compareTo(DateTime.parse(a["dateTime"])));

    for (var i = 0; i < yeets.length; i++) {
      yeetModels.add(new YeetModel(id: i.toString(), dateTime: DateTime.parse(yeets[i]["dateTime"]), displayname: yeets[i]["displayname"], username: yeets[i]["username"], imageUrl: yeets[i]["imageUrl"], message: yeets[i]["message"], verified: yeets[i]["verified"], ownerId: yeets[i]["ownerId"]));
      this.index = i;
    }
    Yeets.yeetModels = yeetModels;
  }

  void updateUser(Map user) {
    for (var i = 0; i < Backend.tellYeaUsers.length; i++) {
      if (Backend.tellYeaUsers[i]['ownerId'] == user['ownerId']) {
        Backend.tellYeaUsers[i]['bio'] = user['bio'];
        Backend.tellYeaUsers[i]['colorScheme'] = user['colorScheme'];
        Backend.tellYeaUsers[i]['displayname'] = user['displayname'];
        Backend.tellYeaUsers[i]['following'] = user['following'];
        Backend.tellYeaUsers[i]['imageUrl'] = user['imageUrl'];
        Backend.tellYeaUsers[i]['username'] = user['username'];
        Backend.tellYeaUsers[i]['verified'] = user['verified'];

        if (Backend.tellYeaUsers[i]['ownerId'] == ThisUser.ownerId) {
          Future.delayed(const Duration(seconds: 10), () {
            Backend.remove('TellYeaUsersUpdater', user);
          });
        }
        break;
      }
    }
    for (var i = 0; i < yeetModels.length; i++) {
      if (yeetModels[i].ownerId == user['ownerId']) {
        yeetModels[i].displayname = user['displayname'];
        yeetModels[i].imageUrl = user['imageUrl'];
        yeetModels[i].username = user['username'];
      }
    }
    Yeets.yeetModels = yeetModels;
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
                  child: new ProfilePage(),
                ),
              ),
              // Page View 2: YeetList
              new Container(
                child: ListView.builder(
                  itemCount: yeetModels.length,
                  padding: EdgeInsets.only(top: 20),
                  itemBuilder: (context, index) {
                    return Hero(tag: yeetModels[index].id, child: YeetCardWidget(yeetModel: yeetModels[index]));
                  },
                ),
              ),
              // Page View 3: Followers & Following
              new FollowingPage(),
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
