import 'package:flutter/material.dart';

class Profile {
  Profile();
  Profile.fromProfile(
    this.bio,
    this.colorScheme,
    this.created,
    this.displayname,
    this.imageUrl,
    this.verified,
    this.username,
  );
  String bio;
  DateTime created;
  String displayname;
  Color colorScheme;
  String imageUrl;
  String username;
  String ownerId;
  bool verified;
}
