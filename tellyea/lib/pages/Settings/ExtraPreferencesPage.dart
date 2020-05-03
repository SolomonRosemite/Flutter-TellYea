import 'package:TellYea/model/ThisUser.dart';
import 'package:flutter/material.dart';

class ExtraPreferencesPage extends StatefulWidget {
  static const String routeName = "/ExtraPreferencesPage";

  @override
  _ExtraPreferencesPageState createState() => _ExtraPreferencesPageState();
}

class _ExtraPreferencesPageState extends State<ExtraPreferencesPage> {
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

  Widget niceInputField({String title = 'displayname', String initialValue, String hintText = 'username', int maxLines = 1}) {
    initialValue = hintText;
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      width: double.infinity,
      height: maxLines == 1 ? 90 : 150,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          TextField(
            maxLines: maxLines,
            controller: TextEditingController()..text = initialValue,
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
            icon: new Icon(Icons.done, size: 25, color: Colors.blue[300]),
            onPressed: () => Navigator.of(context).pop(null),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              Text(
                'Customize your Profile',
                style: TextStyle(
                  fontSize: 22.5,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              niceInputField(title: 'Name', hintText: ThisUser.displayname),
              niceInputField(title: 'Username', hintText: '@' + ThisUser.username),
              niceInputField(title: 'Bio', maxLines: 5, hintText: ThisUser.bio),
            ],
          ),
        ),
      ),
    );
  }
}
