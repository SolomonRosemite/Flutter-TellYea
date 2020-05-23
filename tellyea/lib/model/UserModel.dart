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
    String following,
  }) : super.fromProfile(
          bio,
          colorScheme,
          created,
          displayname,
          imageUrl,
          verified,
          username,
        ) {
    this.ownerId = ownerId;
    this.following = following;
  }

  String following;
  String ownerId;
}
