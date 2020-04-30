import 'package:TellYea/backend/SharedPreferences.dart';
import 'package:TellYea/model/ThisUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:TellYea/common/theme.dart';

class Preferences extends StatefulWidget {
  static const String routeName = "/Preferences";

  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  Color buttonEnabled = Colors.grey;
  String bio = "";

  void closePage() => Navigator.of(context).pop();

  void showMyDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
                child: new Text(
                  "Don't Save",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  closePage();
                }),
          ],
        );
      },
    );
  }

  Widget settingsbutton({@required String context, @required Function() callback, Alignment textAlignment = Alignment.centerLeft, Color textColor = Colors.white, FontWeight fontWeight = FontWeight.normal, double fontSize = 15, double height = 50}) {
    return Container(
      width: double.infinity,
      // color: Colors.transparent,
      height: height,
      child: RaisedButton(
          color: Colors.white,
          elevation: 0,
          onPressed: () => callback(),
          child: Container(
            alignment: textAlignment,
            child: Text(
              context,
              style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: fontWeight),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: new IconButton(
            icon: new Icon(Icons.close, size: 25, color: Colors.black),
            onPressed: () {
              showMyDialog();
            }),
        title: Text(
          "Preferences",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 5,
        centerTitle: true,
        actions: <Widget>[
          new FlatButton(
            color: Colors.white,
            onPressed: () => Navigator.of(context).pop(null),
            child: Text('Done'),
          ),
        ],
      ),
      // body: preferences(context),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Account:\n@${ThisUser.username}',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => print('change pic'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  ThisUser.imageUrl,
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                print('Change Profile pic');
              },
              child: Text(
                'Change Profile Picture',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(left: 60, right: 60, top: 30),
            //   child: TextField(
            //     // maxLines: 1,
            //     textInputAction: TextInputAction.done,
            //     style: TextStyle(color: Colors.white),
            //     onChanged: (bio) {
            //       this.bio = bio;
            //       if (bio.isEmpty) {
            //         setState(() {
            //           buttonEnabled = Colors.grey;
            //         });
            //         return;
            //       }

            //       setState(() {
            //         buttonEnabled = Colors.white;
            //       });
            //     },
            //     decoration: InputDecoration(
            //       hintStyle: TextStyle(color: Colors.white),
            //       hintText: "Post a Yeet!",
            //       border: OutlineInputBorder(),
            //       focusColor: Colors.white,
            //     ),
            //   ),
            // ),
            // Container(
            //   margin: EdgeInsets.only(left: 60, right: 60, top: 30),
            //   child: TextField(
            //     maxLines: 1,
            //     textInputAction: TextInputAction.newline,
            //     style: TextStyle(color: Colors.white),
            //     onChanged: (bio) {
            //       this.bio = bio;
            //       if (bio.isEmpty) {
            //         setState(() {
            //           buttonEnabled = Colors.grey;
            //         });
            //         return;
            //       }

            //       setState(() {
            //         buttonEnabled = Colors.white;
            //       });
            //     },
            //     decoration: InputDecoration(
            //       hintStyle: TextStyle(color: Colors.white),
            //       hintText: "Post a Yeet!",
            //       border: OutlineInputBorder(),
            //       focusColor: Colors.white,
            //     ),
            //   ),
            // ),
            Spacer(flex: 1),
            Spacer(flex: 1000),
            RaisedButton(
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => CupertinoActionSheet(
                    title: Text('ColorScheme'),
                    message: Text('Pick a ColorScheme'),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                          onPressed: () {
                            print('1');
                            Navigator.pop(context);
                          },
                          child: Text('1')),
                      CupertinoActionSheetAction(
                          onPressed: () {
                            print('2');
                            Navigator.pop(context);
                          },
                          child: Text('2'))
                    ],
                    cancelButton: CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel')),
                  ),
                );
              },
              child: Text('Pick your ColorScheme'),
            ),
            Spacer(flex: 1000),
            settingsbutton(
                callback: () {
                  print('Edit Profile');
                },
                context: 'Edit Name and Bio',
                textAlignment: Alignment.center,
                fontSize: 15,
                textColor: Colors.black),
            settingsbutton(
                callback: () {
                  print('logout');
                },
                context: 'Logout',
                textAlignment: Alignment.center,
                fontSize: 15,
                textColor: Colors.black),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
