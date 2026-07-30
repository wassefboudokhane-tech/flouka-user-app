import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_styles.dart';

ThemeData defaultTheme = ThemeData(
  useMaterial3: false,
  primaryColor: AppColor.primaryColor,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.transparent,
  ),
  unselectedWidgetColor: Colors.white,
  scaffoldBackgroundColor: AppColor.canvasColor,
  checkboxTheme: checkboxThemeData,
  dividerColor: Colors.transparent,
  radioTheme: radioThemeData,
  appBarTheme: appBarTheme,
  textTheme: GoogleFonts.rubikTextTheme(),
  fontFamily: GoogleFonts.rubik().fontFamily,
  splashColor: Colors.transparent,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColor.limeColor,
      foregroundColor: AppColor.deepColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.btn),
      ),
    ),
  ),
);

AppBarTheme appBarTheme = AppBarTheme(
  backgroundColor: AppColor.deepColor,
  toolbarHeight: 56,
  centerTitle: true,
  foregroundColor: Colors.white,
  elevation: 0,
  iconTheme: const IconThemeData(color: Colors.white),
  systemOverlayStyle: lightBarColor(),
  titleTextStyle: TextStyleClass.semiHeadStyle(color: Colors.white).copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 16,
  ),
);

EdgeInsets globalPadding = AppSpacing.pagePaddingWith(top: 8, bottom: 8);

CheckboxThemeData checkboxThemeData = CheckboxThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
  side: BorderSide(width: 1.5, color: AppColor.borderColor),
  fillColor: WidgetStateProperty.all(AppColor.limeColor),
  checkColor: WidgetStateProperty.all(AppColor.deepColor),
  overlayColor: WidgetStateProperty.all(
    AppColor.primaryColor.withValues(alpha: 0.1),
  ),
  visualDensity: VisualDensity.compact,
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
);

RadioThemeData radioThemeData = RadioThemeData(
  fillColor: WidgetStateProperty.all(AppColor.primaryColor),
);

TabBarTheme tabBarTheme = TabBarTheme(
  labelColor: AppColor.deepColor,
  indicatorSize: TabBarIndicatorSize.label,
  unselectedLabelColor: AppColor.mutedColor,
);

bool get _isAndroid =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

SystemUiOverlayStyle barColor() {
  if (_isAndroid) {
    return const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
    );
  }
  return SystemUiOverlayStyle.dark;
}

SystemUiOverlayStyle lightBarColor() {
  if (_isAndroid) {
    return const SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    );
  }
  return SystemUiOverlayStyle.light;
}
