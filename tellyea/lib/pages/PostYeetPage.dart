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
  Color selectedColor = ColorSchemes.primaryColor;

  String message = "";

  void test() async {
    Backend.save('Yeets', {
      'displayname': ThisUser.displayname,
      'colorScheme': ThisUser.colorScheme,
      'username': ThisUser.username,
      'message': message,
      'imageUrl': ThisUser.imageUrl,
      'dateTime': DateTime.now().toString(),
      'verified': ThisUser.verified,
    });
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
            icon: new Icon(Icons.send),
            //TODO: Send and pop. Disable button if context is empty
            onPressed: () => test(),
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
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 10,
                textInputAction: TextInputAction.newline,
                onChanged: (message) => this.message = message,
                decoration: InputDecoration(
                  hintText: "Comment!",
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 0.0),
                  ),
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
