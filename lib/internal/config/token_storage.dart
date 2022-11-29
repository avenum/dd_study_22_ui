import 'package:dd_study_22_ui/domain/models/token_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _accessTokenKey = "access_token";
  static const _refreshTokenKey = "refresh_token";

  static Future<TokenResponse?> getStoredToken() async {
    const storage = FlutterSecureStorage();
    final at = await storage.read(key: _accessTokenKey);
    final rt = await storage.read(key: _refreshTokenKey);
    return at != null && rt != null
        ? TokenResponse(accessToken: at, refreshToken: rt)
        : null;
  }

  static Future setStoredToken(TokenResponse? token) async {
    const storage = FlutterSecureStorage();
    storage.delete(key: _accessTokenKey);
    storage.delete(key: _refreshTokenKey);
    if (token != null) {
      await storage.write(key: _accessTokenKey, value: token.accessToken);
      await storage.write(key: _refreshTokenKey, value: token.refreshToken);
    }
  }

  static Future<String?> getAccessToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: _accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: _refreshTokenKey);
  }
}
