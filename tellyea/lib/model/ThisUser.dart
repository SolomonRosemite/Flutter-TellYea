import 'package:flutter/cupertino.dart';

class ThisUser {
  static String bio;
  static DateTime created;
  static String colorScheme;
  static String displayname;
  static String following;
  static String imageUrl;
  static String ownerId;
  static String username;
  static bool verified;

  static void loadData({
    @required String displayname,
    @required DateTime created,
    @required String bio,
    @required String colorScheme,
    @required String following,
    @required String ownerId,
    @required String imageUrl,
    @required bool verified,
    @required String username,
  }) {
    ThisUser.bio = bio;
    ThisUser.created = created;
    ThisUser.colorScheme = colorScheme;
    ThisUser.displayname = displayname;
    ThisUser.following = following;
    ThisUser.imageUrl = imageUrl;
    ThisUser.username = username;
    ThisUser.verified = verified;
    ThisUser.ownerId = ownerId;
  }
}
