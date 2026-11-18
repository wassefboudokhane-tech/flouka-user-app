import 'package:flutter/material.dart';

/// Brand tokens aligned with flouka-web (`globals.css` / Tailwind `flouka.*`).
/// Épuré: white, black ink, grey hairlines; deep purple only for the main action.
/// `limeColor` is kept as a name for the light grey fill that replaced the lime.
abstract class AppColor {
  static Color primaryColor = const Color(0xff35035C);
  static Color deepColor = const Color(0xff35035C);
  static Color secondaryColor = const Color(0xff35035C);
  static Color limeColor = const Color(0xffF1F1F4);
  static Color backgroundColor = const Color(0xffFFFFFF);
  static Color canvasColor = const Color(0xffFFFFFF);
  static Color softColor = const Color(0xffF5F5F7);
  static Color tertiaryColor = const Color(0xffAEB1C1);
  static Color mutedColor = const Color(0xff6B6B6B);
  static Color inkColor = const Color(0xff1A1A1A);
  /// Sale / urgency accent (tasteful — not full-app red)
  static Color DealColor = const Color(0xffDF0033);
  static Color redSoft = const Color(0xffFFE8EE);
  static Color alertColor = const Color(0xffC41E3A);
  /// Card / input border (web `#e6ddf2`)
  static Color borderColor = const Color(0xffEAEAEE);
  static Color navColor = const Color(0xff4A4A4A);
}
