import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';

class AuthService {
  Future auth(String? login, String? password) async {
    if (login != null && password != null) {
      SharedPrefs.setStoredAuth(true);
    }
  }

  Future<bool> checkAuth() async {
    return await SharedPrefs.getStoredAuth();
  }

  Future logout() async {
    await SharedPrefs.setStoredAuth(null);
  }
}
