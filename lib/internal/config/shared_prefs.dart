import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _authKey = "_kAuthKey";

  static Future<bool> getStoredAuth() async {
    var sp = await SharedPreferences.getInstance();
    return sp.getBool(_authKey) ?? false;
  }

  static Future setStoredAuth(bool? auth) async {
    var sp = await SharedPreferences.getInstance();
    if (auth == null) {
      sp.remove(_authKey);
    } else {
      sp.setBool(_authKey, auth);
    }
  }
}
