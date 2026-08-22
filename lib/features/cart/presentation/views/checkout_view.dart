import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/address/presentation/widgets/my_address_widget.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/cart/presentation/widgets/checkout_confirm_footer_widget.dart';
import 'package:flouka/features/cart/presentation/widgets/checkout_progress_widget.dart';
import 'package:flouka/features/cart/presentation/widgets/checkout_recovery_banner.dart';
import 'package:flouka/features/cart/presentation/widgets/checkout_summary_block_widget.dart';
import 'package:flouka/features/cart/presentation/widgets/payment_method_list.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Checkout — 3 blocs : Adresse · Paiement · Récapitulatif.
class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageGutter,
                4,
                AppSpacing.pageGutter,
                12,
              ),
              child: Row(
                children: [
                  Material(
                    color: AppColor.backgroundColor,
                    borderRadius: BorderRadius.circular(AppRadius.checkoutBack),
                    child: InkWell(
                      onTap: () => Navigator.maybePop(context),
                      borderRadius:
                          BorderRadius.circular(AppRadius.checkoutBack),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Transform.rotate(
                            angle: 0.785398,
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: AppColor.deepColor,
                                    width: 2,
                                  ),
                                  bottom: BorderSide(
                                    color: AppColor.deepColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      LanguageProvider.translate('cart', 'validate_order'),
                      style: TextStyleClass.semiHeadStyle(
                        color: AppColor.deepColor,
                      ).copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        letterSpacing: -0.02,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageGutter,
                  0,
                  AppSpacing.pageGutter,
                  12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CheckoutProgressWidget(activeStep: 2),
                    const SizedBox(height: 14),
                    const CheckoutRecoveryBanner(),
                    _CheckoutSectionCard(
                      title: LanguageProvider.translate('global', 'address'),
                      child: authProvider.userEntity?.addressEntity != null
                          ? MyAddressWidget(
                              addressEntity:
                                  authProvider.userEntity!.addressEntity!,
                            )
                          : Text(
                              LanguageProvider.translate(
                                'global',
                                'no_address',
                              ),
                              style: TextStyleClass.smallStyle(
                                color: AppColor.mutedColor,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    _CheckoutSectionCard(
                      title: LanguageProvider.translate(
                        'global',
                        'payment_method',
                      ),
                      child: const PaymentMethodsList(),
                    ),
                    const SizedBox(height: 12),
                    const CheckoutSummaryBlockWidget(),
                    const SizedBox(height: AppSpacing.section),
                  ],
                ),
              ),
            ),
            const CheckoutConfirmFooterWidget(),
          ],
        ),
      ),
    );
  }
}

class _CheckoutSectionCard extends StatelessWidget {
  const _CheckoutSectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyleClass.smallStyle(color: AppColor.deepColor)
                .copyWith(fontWeight: FontWeight.w800, fontSize: 13),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
