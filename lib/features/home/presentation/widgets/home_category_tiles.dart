import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/flouka_network_image.dart';
import 'package:flouka/features/categories/domain/entity/category_entity.dart';
import 'package:flouka/features/categories/presentation/providers/categories_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Top-level categories as large tiles.
class HomeCategoryTiles extends StatelessWidget {
  const HomeCategoryTiles({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories
        .where((c) => c.parentId == null)
        .take(8)
        .toList();
    if (categories.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pageGutter, 18, AppSpacing.pageGutter, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LanguageProvider.translate('home', 'by_category'),
            style: TextStyleClass.railTitleStyle(color: AppColor.inkColor),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) => _Tile(category: categories[index]),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.category});
  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    final image = category.image;
    return InkWell(
      onTap: () {
        context.read<CategoriesProductSearchProvider>().goToPage({
          'category_id': category.id,
          'title': category.name,
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: AppColor.limeColor,
              child: image != null && image.isNotEmpty
                  ? FloukaNetworkImage(url: image, fit: BoxFit.cover)
                  : null,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyleClass.smallStyle(color: AppColor.inkColor),
          ),
        ],
      ),
    );
  }
}
