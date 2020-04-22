class ThisUser {
  static String displayname;
  static String colorScheme;
  static String imageUrl;
  static String username;
  static bool verified;

  static void loadData({String displayname, String colorScheme, String username, String imageUrl, bool verified}) {
    ThisUser.colorScheme = colorScheme;
    ThisUser.displayname = displayname;
    ThisUser.imageUrl = imageUrl;
    ThisUser.username = username;
    ThisUser.verified = verified;
  }
}
