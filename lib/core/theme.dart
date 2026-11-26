import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flouka/core/tokens.dart';

class FkTheme {
  const FkTheme(this.rtl);
  final bool rtl;

  String get sans => rtl ? FkTokens.sansAr : FkTokens.sans;

  ThemeData get data {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: FkTokens.white,
      colorScheme: const ColorScheme.light(
        primary: FkTokens.ink,
        onPrimary: FkTokens.white,
        surface: FkTokens.white,
        onSurface: FkTokens.ink,
        error: FkTokens.err,
      ),
      fontFamily: sans,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: FkTokens.white,
        foregroundColor: FkTokens.ink,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      dividerColor: FkTokens.line,
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: sans,
        bodyColor: FkTokens.ink,
        displayColor: FkTokens.ink,
      ),
    );
  }

  TextStyle get wordmark => const TextStyle(
        fontFamily: FkTokens.serif,
        fontSize: 28,
        height: 1.05,
        color: FkTokens.ink,
        fontWeight: FontWeight.w400,
      );

  TextStyle get display => TextStyle(
        fontFamily: FkTokens.serif,
        fontSize: rtl ? 32 : 34,
        height: 1.1,
        color: FkTokens.ink,
        fontWeight: FontWeight.w400,
      );

  TextStyle italic(double size, {Color color = FkTokens.ink}) => TextStyle(
        fontFamily: FkTokens.italic,
        fontStyle: FontStyle.italic,
        fontSize: size,
        height: 1.2,
        color: color,
        fontWeight: FontWeight.w400,
      );

  TextStyle get productTitle => TextStyle(
        fontFamily: sans,
        fontSize: 13,
        height: 1.3,
        fontWeight: FontWeight.w700,
        color: FkTokens.ink,
      );

  TextStyle cap({Color color = FkTokens.ink, double size = 11, FontWeight w = FontWeight.w500}) =>
      TextStyle(
        fontFamily: sans,
        fontSize: size,
        letterSpacing: rtl ? 0 : 1.4,
        fontWeight: w,
        color: color,
        height: 1.2,
      );
}
