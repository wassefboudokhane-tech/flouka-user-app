import 'package:flutter/material.dart';

import 'app_color.dart';

/// Reusable shadow tokens aligned with flouka-web merch surfaces.
abstract class AppShadow {
  static List<BoxShadow> get dock => [
        BoxShadow(
          color: AppColor.deepColor.withValues(alpha: 0.13),
          blurRadius: 30,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> get cartBubble => [
        BoxShadow(
          color: AppColor.deepColor.withValues(alpha: 0.35),
          blurRadius: 26,
          offset: const Offset(0, 10),
        ),
      ];
}
