import 'dart:convert';

import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _userKey = "_kUser";

  static Future<User?> getStoredUser() async {
    var sp = await SharedPreferences.getInstance();
    var json = sp.getString(_userKey);
    return (json == "" || json == null)
        ? null
        : User.fromJson(jsonDecode(json));
  }

  static Future setStoredUser(User? user) async {
    var sp = await SharedPreferences.getInstance();
    if (user == null) {
      sp.remove(_userKey);
    } else {
      await sp.setString(
        _userKey,
        jsonEncode(user.toJson()),
      );
    }
  }
}
