import 'package:TellYea/pages/Settings/ExtraPreferencesPage.dart';
import 'package:TellYea/pages/login/screens/login_screen.dart';
import 'package:TellYea/pages/Settings/Preferences.dart';
import 'package:TellYea/backend/SharedPreferences.dart';
import 'package:TellYea/pages/ViewProfilePage.dart';
import 'package:TellYea/pages/YeetListPage.dart';
import 'package:TellYea/pages/PostYeetPage.dart';
import 'package:TellYea/backend/Backend.dart';
import 'package:TellYea/SplashScreen.dart';
import 'package:TellYea/common/theme.dart';

import 'package:flutter/material.dart';

bool loadLoginScreen = false;

void main() {
  loginUser();
  runApp(new MaterialApp(
    home: MyApp(),
  ));
}

Future<void> loginUser() async {
  if (await Backend.hasInternet() == false) {
    Backend.userIsOffline = true;
    return;
  }
  await MySharedPreferences.initialize();

  Backend.tellYeaUsers = await Backend.readTable('TellYeaUsers');

  // If the user has already logged in before.
  if (MySharedPreferences.getString('email') != null) {
    await Backend.loginUser(MySharedPreferences.getString('email'), MySharedPreferences.getString('password'));
    Backend.appLoaded = true;
    return;
  }
  Backend.appLoaded = true;
  loadLoginScreen = true;
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  static bool onPage = false;
  static bool loadedSplashScreen = false;

  Widget a() {
    FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 500)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return YeetListPage();
          else
            return Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      ExtraPreferencesPage.routeName: (BuildContext context) => new ExtraPreferencesPage(),
      Preferences.routeName: (BuildContext context) => new Preferences(),
      ProfilePage.routeName: (BuildContext context) => new ProfilePage(),
      LoginScreen.routeName: (BuildContext context) => new LoginScreen(),
      PostYeet.routeName: (BuildContext context) => new PostYeet(),
      Splash.routeName: (BuildContext context) => new Splash(),
    };
    return MaterialApp(
      title: 'TellYea',
      home: FutureBuilder(
          future: Future.delayed(Duration(seconds: 2)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return YeetListPage();
            else
              return Container(color: ColorSchemes.primaryColor);
          }),
      color: ColorSchemes.primaryColor,
      routes: routes,
    );
  }
}
