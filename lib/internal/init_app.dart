import 'package:dd_study_22_ui/domain/enums/tab_item.dart';
import 'package:dd_study_22_ui/internal/utils.dart';
import 'package:dd_study_22_ui/ui/navigation/tab_navigator.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/services/database.dart';
import '../firebase_options.dart';
import '../ui/navigation/app_navigator.dart';

void showModal(
  String title,
  String content,
) {
  var ctx = AppNavigator.key.currentContext;
  if (ctx != null) {
    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("got it"))
          ],
        );
      },
    );
  }
}

void catchMessage(RemoteMessage message) {
  "Got a message whilst in the foreground!".console();
  'Message data: ${message.data}'.console();
  if (message.notification != null) {
    showModal(message.notification!.title!, message.notification!.body!);
    // var post = '81b4293b-e874-4f2d-a6e0-c0135006c75e';
    // var ctx = AppNavigator.navigationKeys[TabItemEnum.home]?.currentContext;
    // if (ctx != null) {
    //   var appviewModel = ctx.read<AppViewModel>();
    //   Navigator.of(ctx)
    //       .pushNamed(TabNavigatorRoutes.postDetails, arguments: post);
    //   appviewModel.selectTab(TabItemEnum.home);
    // }
  }
}

Future initFareBase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);
  FirebaseMessaging.onMessage.listen(catchMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(catchMessage);
  try {
    ((await messaging.getToken()) ?? "no token").console();
  } catch (e) {
    e.toString().console();
  }
}

Future initApp() async {
  await initFareBase();
  await DB.instance.init();
}
