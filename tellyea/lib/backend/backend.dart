import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:TellYea/backend/credentials.dart';
import 'package:TellYea/backend/ThisUser.dart';

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

  static Future<bool> hasInternet() async => await DataConnectionChecker().hasConnection;

  static Future<bool> registerUser(String displayName, String username, String email, String password) async {
    if (initialized == false) initialize();

    try {
      BackendlessUser user = new BackendlessUser();
      user.email = email;
      user.password = password;
      await Backendless.userService.register(user);
      save('TellYeaUsers', {
        'colorScheme': 'primaryColor',
        'email': email,
        'displayname': displayName,
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
    if (initialized == false) initialize();

    try {
      await Backendless.userService.login(email, password);

      // Load User
      try {
        DataQueryBuilder queryBuilder = DataQueryBuilder()..whereClause = 'email = \'$email\'';
        Map user = await (Backendless.data.of('TellYeaUsers').find(queryBuilder)).then((onValue) => onValue[0]);
        ThisUser.loadData(colorScheme: user['colorScheme'], displayname: user['displayname'], imageUrl: user['imageUrl'], username: user['username'], verified: user['verified']);
      } catch (e) {
        // TODO: Add a error Report here.
      }

      userLoaded = true;
      return true;
    } catch (_) {
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
