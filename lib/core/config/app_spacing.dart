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
  static const double searchHeight = 48;
  static const double ctaHeight = 48;
  static const double cartCtaHeight = 54;
  static const double checkoutCtaHeight = 56;

  /// Accent bar on product rails.
  static const double railAccentW = 4;
  static const double railAccentH = 20;

  /// Hi-fi product card (158×122 image + meta).
  static const double productCardWidth = 158;
  static const double productCardImageHeight = 122;

  /// Floating cart bubble height.
  static const double cartBubbleHeight = 46;

  /// Bottom nav active pill (hi-fi).
  static const double navActivePillW = 44;
  static const double navActivePillH = 30;
  static const double navActivePillRadius = 11;

  /// Explorer category rail.
  static const double exploreCategoryRailWidth = 92;
  static const double exploreCategoryTileHeight = 52;
  static const double exploreSubcategoryTileHeight = 106;

  static EdgeInsets get pagePadding =>
      const EdgeInsets.symmetric(horizontal: pageGutter);

  static EdgeInsets pagePaddingWith({
    double top = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.fromLTRB(pageGutter, top, pageGutter, bottom);

  /// Floating nav dock — horizontal margin (design 16px).
  static const double dockMarginH = 16;

  /// Floating nav dock — bottom margin above safe area.
  static const double dockMarginBottom = 14;

  /// Inner height of the floating dock pill.
  static const double dockBarHeight = 66;

  /// Extra gap between dock top and cart bubble.
  static const double cartBubbleGap = 8;

  /// Bottom padding for tab bodies so content clears dock + bubble.
  static const double navShellBottomInset =
      dockBarHeight + dockMarginBottom + cartBubbleGap;

  /// Cart line product thumbnail.
  static const double cartLineImage = 62;

  /// Free-delivery progress bar height.
  static const double freeDeliveryGaugeHeight = 7;

  /// Vendor story avatar diameter on home.
  static const double storyCircleSize = 58;

  /// Circular add-to-cart control on product cards.
  static const double productAddBtnSize = 32;

  /// Cart bubble sits above the dock.
  static const double cartBubbleBottomOffset =
      navShellBottomInset + cartBubbleGap;

  /// PDP hero gallery height (hi-fi).
  static const double pdpHeroHeight = 340;

  /// PDP sticky buy bar control height.
  static const double pdpBuyBarHeight = 52;

  /// Profile initials avatar on identity card.
  static const double profileInitialsSize = 54;

  /// Delivery zone recovery map preview.
  static const double deliveryMapPreviewHeight = 172;
}
