import 'package:flutter/material.dart';

/// Brand tokens aligned with flouka-web (`globals.css` / Tailwind `flouka.*`).
abstract class AppColor {
  static Color primaryColor = const Color(0xffAD46FF);
  static Color deepColor = const Color(0xff35035C);
  static Color secondaryColor = const Color(0xffAD46FF);
  static Color limeColor = const Color(0xffD7FC70);
  static Color backgroundColor = const Color(0xffFFFFFF);
  static Color canvasColor = const Color(0xffF0EEE9);
  static Color softColor = const Color(0xffF6F3FA);
  static Color tertiaryColor = const Color(0xffAEB1C1);
  static Color mutedColor = const Color(0xff8B829C);
  static Color inkColor = const Color(0xff1E1E1E);
  /// Sale / urgency accent (tasteful — not full-app red)
  static Color DealColor = const Color(0xffDF0033);
  static Color redSoft = const Color(0xffFFE8EE);
  static Color alertColor = const Color(0xffC41E3A);
  /// Card / input border (web `#e6ddf2`)
  static Color borderColor = const Color(0xffE6DDF2);
  static Color navColor = const Color(0xff4A4458);
}
