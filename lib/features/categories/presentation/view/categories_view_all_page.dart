import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/widgets/flouka_search_pill.dart';
import 'package:flouka/core/widgets/svg_widget.dart';
import 'package:flouka/core/constants/app_images.dart';
import 'package:flouka/features/categories/presentation/widgets/categories_view_all_filter_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flouka/features/products/presentation/providers/search_filter_provider.dart';
import 'package:flouka/features/products/presentation/widgets/shop_products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Search / category listing — aligned with web `/shop` mobile filters.
class CategoriesViewAllPage extends StatelessWidget {
  const CategoriesViewAllPage({super.key, this.isSection = false});
  final bool isSection;

  @override
  Widget build(BuildContext context) {
    final categoryProvider =
        Provider.of<CategoriesProductSearchProvider>(context, listen: false);
    categoryProvider.pagination();

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      appBar: AppBar(
        title: Text(LanguageProvider.translate('categories', 'search_title')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageGutter,
              8,
              AppSpacing.pageGutter,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: FloukaSearchPill(
                    controller: categoryProvider.searchController,
                    hint: LanguageProvider.translate('global', 'search'),
                    onChanged: (_) => categoryProvider.onTextChanged(),
                    readOnly: false,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Provider.of<SearchFilterProvider>(context, listen: false)
                        .goToFilterPage();
                  },
                  borderRadius: BorderRadius.circular(AppRadius.btn),
                  child: Container(
                    width: AppSpacing.searchHeight,
                    height: AppSpacing.searchHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.btn),
                      color: AppColor.limeColor,
                      border: Border.all(
                        color: AppColor.deepColor.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Center(
                      child: SvgWidget(
                        svg: AppImages.filter,
                        color: AppColor.deepColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.pageGutter,
              12,
              AppSpacing.pageGutter,
              8,
            ),
            child: CategoriesViewAllFilterWidget(),
          ),
          const Expanded(
            child: ShopProductsGrid(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.pageGutter,
                4,
                AppSpacing.pageGutter,
                24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
