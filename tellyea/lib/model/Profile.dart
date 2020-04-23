import 'package:flutter/material.dart';

class Profile {
  final String displayname;
  final String bio;
  final Color colorScheme;
  final String imageUrl;
  final String username;
  final bool verified;

  Profile({@required this.displayname, @required this.bio, @required this.colorScheme, @required this.username, @required this.imageUrl, @required this.verified});
}
