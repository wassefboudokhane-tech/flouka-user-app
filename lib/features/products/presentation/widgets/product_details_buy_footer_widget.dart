import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/dialog/snack_bar.dart';
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

class ProductDetailsBuyFooterWidget extends StatelessWidget {
  const ProductDetailsBuyFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productDetailsProvider = context.watch<ProductDetailsProvider>();
    final productQuantity = context.watch<ProductQuantityProvider>();
    final maxQty = productQuantity.maxQuantity();
    final attrsReady = productDetailsProvider.canAddToCart();
    final enabled = attrsReady && maxQty > 0;
    final ctaLabel = !attrsReady
        ? LanguageProvider.translate('product', 'select_variant_cta')
        : LanguageProvider.translate('buttons', 'add_to_cart');

    return SafeArea(
      top: false,
      child: Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        border: Border(top: BorderSide(color: AppColor.borderColor)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        12,
        AppSpacing.pageGutter,
        12,
      ),
      child: Row(
        children: [
          Container(
            height: AppSpacing.pdpBuyBarHeight,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColor.borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepTap(
                  label: '−',
                  enabled: enabled && productQuantity.quantity > 1,
                  onTap: productQuantity.decrement,
                  muted: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '${productQuantity.quantity}',
                    style: TextStyleClass.normalStyle(color: AppColor.inkColor)
                        .copyWith(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ),
                _StepTap(
                  label: '+',
                  enabled: enabled && productQuantity.quantity < maxQty,
                  onTap: productQuantity.increment,
                ),
              ],
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Material(
              color: enabled ? AppColor.limeColor : AppColor.borderColor,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              elevation: enabled ? 4 : 0,
              shadowColor: AppColor.primaryColor.withValues(alpha: 0.2),
              child: InkWell(
                onTap: enabled ? () => _addToCart(context) : null,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: SizedBox(
                  height: AppSpacing.pdpBuyBarHeight,
                  child: Center(
                    child: Text(
                      ctaLabel,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleClass.buttonStyle(
                        color: AppColor.deepColor,
                      ).copyWith(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  void _addToCart(BuildContext context) {
    final productDetailsProvider =
        context.read<ProductDetailsProvider>();
    final productQuantity = context.read<ProductQuantityProvider>();
    final cartProvider = context.read<CartProvider>();

    if (!productDetailsProvider.canAddToCart() ||
        productQuantity.maxQuantity() <= 0) {
      showToast(
        LanguageProvider.translate('error', 'select_attributes_quantity'),
      );
      return;
    }
    if (AuthProvider.isLogin() &&
        context.read<AuthProvider>().userEntity?.addressEntity == null) {
      showToast(
        LanguageProvider.translate('error', 'add_address'),
        isSnack: true,
        action: {
          'text': LanguageProvider.translate('buttons', 'add'),
          'onTap': () {
            context.read<AddressProvider>().goToAddressPage();
          },
        },
      );
      return;
    }

    final matched = productDetailsProvider.variantEntity();
    final stockId =
        matched?.stock?.id ?? productDetailsProvider.data!.stock!.id;
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
  }
}

class _StepTap extends StatelessWidget {
  const _StepTap({
    required this.label,
    required this.enabled,
    required this.onTap,
    this.muted = false,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          label,
          style: TextStyleClass.normalStyle(
            color: muted ? AppColor.mutedColor : AppColor.deepColor,
          ).copyWith(fontWeight: FontWeight.w700, fontSize: 17, height: 1),
        ),
      ),
    );
  }
}
