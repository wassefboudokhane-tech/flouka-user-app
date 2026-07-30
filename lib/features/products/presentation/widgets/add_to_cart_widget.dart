import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/dialog/snack_bar.dart';
import 'package:flouka/core/widgets/flouka_primary_button.dart';
import 'package:flouka/features/address/presentation/providers/address_provider.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/cart/presentation/providers/cart_operation_provider.dart';
import 'package:flouka/features/cart/presentation/providers/cart_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/product_quantity_provider.dart';
import 'package:flouka/features/products/presentation/providers/product_variant_provider.dart';
import 'package:flouka/features/products/presentation/providers/products_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddToCartWidget extends StatelessWidget {
  const AddToCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productDetailsProvider =
        Provider.of<ProductDetailsProvider>(context);
    final productQuantity = Provider.of<ProductQuantityProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final maxQty = productQuantity.maxQuantity();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1.h),
        Text(
          LanguageProvider.translate('global', 'quantity'),
          style: TextStyleClass.semiHeadStyle(color: AppColor.inkColor)
              .copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 1.h),
        _QuantityStepper(
          quantity: productQuantity.quantity,
          max: maxQty,
          enabled: productDetailsProvider.canAddToCart() && maxQty > 0,
          onDecrement: productQuantity.decrement,
          onIncrement: productQuantity.increment,
        ),
        SizedBox(height: 2.h),
        FloukaPrimaryButton(
          width: 100.w,
          enabled: productDetailsProvider.canAddToCart() && maxQty > 0,
          onTap: () {
            if (!productDetailsProvider.canAddToCart() || maxQty <= 0) {
              showToast(
                LanguageProvider.translate(
                  'error',
                  'select_attributes_quantity',
                ),
              );
              return;
            }
            // Guests can add locally; logged-in users need an address for delivery.
            if (AuthProvider.isLogin() &&
                authProvider.userEntity?.addressEntity == null) {
              showToast(
                LanguageProvider.translate('error', 'add_address'),
                isSnack: true,
                action: {
                  'text': LanguageProvider.translate('buttons', 'add'),
                  'onTap': () {
                    Provider.of<AddressProvider>(context, listen: false)
                        .goToAddressPage();
                  },
                },
              );
              return;
            }
            final matched = productDetailsProvider.variantEntity();
            final stockId = matched?.stock?.id ??
                productDetailsProvider.data!.stock!.id;
            final product = productDetailsProvider.data!;
            final selectedAttrs = product.attributes.isEmpty
                ? null
                : productDetailsProvider.variants.entries
                    .map((e) {
                      final attr = product.attributes[e.key];
                      final val = attr.values
                          .where((v) => v.id == e.value)
                          .map((v) => v.value);
                      return val.isEmpty ? null : '${attr.name}: ${val.first}';
                    })
                    .whereType<String>()
                    .join(' · ');
            cartProvider.addToCart(
              storeId: product.store!.id,
              quantity: productQuantity.quantity,
              storeProductStockId: stockId,
              productId: product.id,
              title: product.title,
              vendorName: product.store?.name,
              price: matched != null
                  ? (matched.offerPrice ?? matched.price)
                  : (product.offerPrice ?? product.price),
              image: product.image ??
                  (product.images.isNotEmpty ? product.images.first.image : null),
              variantLabel: selectedAttrs?.isEmpty == true ? null : selectedAttrs,
            );
          },
          text: 'add_to_cart',
          widget: Icon(
            Icons.add_shopping_cart,
            color: AppColor.deepColor,
            size: 20,
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.max,
    required this.enabled,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final int max;
  final bool enabled;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final canDec = enabled && quantity > 1;
    final canInc = enabled && quantity < max;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.btn),
        border: Border.all(color: AppColor.borderColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            enabled: canDec,
            onTap: onDecrement,
          ),
          SizedBox(
            width: 48,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: TextStyleClass.normalStyle(color: AppColor.inkColor)
                  .copyWith(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
          _StepButton(
            icon: Icons.add,
            enabled: canInc,
            onTap: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? AppColor.primaryColor
          : AppColor.borderColor.withValues(alpha: 0.5),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
