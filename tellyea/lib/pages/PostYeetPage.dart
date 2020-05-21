import 'package:TellYea/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:TellYea/model/ThisUser.dart';
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

  bool alreadySending = false;

  void postYeet() async {
    if (alreadySending == true) {
      return;
    }

    if (message.isEmpty) {
      return;
    }

    alreadySending = true;

    message = message.trimLeft();
    message = message.trimRight();

    await Backend.saveAsync('Yeets', {
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
      backgroundColor: ColorSchemes.colorSchemesToColor(ThisUser.colorScheme),
      appBar: AppBar(
        backgroundColor: ColorSchemes.colorSchemesToColor(ThisUser.colorScheme),
        iconTheme: IconThemeData(color: Colors.white),
        title: Image.asset(
          'images/throw.png',
          height: 38,
          width: 38,
          color: Colors.white,
        ),
        centerTitle: true,
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
      body: Column(
        children: <Widget>[
          SizedBox(height: 15),
          Row(
            verticalDirection: VerticalDirection.up,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(width: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  ThisUser.imageUrl,
                  width: 45.0,
                  height: 45.0,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: TextField(
                    maxLines: 12,
                    autofocus: true,
                    textInputAction: TextInputAction.newline,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                    ),
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
                      hintText: "What's new?",
                      border: InputBorder.none,
                      focusColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
