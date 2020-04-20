import 'package:tellyea/common/YeetCard.dart';
import 'package:tellyea/model/YeetModel.dart';
import 'package:tellyea/common/theme.dart';
import 'package:flutter/material.dart';

class YeetDetail extends StatefulWidget {
  final YeetModel ticket;

  YeetDetail({@required this.ticket});

  @override
  YeetDetailState createState() {
    return new YeetDetailState();
  }
}

class YeetDetailState extends State<YeetDetail> {
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
          Text(
            "Context",
            style: TextStyle(color: Colors.blue, fontSize: 40),
          ),
        ],
      ),
    );
  }
}
