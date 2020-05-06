import 'package:TellYea/backend/Backend.dart';
import 'package:TellYea/model/ThisUser.dart';
import 'package:flutter/material.dart';
import 'Preferences.dart';

class ExtraPreferencesPage extends StatefulWidget {
  static const String routeName = "/ExtraPreferencesPage";

  @override
  _ExtraPreferencesPageState createState() => _ExtraPreferencesPageState();
}

class _ExtraPreferencesPageState extends State<ExtraPreferencesPage> {
  static const String initialValue = "Customize your Profile";
  String alertUser = initialValue;

  Color buttonColor = Colors.blue[300];
  Color disabledColor = Colors.grey[400];

  Color alertColor = Colors.black;

  String username = ThisUser.username;

  // Controllers
  TextEditingController displaynameController = new TextEditingController()..text = ThisUser.displayname;
  TextEditingController usernameController = new TextEditingController()..text = ThisUser.username;
  TextEditingController bioController = new TextEditingController()..text = ThisUser.bio;

  void displaynameChanged(String displayname) {
    if (displayname.length <= 3 || displayname.length > 20) {
      setState(() {
        alertUser = 'DisplayName must be at leas 4 to 20 characters long';
        buttonColor = disabledColor;
        alertColor = Colors.red[400];
      });
      return;
    }
    setState(() {
      alertUser = initialValue;
      buttonColor = Colors.blue[300];
      alertColor = Colors.black;
    });

    setState(() {
      Save.displayname = displayname;
    });
  }

  void usernameChanged(String username) {
    if (username.length <= 3 || username.length > 16) {
      setState(() {
        alertUser = 'Username must be at leas 4 to 16 characters long';
        buttonColor = disabledColor;
        alertColor = Colors.red[400];
      });
      return;
    }

    if (username.contains(' ')) {
      setState(() {
        alertUser = 'Username Can\'t contain White-Spaces';
        buttonColor = disabledColor;
        alertColor = Colors.red[400];
      });
      return;
    }

    if (username.contains('@')) {
      setState(() {
        alertUser = 'Username Can\'t contain @';
        buttonColor = disabledColor;
        alertColor = Colors.red[400];
      });
      return;
    }
    setState(() {
      alertUser = initialValue;
      buttonColor = Colors.blue[300];
      alertColor = Colors.black;
    });

    this.username = username;
  }

  Future<bool> usernameAvailable() async {
    if (Save.username == username) {
      return true;
    }
    for (Map item in await Backend.readTable('TellYeaUsers')) {
      if (username.toLowerCase() == item['username'].toLowerCase()) {
        if (item['username'].toLowerCase() == ThisUser.username.toLowerCase()) {
          continue;
        }
        setState(() {
          alertUser = 'Username is taken';
          buttonColor = disabledColor;
          alertColor = Colors.red[400];
        });
        return false;
      }
    }

    Save.username = username;
    return true;
  }

  void bioChanged(String bio) {
    if (bio.length == 0) {
      setState(() {
        alertUser = 'Bio cant be empty';
        buttonColor = disabledColor;
        alertColor = Colors.red[400];
      });
      return;
    }
    setState(() {
      alertUser = initialValue;
      buttonColor = Colors.blue[300];
      alertColor = Colors.black;
    });

    Save.bio = bio;
  }

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
                  Save.bio = ThisUser.bio;
                  Save.displayname = ThisUser.displayname;
                  Save.username = ThisUser.username;
                  Navigator.of(context).pop();
                  closePage();
                }),
          ],
        );
      },
    );
  }

  Widget niceInputField({String title = 'displayname', @required TextEditingController controller, @required Function(String) callback, String hintText = 'username', int maxLines = 1}) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      width: double.infinity,
      height: maxLines == 1 ? 90 : 200,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          TextField(
            maxLines: maxLines,
            onChanged: (content) => callback(content),
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: hintText,
              labelText: title,
            ),
          ),
        ],
      ),
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
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 5,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.done, size: 25, color: buttonColor),
            onPressed: () async {
              if (alertUser == initialValue) {
                if (await usernameAvailable()) {
                  Navigator.of(context).pop(null);
                  return;
                }
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              Text(
                alertUser,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: alertColor,
                  fontSize: 22.5,
                ),
              ),
              SizedBox(height: 15),
              niceInputField(title: 'Name', controller: displaynameController, callback: (content) => displaynameChanged(content), hintText: ThisUser.displayname),
              niceInputField(title: 'Username', controller: usernameController, callback: (content) => usernameChanged(content), hintText: '@' + ThisUser.username),
              niceInputField(title: 'Bio', controller: bioController, callback: (content) => bioChanged(content), maxLines: 5, hintText: ThisUser.bio),
            ],
          ),
        ),
      ),
    );
  }
}
