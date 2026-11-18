import 'package:flutter/material.dart';


/// Shadow tokens. The épuré style draws with hairlines, so they are empty.
abstract class AppShadow {
  static List<BoxShadow> get dock => const [];

  static List<BoxShadow> get cartBubble => const [];
}
