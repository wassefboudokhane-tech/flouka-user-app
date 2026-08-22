import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'app_color.dart';

/// Clamps sizer-scaled fonts so SE stays readable and Pro Max does not inflate.
double _fs(double baseSp, {double min = 11, double max = 22}) {
  final scaled = baseSp.sp;
  return scaled.clamp(min, max).toDouble();
}

abstract class TextStyleClass {
  static TextStyle headStyle({Color? color}) {
    return GoogleFonts.rubik(
      color: color ?? AppColor.inkColor,
      fontSize: _fs(20, min: 18, max: 22),
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle semiHeadStyle({Color? color}) {
    return GoogleFonts.rubik(
      color: color ?? AppColor.inkColor,
      fontSize: _fs(18, min: 16, max: 20),
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle normalStyle({Color? color, double? fontSize}) {
    return GoogleFonts.rubik(
      color: color ?? AppColor.inkColor,
      fontSize: fontSize != null
          ? fontSize.clamp(11, 20).toDouble()
          : _fs(15, min: 14, max: 17),
    );
  }

  static TextStyle smallStyle({Color? color}) {
    return GoogleFonts.rubik(
      color: color ?? AppColor.inkColor,
      fontSize: _fs(13, min: 12, max: 15),
    );
  }

  static TextStyle buttonStyle({Color? color}) {
    return GoogleFonts.rubik(
      color: color ?? AppColor.deepColor,
      fontSize: _fs(15, min: 13, max: 16),
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle textFieldStyle({Color? color}) {
    return GoogleFonts.rubik(
      color: color ?? AppColor.inkColor,
      fontSize: _fs(14, min: 13, max: 15),
    );
  }

  static TextStyle captionStyle({Color? color}) {
    return GoogleFonts.rubik(
      color: color ?? AppColor.mutedColor,
      fontSize: _fs(12, min: 11, max: 13),
    );
  }

  /// Product card vendor line — web 11px.
  static TextStyle vendorStyle({Color? color}) {
    return GoogleFonts.rubik(
      color: color ?? AppColor.primaryColor,
      fontSize: _fs(11, min: 10, max: 12),
      fontWeight: FontWeight.w600,
    );
  }

  /// Product card title — web 13px.
  static TextStyle productTitleStyle({Color? color}) {
    return GoogleFonts.rubik(
      color: color ?? AppColor.inkColor,
      fontSize: _fs(13, min: 12, max: 14),
      fontWeight: FontWeight.w500,
      height: 1.25,
    );
  }

  /// Product price — web 19px w800 deep.
  static TextStyle priceStyle({Color? color}) {
    final fontSize = _fs(19, min: 17, max: 21);
    return GoogleFonts.rubik(
      color: color ?? AppColor.deepColor,
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      letterSpacing: fontSize * -0.02,
    );
  }

  /// Rail section title — hi-fi 18px.
  static TextStyle railTitleStyle({Color? color}) {
    return GoogleFonts.rubik(
      color: color ?? AppColor.deepColor,
      fontSize: _fs(18, min: 16, max: 20),
      fontWeight: FontWeight.w800,
      letterSpacing: -0.01,
    );
  }

  /// Screen title — hi-fi 28px (Panier, Explorer, …).
  static TextStyle screenTitleStyle({Color? color}) {
    return GoogleFonts.rubik(
      color: color ?? AppColor.deepColor,
      fontSize: _fs(28, min: 24, max: 30),
      fontWeight: FontWeight.w800,
      letterSpacing: -0.02,
      height: 1,
    );
  }

  /// Cart line item price — hi-fi 17px w800.
  static TextStyle cartLinePriceStyle({Color? color}) {
    return GoogleFonts.rubik(
      color: color ?? AppColor.deepColor,
      fontSize: _fs(17, min: 15, max: 19),
      fontWeight: FontWeight.w800,
    );
  }

  /// PDP hero price — hi-fi 34px w800.
  static TextStyle pdpPriceStyle({Color? color}) {
    return GoogleFonts.rubik(
      color: color ?? AppColor.deepColor,
      fontSize: _fs(34, min: 28, max: 36),
      fontWeight: FontWeight.w800,
      letterSpacing: -0.03,
      height: 1,
    );
  }

  /// Cart summary total — refonte 26px w800.
  static TextStyle cartTotalStyle({Color? color}) {
    return GoogleFonts.rubik(
      color: color ?? AppColor.deepColor,
      fontSize: _fs(26, min: 22, max: 28),
      fontWeight: FontWeight.w800,
    );
  }

  /// Helper for one-off sizes that still need clamping.
  static double clampSp(double baseSp, {double min = 10, double max = 20}) {
    return math.min(max, math.max(min, baseSp.sp));
  }
}
