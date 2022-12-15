import 'dart:io';

import 'package:dd_study_22_ui/data/clients/api_client.dart';
import 'package:dd_study_22_ui/data/clients/auth_client.dart';
import 'package:dd_study_22_ui/domain/models/post_model.dart';
import 'package:dd_study_22_ui/domain/models/refresh_token_request.dart';
import 'package:dd_study_22_ui/domain/models/token_request.dart';
import 'package:dd_study_22_ui/domain/models/token_response.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/domain/repository/api_repository.dart';

import '../../domain/models/attach_meta.dart';

class ApiDataRepository extends ApiRepository {
  final AuthClient _auth;
  final ApiClient _api;
  ApiDataRepository(this._auth, this._api);

  @override
  Future<TokenResponse?> getToken({
    required String login,
    required String password,
  }) async {
    return await _auth.getToken(TokenRequest(
      login: login,
      pass: password,
    ));
  }

  @override
  Future<TokenResponse?> refreshToken(String refreshToken) async =>
      await _auth.refreshToken(RefreshTokenRequest(
        refreshToken: refreshToken,
      ));

  @override
  Future<User?> getUser() => _api.getUser();

  @override
  Future<List<PostModel>> getPosts(int skip, int take) =>
      _api.getPosts(skip, take);

  @override
  Future<List<AttachMeta>> uploadTemp({required List<File> files}) =>
      _api.uploadTemp(files: files);

  @override
  Future addAvatarToUser(AttachMeta model) => _api.addAvatarToUser(model);
}
