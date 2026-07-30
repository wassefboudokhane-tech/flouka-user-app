import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/widgets/flouka_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/app_styles.dart';
import '../../../address/presentation/widgets/my_address_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import '../widgets/checkout_item_widget.dart';
import '../widgets/checkout_terms_widget.dart';
import '../widgets/coupons_widget.dart';
import '../widgets/payment_method_list.dart';
import '../widgets/price_details_widget.dart';

/// Checkout aligned with web `CheckoutClient`.
class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutProvider = Provider.of<CheckoutProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(LanguageProvider.translate('global', 'checkout')),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageGutter,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.limeColor.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        LanguageProvider.translate('global', 'cod_badge'),
                        textAlign: TextAlign.center,
                        style: TextStyleClass.smallStyle(
                          color: AppColor.deepColor,
                        ).copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LanguageProvider.translate('global', 'address'),
                      style: TextStyleClass.railTitleStyle(),
                    ),
                    const SizedBox(height: 8),
                    if (authProvider.userEntity?.addressEntity != null)
                      MyAddressWidget(
                        addressEntity:
                            authProvider.userEntity!.addressEntity!,
                      )
                    else
                      Text(
                        LanguageProvider.translate('global', 'no_address'),
                        style: TextStyleClass.smallStyle(
                          color: AppColor.mutedColor,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      LanguageProvider.translate('global', 'payment_method'),
                      style: TextStyleClass.railTitleStyle(),
                    ),
                    const SizedBox(height: 10),
                    const PaymentMethodsList(),
                    if (cartProvider.data?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 10),
                      Text(
                        LanguageProvider.translate('global', 'my_orders'),
                        style: TextStyleClass.railTitleStyle(),
                      ),
                      const SizedBox(height: 10),
                      CheckoutItemWidget(cartEntity: cartProvider.data!),
                    ],
                    const SizedBox(height: 10),
                    const CheckoutTermsWidget(),
                    const SizedBox(height: 10),
                    const CouponsWidget(),                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.softColor,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(color: AppColor.borderColor),
                      ),
                      child: const PriceDetailesList(),
                    ),
                    const SizedBox(height: AppSpacing.section),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageGutter,
              ),
              child: FloukaPrimaryButton(
                onTap: () => checkoutProvider.makeOrder(),
                text: 'confirm',
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
