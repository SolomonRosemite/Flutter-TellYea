import 'package:flutter/material.dart';

class YeetLeftWidget extends StatelessWidget {
  final String displayname, username, message;

  YeetLeftWidget({@required this.displayname, @required this.username, @required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          displayname.toUpperCase(),
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2.0),
        Text(
          username,
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
        ),
        SizedBox(height: 10.0),
        Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
