import 'package:TellYea/pages/login/screens/login_screen.dart';
import 'package:TellYea/common/theme.dart';
import 'package:TellYea/backend/backend.dart';
import 'package:TellYea/main.dart';

import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  static const String routeName = "/Splash";

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  bool visible = false;
  bool offlineImageVisible = false;
  bool buttonVisible = false;

  String image = "images/qrcode.png";
  final offlineImage = "images/no_wifi.png";

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        visible = true;
      });
    });
    fade(const Duration(seconds: 5));
    super.initState();
  }

  void fade(Duration duration) {
    // If the user is offline we dont continue
    if (Backend.userIsOffline == true) {
      setState(() {
        offlineImageVisible = true;
      });
      return;
    }

    Future.delayed(duration, () {
      // If the user isn't loaded yet. We wait 2 more seconds.
      if (Backend.userLoaded == false) {
        if (loadLoginScreen == true) {
          setState(() {
            visible = false;
          });
          Future.delayed(const Duration(milliseconds: 510), () {
            setState(() {
              image = "images/throw.png";
              visible = true;
              buttonVisible = true;
            });
            Navigator.pushNamed(context, LoginScreen.routeName);
          });
          return;
        }
        fade(const Duration(seconds: 2));
        return;
      }

      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        color: ColorSchemes.primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedOpacity(
                opacity: visible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Container(
                  height: 180,
                  width: 180,
                  child: Image(
                    image: AssetImage(image),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              AnimatedOpacity(
                opacity: buttonVisible ? 1.0 : 0.0,
                duration: Duration(seconds: 3),
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {},
                      elevation: 0,
                      color: Colors.transparent,
                      child: Text(
                        "Your Journey Starts Here",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    RaisedButton(
                      elevation: 5.0,
                      onPressed: () => buttonVisible ? Navigator.pop(context) : null,
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.white,
                      child: Text(
                        'Ready to Yeet🤾',
                        style: TextStyle(
                          color: Color(0xFF527DAA),
                          letterSpacing: 1.5,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: offlineImageVisible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 70,
                      width: 70,
                      child: Image(
                        image: AssetImage(offlineImage),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
