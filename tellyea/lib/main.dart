import 'package:TellYea/pages/login/screens/login_screen.dart';
import 'package:TellYea/backend/SharedPreferences.dart';
import 'package:TellYea/pages/YeetListPage.dart';
import 'package:TellYea/backend/Backend.dart';
import 'package:TellYea/SplashScreen.dart';

import 'package:flutter/material.dart';

bool loadLoginScreen = false;

void main() {
  runApp(new MaterialApp(
    home: MyApp(),
  ));
  loginUser();
}

void loginUser() async {
  if (await Backend.hasInternet() == false) {
    Backend.userIsOffline = true;
    return;
  }
  await MySharedPreferences.initialize();

  // If the user has already logged in before.
  if (MySharedPreferences.getString('username') != null) {
    Backend.loginUser(MySharedPreferences.getString('username'), MySharedPreferences.getString('password'));
    return;
  }
  loadLoginScreen = true;
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
      LoginScreen.routeName: (BuildContext context) => new LoginScreen(),
    };
    return MaterialApp(
      title: 'TellYea',
      home: new YeetListPage(),
      routes: routes,
    );
  }
}
