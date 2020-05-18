
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  static final login = 'login';
  static final user = "user";
  static SharedPreferences _sharedPreferences;

  static Future<void> setInstance() async {
    if (null != _sharedPreferences) return;
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setLogin(String value) => _sharedPreferences.setString(login, value);
  static String getLogin() => _sharedPreferences.getString(login) ?? 'null';

  static Future<bool> setUser(List<String> value) => _sharedPreferences.setStringList(user, value);
  static List<String> getUser() => _sharedPreferences.getStringList(user) ?? ["","","","","1"];

}
