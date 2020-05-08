import 'package:flutter/material.dart';

class YeetModel {
  YeetModel({this.id, @required this.displayname, @required this.username, @required this.message, @required this.imageUrl, @required this.dateTime, @required this.ownerId, @required this.verified});
  DateTime dateTime;
  String displayname;
  String id;
  String imageUrl;
  String message;
  String ownerId;
  String username;
  bool verified;
}
