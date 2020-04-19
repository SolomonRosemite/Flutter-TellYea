import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:tellyea/credentials.dart';

import 'dart:async';

class Backend {
  static void initialize() {
    Backendless.setUrl("https://api.backendless.com");
    Backendless.initApp(Credentials.applicationId, Credentials.androidApiKey, Credentials.iosApiKey);
  }

  static Future<List<Map<dynamic, dynamic>>> readTable(String tableName) async {
    int count = await Backendless.data.of("Messages").getObjectCount();
    DataQueryBuilder queryBuilder = DataQueryBuilder()..pageSize = count;

    return await Backendless.data.of(tableName).find(queryBuilder);
  }

  static void update(String tableName, Map<String, dynamic> map, String condition) {
    Backendless.data.of(tableName).update(condition, map);
  }

  static void save(String tableName, Map<String, dynamic> map) {
    Backendless.data.of(tableName).save(map);
  }

  static EventHandler<Map<dynamic, dynamic>> initListener(String tableName) {
    return Backendless.data.of(tableName).rt();
  }
}
