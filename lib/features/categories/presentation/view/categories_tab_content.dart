import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/categories/domain/entity/category_entity.dart';
import 'package:flouka/features/categories/presentation/providers/categories_provider.dart';
import 'package:flouka/features/categories/presentation/providers/subcategory_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Explorer · Catégories — vertical rail + subcategory grid (hi-fi refonte).
class CategoriesTabContent extends StatefulWidget {
  const CategoriesTabContent({super.key});

  @override
  State<CategoriesTabContent> createState() => _CategoriesTabContentState();
}

class _CategoriesTabContentState extends State<CategoriesTabContent> {
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncSubcategories());
  }

  void _syncSubcategories() {
    final categories = context.read<CategoryProvider>().categories;
    if (categories.isEmpty) return;
    final index = _selectedCategoryIndex.clamp(0, categories.length - 1);
    context.read<SubcategoryProvider>().getSubcategories(categories[index]);
  }

  void _selectCategory(int index, List<CategoryEntity> categories) {
    setState(() => _selectedCategoryIndex = index);
    context.read<SubcategoryProvider>().getSubcategories(categories[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, _) {
        final categories = provider.categories;
        if (categories.isEmpty) {
          return Center(
            child: Text(
              LanguageProvider.translate('orders', 'empty_search'),
              style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
            ),
          );
        }

        final selectedIndex =
            _selectedCategoryIndex.clamp(0, categories.length - 1);
        final selectedCategory = categories[selectedIndex];
        final subcategories =
            context.watch<SubcategoryProvider>().subcategories;

        return RefreshIndicator(
          onRefresh: () async {
            await provider.refresh();
            _syncSubcategories();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: AppSpacing.exploreCategoryRailWidth,
                child: ListView.separated(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.pageGutter,
                    bottom: 16,
                  ),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 7),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final active = index == selectedIndex;
                    return _CategoryRailTile(
                      name: cat.name,
                      count: cat.children?.length,
                      selected: active,
                      onTap: () => _selectCategory(index, categories),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsetsDirectional.only(
                    end: AppSpacing.pageGutter,
                    bottom: 16,
                  ),
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _FilterChip(
                          label: LanguageProvider.translate('navbar', 'filter_all'),
                          selected: true,
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (subcategories.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: InkWell(
                          onTap: () {
                            Provider.of<CategoriesProductSearchProvider>(
                              context,
                              listen: false,
                            ).goToPage({
                              'category_id': selectedCategory.id,
                              'category': selectedCategory.name,
                            });
                          },
                          borderRadius:
                              BorderRadius.circular(AppRadius.exploreSubcategory),
                          child: Container(
                            height: AppSpacing.exploreSubcategoryTileHeight,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColor.softColor,
                                  AppColor.backgroundColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                AppRadius.exploreSubcategory,
                              ),
                              border: Border.all(color: AppColor.borderColor),
                            ),
                            alignment: AlignmentDirectional.bottomStart,
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              selectedCategory.name,
                              style: TextStyleClass.captionStyle(
                                color: AppColor.deepColor,
                              ).copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 11.5,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      ..._subcategoryRows(subcategories),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _subcategoryRows(List<CategoryEntity> subcategories) {
    final rows = <Widget>[];
    for (var i = 0; i < subcategories.length; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(
              child: _SubcategoryTile(subcategory: subcategories[i]),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: i + 1 < subcategories.length
                  ? _SubcategoryTile(subcategory: subcategories[i + 1])
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
      if (i + 2 < subcategories.length) {
        rows.add(const SizedBox(height: 8));
      }
    }
    return rows;
  }
}

class _CategoryRailTile extends StatelessWidget {
  const _CategoryRailTile({
    required this.name,
    required this.selected,
    required this.onTap,
    this.count,
  });

  final String name;
  final bool selected;
  final VoidCallback onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColor.deepColor : AppColor.backgroundColor,
      borderRadius: BorderRadius.circular(AppRadius.btn),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.btn),
        child: Container(
          height: AppSpacing.exploreCategoryTileHeight,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.btn),
            border: selected
                ? null
                : Border.all(color: AppColor.borderColor),
          ),
          alignment: AlignmentDirectional.centerStart,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyleClass.captionStyle(
                  color: selected
                      ? AppColor.backgroundColor
                      : AppColor.inkColor,
                ).copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  fontSize: 12.5,
                  height: 1.2,
                ),
              ),
              if (count != null && count! > 0) ...[
                const SizedBox(height: 2),
                Text(
                  '$count',
                  style: TextStyleClass.captionStyle(
                    color: selected
                        ? AppColor.backgroundColor.withValues(alpha: 0.5)
                        : AppColor.mutedColor,
                  ).copyWith(fontSize: 9.5, height: 1.2),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColor.deepColor : AppColor.backgroundColor,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: selected
                ? null
                : Border.all(color: AppColor.borderColor),
          ),
          child: Text(
            label,
            style: TextStyleClass.captionStyle(
              color: selected ? AppColor.backgroundColor : AppColor.navColor,
            ).copyWith(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}

class _SubcategoryTile extends StatelessWidget {
  const _SubcategoryTile({required this.subcategory});

  final CategoryEntity subcategory;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<CategoriesProductSearchProvider>(
          context,
          listen: false,
        ).goToPage({
          'category_id': subcategory.id,
          'category': subcategory.name,
        });
      },
      borderRadius: BorderRadius.circular(AppRadius.exploreSubcategory),
      child: Container(
        height: AppSpacing.exploreSubcategoryTileHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColor.softColor, AppColor.backgroundColor],
          ),
          borderRadius: BorderRadius.circular(AppRadius.exploreSubcategory),
          border: Border.all(color: AppColor.borderColor),
          image: subcategory.image != null && subcategory.image!.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(subcategory.image!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.08),
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
        alignment: AlignmentDirectional.bottomStart,
        padding: const EdgeInsets.all(8),
        child: Text(
          subcategory.name,
          style: TextStyleClass.captionStyle(color: AppColor.deepColor)
              .copyWith(fontWeight: FontWeight.w700, fontSize: 11.5),
        ),
      ),
    );
  }
}
