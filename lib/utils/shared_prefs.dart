
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  static final login = 'login';

  static SharedPreferences _sharedPreferences;

  static Future<void> setInstance() async {
    if (null != _sharedPreferences) return;
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setLogin(String value) => _sharedPreferences.setString(login, value);
  static String getLogin() => _sharedPreferences.getString(login) ?? 'null';


}
