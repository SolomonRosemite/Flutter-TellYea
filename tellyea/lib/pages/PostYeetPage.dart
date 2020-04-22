import 'package:TellYea/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:TellYea/backend/ThisUser.dart';
import 'package:TellYea/backend/Backend.dart';

class PostYeet extends StatefulWidget {
  static const String routeName = "/PostYeet";

  @override
  _PostYeetState createState() => _PostYeetState();
}

class _PostYeetState extends State<PostYeet> {
  // UI
  Color selectedColor = ColorSchemes.primaryColor;
  Color buttonEnabled = Colors.grey;

  String message = "";

  void postYeet() async {
    if (message.isEmpty) {
      return;
    }

    await Backend.saveAwait('Yeets', {
      'displayname': ThisUser.displayname,
      'colorScheme': ThisUser.colorScheme,
      'username': ThisUser.username,
      'message': message,
      'imageUrl': ThisUser.imageUrl,
      'dateTime': DateTime.now().toString(),
      'verified': ThisUser.verified,
    });

    Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedColor,
      appBar: AppBar(
        backgroundColor: selectedColor,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.send,
              color: buttonEnabled,
            ),
            onPressed: () => postYeet(),
          ),
        ],
        leading: new IconButton(
          icon: new Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 10,
                textInputAction: TextInputAction.newline,
                style: TextStyle(color: Colors.white),
                onChanged: (message) {
                  this.message = message;
                  if (message.isEmpty) {
                    setState(() {
                      buttonEnabled = Colors.grey;
                    });
                    return;
                  }

                  setState(() {
                    buttonEnabled = Colors.white;
                  });
                },
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: "Post Yeet!",
                  border: OutlineInputBorder(),
                  focusColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
