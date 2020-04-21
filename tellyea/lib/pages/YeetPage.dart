import 'package:TellYea/common/YeetCard.dart';
import 'package:TellYea/model/YeetModel.dart';
import 'package:flutter/material.dart';

class YeetDetail extends StatefulWidget {
  final YeetModel yeet;

  YeetDetail({@required this.yeet});

  @override
  YeetDetailState createState() => new YeetDetailState();
}

class YeetDetailState extends State<YeetDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.yeet.colorScheme,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: widget.yeet.colorScheme,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 40.0),
          Hero(
            tag: widget.yeet.id,
            child: YeetCardWidget(yeetModel: widget.yeet),
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
}
