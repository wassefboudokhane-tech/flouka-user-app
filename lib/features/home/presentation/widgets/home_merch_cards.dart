import 'package:cached_network_image/cached_network_image.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../products/domain/entity/product_entity.dart';

/// Amazon-style merch quad blocks (web `MerchCard` — Mode / Maison).
class HomeMerchCards extends StatelessWidget {
  const HomeMerchCards({super.key, required this.products});

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageGutter,
        vertical: 8,
      ),
      child: Column(
        children: [
          _MerchCard(
            title: 'Mode',
            categoryQuery: const {'category': 'Mode'},
            items: _quadLabels(['Femmes', 'Hommes', 'Chaussures', 'Enfants']),
            images: _pickImages(
              products,
              RegExp(r'mode|robe|set|abaya|veste', caseSensitive: false),
              4,
            ),
          ),
          const SizedBox(height: AppSpacing.cardGap),
          _MerchCard(
            title: 'Maison',
            categoryQuery: const {'category': 'Maison'},
            items: _quadLabels(['Parfums', 'Déco', 'Cuisine', 'Cadeaux']),
            images: _pickImages(
              products,
              RegExp(r'bougie|parfum|brume|maison|bayu', caseSensitive: false),
              4,
            ),
          ),
        ],
      ),
    );
  }

  List<String> _quadLabels(List<String> labels) => labels;

  List<String?> _pickImages(List<ProductEntity> list, RegExp pattern, int n) {
    final matched =
        list.where((p) => pattern.hasMatch('${p.title} ${p.store?.name}'));
    final pool = matched.isNotEmpty ? matched : list;
    return List.generate(n, (i) => pool.elementAtOrNull(i)?.image);
  }
}

class _MerchCard extends StatelessWidget {
  const _MerchCard({
    required this.title,
    required this.categoryQuery,
    required this.items,
    required this.images,
  });

  final String title;
  final Map<String, dynamic> categoryQuery;
  final List<String> items;
  final List<String?> images;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColor.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.railAccentW,
                height: AppSpacing.railAccentH,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColor.limeColor, AppColor.primaryColor],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyleClass.railTitleStyle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () {
                  Provider.of<CategoriesProductSearchProvider>(
                    context,
                    listen: false,
                  ).goToPage(categoryQuery);
                },
                child: Text(
                  LanguageProvider.translate('global', 'see_all'),
                  style: TextStyleClass.captionStyle(color: AppColor.primaryColor)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.05,
            children: List.generate(4, (i) {
              return InkWell(
                onTap: () {
                  Provider.of<CategoriesProductSearchProvider>(
                    context,
                    listen: false,
                  ).goToPage(categoryQuery);
                },
                borderRadius: BorderRadius.circular(AppRadius.btn),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.softColor,
                    borderRadius: BorderRadius.circular(AppRadius.btn),
                    border: Border.all(color: AppColor.borderColor),
                    image: images[i] != null
                        ? DecorationImage(
                            image: CachedNetworkImageProvider(images[i]!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.55),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(AppRadius.btn),
                      ),
                    ),
                    child: Text(
                      items[i],
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleClass.captionStyle(color: Colors.white)
                          .copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
