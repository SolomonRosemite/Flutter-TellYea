import 'package:flutter/material.dart';
import 'package:tellyea/common/ticket_card.dart';
import 'package:tellyea/model/YeetModel.dart';

import 'package:intl/intl.dart';
import 'dart:async';

class YeetListPage extends StatefulWidget {
  @override
  YeetListPageState createState() => YeetListPageState();
}

class YeetListPageState extends State<YeetListPage> {
  String timeString;

  @override
  void initState() {
    timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    createUsers();
    super.initState();
  }

  void createUsers() {}

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
    YeetModel yeetModel = YeetModel();
    yeetModel.id = "0";
    yeetModel.displayname = "Jesse";
    yeetModel.username = "JesseRosemite";
    yeetModel.dateTime = DateTime.now();
    yeetModel.message = "Hi, its me Jesse";

    return Scaffold(
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
    );
  }
}
