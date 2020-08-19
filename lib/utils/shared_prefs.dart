
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  static final login = 'login';
  static final userMap = "userMap";
  static SharedPreferences _sharedPreferences;

  static Future<void> setInstance() async {
    if (null != _sharedPreferences) return;
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setLogin(String value) => _sharedPreferences.setString(login, value);
  static String getLogin() => _sharedPreferences.getString(login) ?? 'null';


  static Future<bool> setUserMap(String value) => _sharedPreferences.setString(userMap, value);
  static Map<String,dynamic> getUserMap() => json.decode(_sharedPreferences.getString(userMap)) ?? {};
  // 'companyId','employeeId','name','uid','division',
}
