import 'package:flutter/material.dart';

class YeetModel {
  YeetModel({this.id, @required this.displayname, @required this.bio, @required this.colorScheme, @required this.username, @required this.message, @required this.imageUrl, @required this.dateTime, @required this.objectId, @required this.verified});
  Color colorScheme;
  DateTime dateTime;
  String displayname;
  String bio;
  String id;
  String imageUrl;
  String message;
  String objectId;
  String username;
  bool verified;
}
