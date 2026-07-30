export 'hot_deals_home_container_widget.dart' show HotDealsHomeContainerWidget;

import 'package:flutter/material.dart';

import '../../domain/entity/product_entity.dart';
import 'hot_deals_home_container_widget.dart';

/// Canonical marketplace product card alias (web `ProductCard`).
typedef FloukaProductCard = HotDealsHomeContainerWidget;

Widget buildFloukaProductCard({
  required ProductEntity product,
  bool isSimilar = false,
  double? width,
}) {
  return HotDealsHomeContainerWidget(
    product: product,
    isSimilar: isSimilar,
    width: width,
  );
}
