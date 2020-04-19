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
  YeetModel yeetModel = YeetModel();

  bool visible = false;

  @override
  void initState() {
    yeetModel.id = '1';
    yeetModel.displayname = "Jesse";
    yeetModel.username = "JesseRosemite";
    yeetModel.dateTime = DateTime.now();
    yeetModel.message = "Hi, it's me Jesse";

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
    return DateFormat('hh:mm').format(dateTime);
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
              itemCount: 5,
              padding: EdgeInsets.only(top: 20),
              itemBuilder: (context, index) {
                return Hero(tag: index.toString(), child: YeetCardWidget(yeetModel: yeetModel));
              },
            ),
          ),
        ),
      ),
    );
  }
}
