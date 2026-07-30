import 'package:cached_network_image/cached_network_image.dart';
import 'package:flouka/features/cart/presentation/providers/cart_operation_provider.dart';
import 'package:flouka/features/products/presentation/providers/products_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/config/app_color.dart';
import '../../../../../core/config/app_radius.dart';
import '../../../../../core/config/app_spacing.dart';
import '../../../../../core/config/app_styles.dart';
import '../../../../core/helper_function/convert.dart';
import '../../../../core/widgets/price_widget.dart';
import '../../domain/entity/cart_entity.dart';
import '../providers/cart_provider.dart';
import 'button_action_cart_widget.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({super.key, required this.cartEntity});
  final CartEntity cartEntity;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final name = cartEntity.variant != null
        ? cartEntity.variant!.name
        : cartEntity.product!.title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            context.read<ProductDetailsProvider>().goToPage({
              'product_id': cartEntity.product!.id,
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColor.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.btn),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: CachedNetworkImage(
                      imageUrl: cartEntity.product?.image ??
                          'https://placehold.co/600x400',
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleClass.productTitleStyle(
                                color: AppColor.inkColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              cartProvider.deleteCartItem(cartEntity.id!);
                            },
                            child: Icon(
                              Icons.clear,
                              color: AppColor.DealColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      if (cartEntity.variant?.attributeValues.isNotEmpty ??
                          false) ...[
                        const SizedBox(height: 4),
                        Text(
                          cartEntity.variant!.attributeValues
                              .map((a) =>
                                  '${a.attributeName ?? ''} : ${a.valueName ?? ''}')
                              .join(' | '),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyleClass.captionStyle(),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: PriceWidget(
                              price: convertDataToNum(
                                    cartEntity.subTotal.toStringAsFixed(2),
                                  ) ??
                                  0,
                            ),
                          ),
                          Expanded(
                            child: ButtonsActionCartWidget(
                              count: cartEntity.quantity!,
                              max: cartEntity.stock ?? 0,
                              onAdd: () {
                                if (cartEntity.quantity! < cartEntity.stock!) {
                                  cartProvider.increaseCart(cartEntity.id!);
                                }
                              },
                              onRemove: () {
                                if (cartEntity.quantity! > 1) {
                                  cartProvider.decreaseCart(cartEntity.id!);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
