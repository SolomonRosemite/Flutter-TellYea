import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:TellYea/backend/credentials.dart';

import 'dart:async';
import 'dart:io';

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
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  static Future<void> loginUser(String username, String password) async {
    await Backendless.userService.login(username, password);
    userLoaded = true;
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
