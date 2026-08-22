import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_shadow.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/convert.dart';
import 'package:flouka/core/widgets/flouka_primary_button.dart';
import 'package:flouka/features/cart/presentation/providers/checkout_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutConfirmFooterWidget extends StatelessWidget {
  const CheckoutConfirmFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final checkout = context.watch<CheckoutProvider>();
    final total = formatPrice(checkout.total());
    final currency = LanguageProvider.translate('global', 'currency');
    final ctaLabel = LanguageProvider.translate('checkout', 'confirm_amount')
        .replaceAll('*total*', total)
        .replaceAll('*currency*', currency);
    final subline = checkout.selectedPaymentSubline();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        14,
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
          FloukaPrimaryButton(
            onTap: () => checkout.makeOrder(),
            text: ctaLabel,
            translateKey: false,
            height: AppSpacing.checkoutCtaHeight,
          ),
          const SizedBox(height: 6),
          Text(
            subline,
            textAlign: TextAlign.center,
            style: TextStyleClass.captionStyle(color: AppColor.mutedColor)
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
