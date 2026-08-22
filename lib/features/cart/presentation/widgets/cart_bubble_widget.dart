import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_shadow.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/convert.dart';
import 'package:flouka/features/cart/presentation/providers/cart_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Floating cart pill above the nav dock — hi-fi refonte layout.
class CartBubbleWidget extends StatelessWidget {
  const CartBubbleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        if (!cart.hasItems) {
          return const SizedBox.shrink();
        }

        final itemLabel = LanguageProvider.translate(
          'navbar',
          'cart_bubble_items',
        ).replaceAll('*num*', cart.totalItemCount.toString());

        final totalLabel = LanguageProvider.translate(
          'navbar',
          'cart_bubble_total',
        ).replaceAll('*total*', formatPrice(cart.caluclateTotal()));

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => cart.goToPage(),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: Container(
              height: AppSpacing.cartBubbleHeight,
              padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
              decoration: BoxDecoration(
                color: AppColor.deepColor,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                boxShadow: AppShadow.cartBubble,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemLabel,
                        style: TextStyleClass.captionStyle(
                          color: AppColor.backgroundColor.withValues(alpha: 0.5),
                        ).copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 9.5,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        totalLabel,
                        style: TextStyleClass.smallStyle(
                          color: AppColor.backgroundColor,
                        ).copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 13.5,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 11),
                  Container(
                    width: 32,
                    height: 32,
                  decoration: BoxDecoration(
                    color: AppColor.limeColor,
                    shape: BoxShape.circle,
                  ),
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: const Offset(-1, 0),
                      child: Transform.rotate(
                        angle: 0.785398,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: AppColor.deepColor,
                                width: 2,
                              ),
                              right: BorderSide(
                                color: AppColor.deepColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
