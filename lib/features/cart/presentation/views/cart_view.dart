import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/flouka_back_button.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_list_view_seperated_widget.dart';
import '../widgets/custom_cart_button_widget.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final hasItems =
        cartProvider.data != null && cartProvider.data!.isNotEmpty;
    final itemCount = cartProvider.totalItemCount;
    final vendorCount = cartProvider.vendorCount;
    final subtitle = LanguageProvider.translate('cart', 'page_subtitle')
        .replaceAll('*items*', itemCount.toString())
        .replaceAll('*vendors*', vendorCount.toString());

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageGutter,
                6,
                AppSpacing.pageGutter,
                12,
              ),
              child: Row(
                children: [
                  const FloukaBackButton(),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      LanguageProvider.translate('global', 'cart'),
                      style: TextStyleClass.screenTitleStyle(),
                    ),
                  ),
                  if (hasItems)
                    Text(
                      subtitle,
                      style: TextStyleClass.smallStyle(
                        color: AppColor.mutedColor,
                      ).copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  cartProvider.refresh();
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageGutter,
                    0,
                    AppSpacing.pageGutter,
                    12,
                  ),
                  children: const [
                    CartListViewSeperatedWidget(),
                  ],
                ),
              ),
            ),
            if (hasItems) CustomCartButtonWidget(cartProvider: cartProvider),
          ],
        ),
      ),
    );
  }
}
