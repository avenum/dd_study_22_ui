import 'dart:io';

import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/widgets/common/cam_widget.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/user.dart';
import '../../../../internal/config/shared_prefs.dart';

class ProfileViewModel extends ChangeNotifier {
  final _api = RepositoryModule.apiRepository();
  final BuildContext context;
  ProfileViewModel({required this.context}) {
    asyncInit();
    var appmodel = context.read<AppViewModel>();
    appmodel.addListener(() {
      avatar = appmodel.avatar;
    });
  }
  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  Future asyncInit() async {
    user = await SharedPrefs.getStoredUser();
  }

  String? _imagePath;
  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? val) {
    _avatar = val;
    notifyListeners();
  }

  Future changePhoto() async {
    var appmodel = context.read<AppViewModel>();
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (newContext) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black),
        body: SafeArea(
          child: CamWidget(
            onFile: (file) {
              _imagePath = file.path;
              Navigator.of(newContext).pop();
            },
          ),
        ),
      ),
    ));
    if (_imagePath != null) {
      avatar = null;
      var t = await _api.uploadTemp(files: [File(_imagePath!)]);
      if (t.isNotEmpty) {
        await _api.addAvatarToUser(t.first);

        var img =
            await NetworkAssetBundle(Uri.parse("$baseUrl${user!.avatarLink}"))
                .load("$baseUrl${user!.avatarLink}?v=1");
        var avImage = Image.memory(img.buffer.asUint8List());

        appmodel.avatar = avImage;
      }
    }
  }
}
