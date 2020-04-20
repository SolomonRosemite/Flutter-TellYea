import 'package:tellyea/backend/SmallFunctions.dart';
import 'package:tellyea/common/ticket_card.dart';
import 'package:tellyea/backend/backend.dart';
import 'package:tellyea/model/YeetModel.dart';
import 'package:tellyea/SplashScreen.dart';
import 'package:tellyea/main.dart';

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
    if (await Backend.hasInternet()) {
      print("we are online");

      // Added all yeets
      List<Map<dynamic, dynamic>> yeets = await Backend.readTable("Yeets");
      yeets.sort((a, b) => DateTime.parse(b["dateTime"]).compareTo(DateTime.parse(a["dateTime"])));

      for (var i = 0; i < yeets.length; i++) {
        yeetModels.add(new YeetModel(id: i.toString(), dateTime: DateTime.parse(yeets[i]["dateTime"]), displayname: yeets[i]["displayname"], username: yeets[i]["username"], imageUrl: yeets[i]["imageUrl"], message: yeets[i]["message"], verified: yeets[i]["verified"]));
      }
      return;
    }
    print("we are offline");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: Duration(seconds: 1),
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
          body: Container(
            child: ListView.builder(
              itemCount: yeetModels.length,
              padding: EdgeInsets.only(top: 20),
              itemBuilder: (context, index) {
                return Hero(tag: yeetModels[index].id, child: YeetCardWidget(yeetModel: yeetModels[index]));
              },
            ),
          ),
        ),
      ),
    );
  }
}
