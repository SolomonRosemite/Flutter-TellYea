import 'package:flutter/material.dart';

class Profile {
  String bio;
  String displayname;
  Color colorScheme;
  String imageUrl;
  String username;
  bool verified;

  Profile({@required this.displayname, @required this.bio, @required this.colorScheme, @required this.username, @required this.imageUrl, @required this.verified});
}

class CurrentPage {
  void load({@required String displayname, @required String bio, @required Color colorScheme, @required String imageUrl, @required String username, @required bool verified}) {
    CurrentPage.bio = bio;
    CurrentPage.colorScheme = colorScheme;
    CurrentPage.displayname = displayname;
    CurrentPage.imageUrl = imageUrl;
    CurrentPage.username = username;
    CurrentPage.verified = verified;
  }

  static String bio;
  static Color colorScheme;
  static String displayname;
  static String imageUrl;
  static String username;
  static bool verified;
}
