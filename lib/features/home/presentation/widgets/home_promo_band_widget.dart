import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Compact promo band — hi-fi refonte with blur orb + 32px CTA.
class HomePromoBandWidget extends StatelessWidget {
  const HomePromoBandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        0,
        AppSpacing.pageGutter,
        12,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.promoBand),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColor.deepColor,
                borderRadius: BorderRadius.circular(AppRadius.promoBand),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LanguageProvider.translate('home', 'promo_title'),
                          style: TextStyleClass.smallStyle(
                            color: AppColor.backgroundColor,
                          ).copyWith(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.015,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          LanguageProvider.translate('home', 'promo_subtitle'),
                          style: TextStyleClass.captionStyle(
                            color: AppColor.backgroundColor.withValues(alpha: 0.55),
                          ).copyWith(
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: AppColor.limeColor,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: InkWell(
                      onTap: () {
                        Provider.of<CategoriesProductSearchProvider>(
                          context,
                          listen: false,
                        ).goToPage();
                      },
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: SizedBox(
                        height: 32,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Center(
                            child: Text(
                              LanguageProvider.translate('home', 'promo_cta'),
                              style: TextStyleClass.captionStyle(
                                color: AppColor.deepColor,
                              ).copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 11.5,
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
            Positioned(
              top: -50,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.limeColor.withValues(alpha: 0.15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
