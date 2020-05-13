import 'package:eventhandler/eventhandler.dart';
import 'package:TellYea/backend/backend.dart';
import 'package:TellYea/model/ThisUser.dart';
import 'package:TellYea/common/events.dart';

import 'package:flutter/material.dart';

class ChatViewPage extends StatefulWidget {
  @override
  ChatViewPageState createState() => ChatViewPageState();
}

class ChatViewPageState extends State<ChatViewPage> {
  @override
  void initState() {
    EventHandler().subscribe(newMessage);
    super.initState();
  }

  void newMessage(NewMessage item) {
    print('new Message');
  }

  @override
  void dispose() {
    EventHandler().unsubscribe(newMessage);
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
                child: Text('Send Test Message'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
