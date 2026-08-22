import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/flouka_back_button.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flouka/features/products/presentation/widgets/search_active_filter_chips_widget.dart';
import 'package:flouka/features/products/presentation/widgets/shop_products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Search / category listing aligned with hi-fi mockup.
class CategoriesViewAllPage extends StatelessWidget {
  const CategoriesViewAllPage({super.key, this.isSection = false});
  final bool isSection;

  @override
  Widget build(BuildContext context) {
    final search =
        Provider.of<CategoriesProductSearchProvider>(context, listen: false);
    search.pagination();

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
                4,
                AppSpacing.pageGutter,
                10,
              ),
              child: Row(
                children: [
                  const FloukaBackButton(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SearchQueryField(
                      controller: search.searchController,
                      onChanged: (_) => search.onTextChanged(),
                      onClear: () {
                        search.searchController.clear();
                        search.onTextChanged();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SearchActiveFilterChipsWidget(),
            const SearchResultsBarWidget(),
            const Expanded(
              child: ShopProductsGrid(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.pageGutter,
                  0,
                  AppSpacing.pageGutter,
                  24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchQueryField extends StatelessWidget {
  const _SearchQueryField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final hasText = controller.text.isNotEmpty;
        return Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasText ? AppColor.deepColor : AppColor.borderColor,
              width: hasText ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: hasText ? AppColor.deepColor : AppColor.mutedColor,
                    width: 1.8,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  style: TextStyleClass.textFieldStyle().copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: LanguageProvider.translate('categories', 'search'),
                    hintStyle: TextStyleClass.textFieldStyle(
                      color: AppColor.mutedColor,
                    ),
                  ),
                ),
              ),
              if (hasText)
                InkWell(
                  onTap: onClear,
                  borderRadius: BorderRadius.circular(99),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColor.canvasColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '×',
                      style: TextStyleClass.captionStyle(
                        color: AppColor.mutedColor,
                      ).copyWith(fontWeight: FontWeight.w600, fontSize: 11),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
