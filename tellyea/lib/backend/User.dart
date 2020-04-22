import 'package:flutter/material.dart';

class ThisUser {
  final String displayname;
  final String colorScheme;
  final String imageUrl;
  final String username;
  final bool verified;

  ThisUser({@required this.displayname, @required this.colorScheme, @required this.username, @required this.imageUrl, @required this.verified});
}
