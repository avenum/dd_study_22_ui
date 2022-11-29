import 'package:dd_study_22_ui/data/clients/auth_client.dart';
import 'package:dio/dio.dart';

String baseUrl = "http://106pc0202.digdes.com:5050/";

class ApiModule {
  static AuthClient? _authClient;

  static AuthClient auth() =>
      _authClient ??
      AuthClient(
        Dio(),
        baseUrl: baseUrl,
      );
}
