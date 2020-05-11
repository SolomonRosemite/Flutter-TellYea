import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:TellYea/backend/credentials.dart';
import 'package:TellYea/model/ThisUser.dart';

import 'dart:async';
import 'dart:io';

class Backend {
  static bool initialized = false;
  static bool userLoaded = false;
  static bool userIsOffline = false;

  static List<Map> tellYeaUsers;

  static void initialize() {
    Backendless.setUrl('https://api.backendless.com');
    Backendless.initApp(Credentials.applicationId, Credentials.androidApiKey, Credentials.iosApiKey);
    initialized = true;
  }

  static Future<bool> hasInternet() async {
    return await DataConnectionChecker().hasConnection;
  }

  static Future<bool> registerUser(String displayName, String username, String email, String password) async {
    if (initialized == false) initialize();

    try {
      BackendlessUser user = new BackendlessUser();
      user.email = email;
      user.password = password;
      await Backendless.userService.register(user);
      await Backend.loginUser(email, password);
      var thisUser = await Backendless.data.of('TellYeaUsers').save({
        'bio': 'Hey, I\'m using TellYea',
        'colorScheme': 'primaryColor',
        'email': email,
        'displayname': displayName,
        'username': username
      });
      ThisUser.loadData(
        ownerId: thisUser['ownerId'],
        colorScheme: 'primaryColor',
        created: DateTime.now(),
        bio: 'Hey, I\'m using TellYea',
        displayname: displayName,
        imageUrl: 'https://backendlessappcontent.com/${Credentials.applicationId}/${Credentials.restAPIKey}/files/images/profile_images/default.png',
        username: username,
        verified: false,
      );
      return true;
    } catch (e) {
      save("Reports", {
        "context": e.toString()
      });
      return false;
    }
  }

  static Future<bool> loginUser(String email, String password) async {
    if (initialized == false) initialize();

    try {
      await Backendless.userService.login(email, password);
      try {
        DataQueryBuilder queryBuilder = DataQueryBuilder()..whereClause = 'email = \'$email\'';
        Map user = await (Backendless.data.of('TellYeaUsers').find(queryBuilder)).then((onValue) => onValue[0]);
        ThisUser.loadData(ownerId: user['ownerId'], colorScheme: user['colorScheme'], created: user['created'], bio: user['bio'], displayname: user['displayname'], imageUrl: user['imageUrl'], username: user['username'], verified: user['verified']);
      } catch (e) {
        save("Reports", {
          "context": e.toString()
        });
        userLoaded = true;
      }
      userLoaded = true;
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<List<Map<dynamic, dynamic>>> readTable(String tableName, {String whereClause}) async {
    if (initialized == false) initialize();

    int count = await Backendless.data.of(tableName).getObjectCount();
    DataQueryBuilder queryBuilder = DataQueryBuilder()..pageSize = count;

    if (whereClause == null) {
      queryBuilder.whereClause = whereClause;
    }

    return await Backendless.data.of(tableName).find(queryBuilder);
  }

  static void update(String tableName, Map<String, dynamic> map, String condition) {
    if (initialized == false) initialize();

    Backendless.data.of(tableName).update(condition, map);
  }

  static Future<void> updateAsync(String tableName, Map<String, dynamic> map, String condition) async {
    if (initialized == false) initialize();

    await Backendless.data.of(tableName).update(condition, map);
  }

  static void save(String tableName, Map<String, dynamic> map) {
    if (initialized == false) initialize();

    Backendless.data.of(tableName).save(map);
  }

  static Future<void> saveAsync(String tableName, Map<String, dynamic> map) async {
    if (initialized == false) initialize();

    await Backendless.data.of(tableName).save(map);
  }

  static void remove(String tableName, Map map) {
    if (initialized == false) initialize();

    Backendless.data.of(tableName).remove(entity: map);
  }

  static EventHandler<Map<dynamic, dynamic>> initListener(String tableName) {
    if (initialized == false) initialize();

    return Backendless.data.of(tableName).rt();
  }

  static Future<String> uploadImage(File image) async {
    if (initialized == false) initialize();

    return await Backendless.files.upload(image, '/images/user_images/${ThisUser.ownerId}');
  }
}
