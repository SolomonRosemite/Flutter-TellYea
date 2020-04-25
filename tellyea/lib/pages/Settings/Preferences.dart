import 'package:flutter/material.dart';

class Preferences extends StatefulWidget {
  static const String routeName = "/Preferences";

  final bool pageOnly;
  Preferences(this.pageOnly);

  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  Widget body() {
    return Container(
      // TODO: Add Settings here
      child: ListView.builder(
        itemCount: 5,
        // padding: EdgeInsets.only(top: 20),
        itemBuilder: (context, index) {
          return Text("data");
          // return Hero(tag: yeetModels[index].id, child: YeetCardWidget(yeetModel: yeetModels[index]));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pageOnly != true) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Preferences",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: <Widget>[
            new FlatButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('Done'),
            ),
          ],
        ),
        body: body(),
      );
    }
    return body();
  }
}
