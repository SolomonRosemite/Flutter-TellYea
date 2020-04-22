import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:TellYea/backend/credentials.dart';

import 'dart:async';

class Backend {
  static bool initialized = false;
  static bool userLoaded = false;
  static bool userIsOffline = false;

  static void initialize() async {
    Backendless.setUrl('https://api.backendless.com');
    Backendless.initApp(Credentials.applicationId, Credentials.androidApiKey, Credentials.iosApiKey);
    initialized = true;
  }

  static Future<bool> hasInternet() async {
    return await DataConnectionChecker().hasConnection;
  }

  static Future<bool> registerUser(String username, String email, String password) async {
    try {
      BackendlessUser user = new BackendlessUser();
      user.email = email;
      user.password = password;
      await Backendless.userService.register(user);
      save('TellYeaUsers', {
        'colorScheme': 'primaryColor',
        'displayname': username,
        'username': username
      });
      return true;
    } catch (e) {
      save("Reports", {
        "context": e.toString()
      });
      return false;
    }
  }

  static Future<bool> loginUser(String email, String password) async {
    try {
      await Backendless.userService.login(email, password);
      userLoaded = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Map<dynamic, dynamic>>> readTable(String tableName) async {
    if (initialized == false) initialize();

    int count = await Backendless.data.of(tableName).getObjectCount();
    DataQueryBuilder queryBuilder = DataQueryBuilder()..pageSize = count;

    return await Backendless.data.of(tableName).find(queryBuilder);
  }

  static void update(String tableName, Map<String, dynamic> map, String condition) {
    if (initialized == false) initialize();

    Backendless.data.of(tableName).update(condition, map);
  }

  static void save(String tableName, Map<String, dynamic> map) {
    if (initialized == false) initialize();

    Backendless.data.of(tableName).save(map);
  }

  static EventHandler<Map<dynamic, dynamic>> initListener(String tableName) {
    if (initialized == false) initialize();

    return Backendless.data.of(tableName).rt();
  }
}
