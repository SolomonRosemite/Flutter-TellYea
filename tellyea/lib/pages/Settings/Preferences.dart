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

  void showMyDialog({String title = 'Unsaved Settings', String content = 'Are you sure you dont want to Save?', String confirmText = 'Don\'t Save'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Go Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
                color: Colors.red,
                child: new Text(
                  confirmText,
                  style: TextStyle(color: Colors.white),
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
    return Column(
      children: <Widget>[
        SizedBox(
          height: 0,
          // height: 1.5,
          width: double.infinity,
          child: Container(color: Colors.grey),
        ),
        Container(
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
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: new IconButton(
            icon: new Icon(Icons.close, size: 25, color: Colors.red[300]),
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
          new IconButton(
            icon: new Icon(Icons.done, size: 25, color: Colors.blue[300]),
            onPressed: () => Navigator.of(context).pop(null),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            // Container(
            //   height: 60,
            //   width: double.infinity,
            //   color: Colors.grey[400],
            //   child: Container(
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       '  @${ThisUser.username}',
            //       style: TextStyle(
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.grey[800],
            //       ),
            //     ),
            //   ),
            // ),
            Text(
              '@${ThisUser.username}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => print('change pic'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  ThisUser.imageUrl,
                  width: 120.0,
                  height: 120.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            FlatButton(
              onPressed: () {
                print('Change Profile pic');
              },
              child: Text(
                'Change Profile Picture',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            Spacer(flex: 1000),
            settingsbutton(
                callback: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                      title: Text('ColorScheme'),
                      message: Text('Pick a ColorScheme'),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Blue')),
                        CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Red'))
                      ],
                      cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel', style: TextStyle(color: Colors.red[300]))),
                    ),
                  );
                },
                context: 'Pick your ColorScheme',
                textAlignment: Alignment.center,
                fontSize: 15,
                textColor: Colors.black),
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
                  showMyDialog(title: 'Logout', content: 'Are you sure you want to Logout?', confirmText: 'Logout');
                },
                context: 'Logout',
                textAlignment: Alignment.center,
                fontSize: 15,
                textColor: Colors.red[300]),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
