import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
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

  @override
  Widget build(BuildContext context) {
    final checkoutProvider = Provider.of<CheckoutProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        12,
        AppSpacing.pageGutter,
        8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColor.borderColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LanguageProvider.translate('global', 'price'),
                style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
              ),
              Text(
                '${convertDataToDouble(cartProvider.caluclateTotal().toStringAsFixed(2))} ${LanguageProvider.translate('global', 'currency')}',
                style: TextStyleClass.normalStyle(color: AppColor.deepColor)
                    .copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
            text: 'pay',
          ),
        ],
      ),
    );
  }
}
