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
import 'package:flouka/core/dialog/snack_bar.dart';
import 'package:flouka/features/address/presentation/providers/address_provider.dart';
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
    final authProvider = Provider.of<AuthProvider>(context);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LanguageProvider.translate('global', 'total'),
                style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
              ),
              Text(
                '${formatPrice(checkoutProvider.total())} $currency',
                style: TextStyleClass.cartTotalStyle(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FloukaPrimaryButton(
            onTap: () {
              if (!AuthProvider.isLogin()) {
                showGuestDialog();
                return;
              }
              if (authProvider.userEntity?.addressEntity != null) {
                checkoutProvider.goToPage();
              } else {
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
              }
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
