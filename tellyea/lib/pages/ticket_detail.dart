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
        ],
      ),
    );
  }

  Widget getCorners() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      width: showCorner ? 140 : 80,
      height: showCorner ? 140 : 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisSize: showCorner ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RotatedBox(
                  quarterTurns: 0,
                  child: Image.asset(
                    "images/corners.png",
                    width: 25.0,
                  )),
              RotatedBox(
                  quarterTurns: 1,
                  child: Image.asset(
                    "images/corners.png",
                    width: 25.0,
                  )),
            ],
          ),
          Spacer(),
          Row(
            mainAxisSize: showCorner ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RotatedBox(
                  quarterTurns: 3,
                  child: Image.asset(
                    "images/corners.png",
                    width: 25.0,
                  )),
              RotatedBox(
                  quarterTurns: 2,
                  child: Image.asset(
                    "images/corners.png",
                    width: 25.0,
                  )),
            ],
          ),
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
