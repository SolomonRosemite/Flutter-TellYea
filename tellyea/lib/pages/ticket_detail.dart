import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tellyea/common/ticket_card.dart';
import 'package:tellyea/model/YeetModel.dart';
import 'package:tellyea/common/theme.dart';
import 'package:after_layout/after_layout.dart';

class TicketDetail extends StatefulWidget {
  final YeetModel ticket;

  TicketDetail({@required this.ticket});

  @override
  TicketDetailState createState() {
    return new TicketDetailState();
  }
}

class TicketDetailState extends State<TicketDetail> with AfterLayoutMixin<TicketDetail> {
  bool showCorner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 40.0),
          Hero(
            tag: widget.ticket.id,
            child: YeetCardWidget(yeetModel: widget.ticket),
          ),
          Spacer(),
          SizedBox(height: 80.0),
          // Text(
          //   "Context",
          //   style: TextStyle(color: Colors.blue, fontSize: 40),
          // ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    startTimer();
  }

  startTimer() {
    var duration = Duration(milliseconds: 300);
    Timer(duration, showCorners);
  }

  showCorners() {
    setState(() {
      showCorner = true;
    });
  }
}
