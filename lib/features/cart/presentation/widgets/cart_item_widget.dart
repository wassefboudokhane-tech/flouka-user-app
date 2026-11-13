import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/app_images.dart';
import 'package:flouka/core/widgets/flouka_network_image.dart';
import 'package:flouka/features/products/presentation/providers/products_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/helper_function/convert.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entity/cart_entity.dart';
import '../providers/cart_operation_provider.dart';
import '../providers/cart_provider.dart';
import 'cart_quantity_stepper_widget.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({super.key, required this.cartEntity});
  final CartEntity cartEntity;

  String? _variantLabel() {
    if (cartEntity.variant?.name?.isNotEmpty == true) {
      return cartEntity.variant!.name;
    }
    if (cartEntity.variant?.attributeValues.isNotEmpty == true) {
      return cartEntity.variant!.attributeValues
          .map((a) => a.valueName ?? '')
          .where((s) => s.isNotEmpty)
          .join(' / ');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final title = cartEntity.product?.title ?? '';
    final variantLabel = _variantLabel();

    return InkWell(
      onTap: () {
        context.read<ProductDetailsProvider>().goToPage({
          'product_id': cartEntity.product!.id,
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pageGutter,
          vertical: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.btn),
              child: SizedBox(
                width: AppSpacing.cartLineImage,
                height: AppSpacing.cartLineImage,
                child: FloukaNetworkImage(
                  url: cartEntity.product?.image ?? '',
                  fit: BoxFit.cover,
                  error: Image.asset(
                    AppImages.logo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleClass.productTitleStyle(
                      color: AppColor.inkColor,
                    ),
                  ),
                  if (variantLabel != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      variantLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleClass.captionStyle(),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        formatPrice(
                          convertDataToNum(
                                cartEntity.subTotal.toStringAsFixed(2),
                              ) ??
                              0,
                        ),
                        style: TextStyleClass.cartLinePriceStyle(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        LanguageProvider.translate('global', 'currency'),
                        style: TextStyleClass.captionStyle(
                          color: AppColor.mutedColor,
                        ).copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                CartQuantityStepperWidget(
                  count: cartEntity.quantity ?? 1,
                  max: cartEntity.stock ?? 0,
                  onAdd: () {
                    if ((cartEntity.quantity ?? 0) < (cartEntity.stock ?? 0)) {
                      cartProvider.increaseCart(cartEntity.id!);
                    }
                  },
                  onRemove: () {
                    if ((cartEntity.quantity ?? 0) > 1) {
                      cartProvider.decreaseCart(cartEntity.id!);
                    }
                  },
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => cartProvider.deleteCartItem(cartEntity.id!),
                  borderRadius: BorderRadius.circular(AppRadius.deleteBtn),
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppColor.canvasColor,
                      borderRadius: BorderRadius.circular(AppRadius.deleteBtn),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '×',
                      style: TextStyleClass.smallStyle(
                        color: AppColor.mutedColor,
                      ).copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
