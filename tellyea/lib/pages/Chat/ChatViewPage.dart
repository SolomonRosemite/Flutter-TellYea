import 'package:TellYea/backend/backend.dart';
import 'package:TellYea/model/ThisUser.dart';

import 'package:flutter/material.dart';
import 'dart:async';

class ChatViewPage extends StatefulWidget {
  @override
  _ChatViewPageState createState() => _ChatViewPageState();
}

class _ChatViewPageState extends State<ChatViewPage> {
  Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => updateMessages());
  }

  void updateMessages() {
    print('test');
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Center(
            child: Text("Direct Message and Friends"),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                onPressed: () => Backend.save('Messages', {
                  'test': 'by: ${ThisUser.username}'
                }),
                // onPressed: () => print('message send'),
                child: Text('Send Test Message'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
