import 'package:tellyea/common/theme.dart';
import 'package:flutter/material.dart';

import 'common/theme.dart';

class Splash extends StatefulWidget {
  static const String routeName = "/MyTMSleepScreen";

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  bool _visible = false;
  final image = "images/qrcode.png";
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _visible = true;
      });
    });
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pop(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Center(
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
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
      ),
    );
  }
}
