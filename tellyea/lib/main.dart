import 'package:tellyea/pages/PlaneTicketListPage.dart';
import 'package:tellyea/SplashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  static bool onPage = false;
  static bool loadedSplashScreen = false;

  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      Splash.routeName: (BuildContext context) => new Splash(),
    };
    return MaterialApp(
      title: 'TellYea',
      home: new YeetListPage(),
      routes: routes,
    );
  }
}
