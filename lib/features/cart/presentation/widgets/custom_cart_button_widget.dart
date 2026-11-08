import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/config/app_shadow.dart';
import 'package:flouka/core/widgets/flouka_primary_button.dart';
import 'package:flouka/core/helper_function/convert.dart';
import 'package:flouka/core/dialog/guest_dialog.dart';
import 'package:flouka/features/cart/domain/checkout_entry.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/checkout_provider.dart';

class CustomCartButtonWidget extends StatelessWidget {
  const CustomCartButtonWidget({super.key, required this.cartProvider});

  final CartProvider cartProvider;

  Widget _summaryRow(String title, String value, {TextStyle? valueStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
          ),
        ),
        Text(
          value,
          style: valueStyle ??
              TextStyleClass.smallStyle(color: AppColor.deepColor)
                  .copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkoutProvider = Provider.of<CheckoutProvider>(context);
    final currency = LanguageProvider.translate('global', 'currency');
    final vendorCount = cartProvider.vendorCount;

    return SafeArea(
      top: false,
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        16,
        AppSpacing.pageGutter,
        12,
      ),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.cartSummaryTop),
        ),
        boxShadow: AppShadow.dock,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _summaryRow(
            LanguageProvider.translate('cart', 'subtotal'),
            '${formatPrice(cartProvider.caluclateTotal())} $currency',
          ),
          const SizedBox(height: 8),
          _summaryRow(
            LanguageProvider.translate('cart', 'delivery_vendors')
                .replaceAll('*num*', vendorCount.toString()),
            '${formatPrice(checkoutProvider.deliveryPrice())} $currency',
          ),
          const SizedBox(height: 12),
          CartSummaryTotal(
            label: LanguageProvider.translate('global', 'total'),
            amount: '${formatPrice(checkoutProvider.total())} $currency',
          ),
          const SizedBox(height: 12),
          FloukaPrimaryButton(
            onTap: () {
              if (checkoutEntryBlockedForGuest(
                isLoggedIn: AuthProvider.isLogin(),
              )) {
                showGuestDialog();
                return;
              }
              checkoutProvider.goToPage();
            },
            text: LanguageProvider.translate('cart', 'validate_order'),
            translateKey: false,
            height: AppSpacing.cartCtaHeight,
          ),
        ],
      ),
    ),
    );
  }
}

/// Cart total, kept clear of the floating chat bubble on the right.
class CartSummaryTotal extends StatelessWidget {
  const CartSummaryTotal({
    super.key,
    required this.label,
    required this.amount,
  });

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        end: AppSpacing.chatBubbleClearance,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              amount,
              key: const Key('cart-total-amount'),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: TextStyleClass.cartTotalStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
