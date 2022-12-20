import 'package:dd_study_22_ui/domain/enums/tab_item.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_home/post_detail.dart';
import 'package:flutter/material.dart';

class TabNavigatorRoutes {
  static const String root = '/app/';
  static const String postDetails = "/app/postDetails";
}

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItemEnum tabItem;
  const TabNavigator({
    Key? key,
    required this.navigatorKey,
    required this.tabItem,
  }) : super(key: key);

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context,
          {Object? arg}) =>
      {
        TabNavigatorRoutes.root: (context) =>
            TabEnums.tabRoots[tabItem] ??
            SafeArea(
              child: Text(tabItem.name),
            ),
        TabNavigatorRoutes.postDetails: (context) => PostDetail.create(arg),
      };

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (settings) {
        var rb = _routeBuilders(context, arg: settings.arguments);
        if (rb.containsKey(settings.name)) {
          return MaterialPageRoute(
              builder: (context) => rb[settings.name]!(context));
        }

        return null;
      },
    );
  }
}
