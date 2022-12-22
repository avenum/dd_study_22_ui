import 'package:flutter/foundation.dart';

extension StringExtension on String {
  void console() {
    if (kDebugMode) {
      print(this);
    }
  }
}
