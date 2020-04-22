import 'package:flutter/material.dart';

class User {
  final String displayname;
  final String colorScheme;
  final String imageUrl;
  final String username;
  final bool verified;

  User({@required this.displayname, @required this.colorScheme, @required this.username, @required this.imageUrl, @required this.verified});
}
