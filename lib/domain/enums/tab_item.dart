import 'package:dd_study_22_ui/ui/widgets/tab_profile/profile/profile_widget.dart';
import 'package:flutter/material.dart';

import '../../ui/widgets/tab_home/home.dart';

enum TabItemEnum { home, search, newPost, favorites, profile }

class TabEnums {
  static const TabItemEnum defTab = TabItemEnum.home;

  static Map<TabItemEnum, IconData> tabIcon = {
    TabItemEnum.home: Icons.home_outlined,
    TabItemEnum.search: Icons.search_outlined,
    TabItemEnum.newPost: Icons.add_photo_alternate_rounded,
    TabItemEnum.favorites: Icons.favorite_outline,
    TabItemEnum.profile: Icons.person_outline,
  };

  static Map<TabItemEnum, Widget> tabRoots = {
    TabItemEnum.home: Home.create(),
    TabItemEnum.profile: ProfileWidget.create(),
  };
}
