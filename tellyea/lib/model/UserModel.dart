import 'package:flutter/material.dart';
import 'Profile.dart';

class UserModel extends Profile {
  UserModel({
    String bio,
    Color colorScheme,
    DateTime created,
    String displayname,
    String imageUrl,
    bool verified,
    String username,
    String ownerId,
    List<String> following,
  }) : super.fromProfile(
          bio,
          colorScheme,
          created,
          displayname,
          imageUrl,
          verified,
          username,
        ) {
    this.following = following;
  }

  List<String> following;
  String ownerId;
}
