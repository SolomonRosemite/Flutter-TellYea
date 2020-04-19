import 'package:flutter/material.dart';
import 'package:tellyea/common/ticket_card.dart';
import 'package:tellyea/model/YeetModel.dart';

import 'package:tellyea/SplashScreen.dart';

import 'package:tellyea/main.dart';

import 'package:intl/intl.dart';
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

  String teststr = "I Lost my Phone at the\nAirport!";

  @override
  void initState() {
    yeetModels.add(new YeetModel(id: "0", dateTime: DateTime.now(), displayname: "James", username: "JamesFish", imageUrl: "https://m.media-amazon.com/images/I/81J+-QFsYuL._SS500_.jpg", message: "Finally back!"));
    yeetModels.add(new YeetModel(id: "1", dateTime: DateTime.now(), displayname: "Alex", username: "Alex123", imageUrl: "https://tmssl.akamaized.net/images/portrait/originals/88103-1540568385.jpg", message: "I like Food"));
    yeetModels.add(new YeetModel(id: "2", dateTime: DateTime.now(), displayname: "Jess", username: "JessRose", imageUrl: "https://www.bravo.de/assets/field/image/selena_gomez_liked_diese_pics_von_justin_bieber.jpg", message: teststr));
    yeetModels.add(new YeetModel(id: "3", dateTime: DateTime.now(), displayname: "Amy", username: "JessRose", imageUrl: "https://images3.alphacoders.com/901/901746.jpg", message: "I Lost my Phone!"));

    print(teststr.length);

    if (MyAppState.loadedSplashScreen == false) {
      Future.delayed(const Duration(milliseconds: 0), () {
        Navigator.pushNamed(context, Splash.routeName);
        visible = true;
      });
    }
    timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
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
