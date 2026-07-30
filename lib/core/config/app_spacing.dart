import 'package:flutter/material.dart';

/// Spacing tokens aligned with flouka-web merch (mobile gutters / gaps).
abstract class AppSpacing {
  /// Page horizontal gutter — web `px-3` ≈ 12.
  static const double pageGutter = 12;

  /// Section vertical gap — web `gap-5` / `gap-6`.
  static const double section = 20;
  static const double sectionLg = 24;

  /// Gap between product cards in a grid/rail.
  static const double cardGap = 12;

  /// Inner padding of product / merch cards.
  static const double cardPadding = 10;

  /// Search pill / primary CTA touch height.
  static const double searchHeight = 46;
  static const double ctaHeight = 48;

  /// Accent bar on product rails.
  static const double railAccentW = 4;
  static const double railAccentH = 22;

  static EdgeInsets get pagePadding =>
      const EdgeInsets.symmetric(horizontal: pageGutter);

  static EdgeInsets pagePaddingWith({
    double top = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.fromLTRB(pageGutter, top, pageGutter, bottom);
}
