class ThisUser {
  static String bio;
  static String colorScheme;
  static String displayname;
  static String imageUrl;
  static String username;
  static bool verified;

  static void loadData({String displayname, String bio, String colorScheme, String username, String imageUrl, bool verified}) {
    ThisUser.bio = bio;
    ThisUser.colorScheme = colorScheme;
    ThisUser.displayname = displayname;
    ThisUser.imageUrl = imageUrl;
    ThisUser.username = username;
    ThisUser.verified = verified;
  }
}
