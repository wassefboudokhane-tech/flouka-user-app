import 'package:flouka/features/cart/presentation/widgets/cart_free_delivery_gauge_widget.dart';
import 'package:flouka/features/cart/presentation/widgets/cart_promo_link_widget.dart';
import 'package:flouka/features/cart/presentation/widgets/cart_vendor_group_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_lotties.dart';
import '../../../../core/widgets/loading_animation_widget.dart';
import '../providers/cart_provider.dart';
import 'cart_empty_recovery_widget.dart';

class CartListViewSeperatedWidget extends StatelessWidget {
  const CartListViewSeperatedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    if (cartProvider.data == null) {
      return const Center(
        child: LoadingAnimationWidget(gif: Lotties.loading),
      );
    }
    if (cartProvider.data!.isEmpty) {
      return const CartEmptyRecoveryWidget();
    }

    final groups = cartProvider.vendorGroups;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CartFreeDeliveryGaugeWidget(),
        for (final group in groups) CartVendorGroupWidget(group: group),
        const CartPromoLinkWidget(),
      ],
    );
  }
}
