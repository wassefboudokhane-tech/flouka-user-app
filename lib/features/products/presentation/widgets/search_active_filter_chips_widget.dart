import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flouka/features/products/presentation/providers/search_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchActiveFilterChipsWidget extends StatelessWidget {
  const SearchActiveFilterChipsWidget({super.key});

  int _activeFilterCount(SearchFilterProvider filters) {
    var count = 0;
    for (final filter in filters.mainFilters) {
      if (filter['value'] != null) count++;
    }
    for (final filter in filters.apiFilters) {
      if (filter['value'] != null) count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final search = context.watch<CategoriesProductSearchProvider>();
    final filters = context.watch<SearchFilterProvider>();
    final activeCount = _activeFilterCount(filters);
    final isNew = search.inputs?['offer_products'] == 1 ||
        search.sortMode == 'newest';
    final maxPrice = search.inputs?['max_price'];

    final chips = <Widget>[
      _FilterChipButton(
        label: LanguageProvider.translate('search', 'filter'),
        badge: activeCount > 0 ? '$activeCount' : null,
        deep: true,
        onTap: () => filters.goToFilterPage(),
      ),
    ];

    if (search.category != null) {
      chips.add(
        _FilterChipButton(
          label: search.category!.name,
          removable: true,
          onTap: () => search.selectCategory(null),
        ),
      );
    }

    if (search.subcategory != null) {
      chips.add(
        _FilterChipButton(
          label: search.subcategory!.name,
          removable: true,
          onTap: () {
            search.subcategory = null;
            search.refresh();
          },
        ),
      );
    }

    if (maxPrice != null) {
      chips.add(
        _FilterChipButton(
          label: LanguageProvider.translate('search', 'under_price')
              .replaceAll('*price*', '$maxPrice'),
          removable: true,
          danger: true,
          onTap: () => search.setMaxPriceFilter(null),
        ),
      );
    } else {
      chips.add(
        _FilterChipButton(
          label: LanguageProvider.translate('search', 'under_50'),
          outline: true,
          onTap: () => search.setMaxPriceFilter(50),
        ),
      );
    }

    chips.add(
      _FilterChipButton(
        label: LanguageProvider.translate('search', 'new_arrivals'),
        outline: !isNew,
        deep: isNew,
        onTap: () => search.toggleNewArrivals(),
      ),
    );

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 7),
        itemBuilder: (_, index) => chips[index],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.label,
    required this.onTap,
    this.badge,
    this.removable = false,
    this.deep = false,
    this.outline = false,
    this.danger = false,
  });

  final String label;
  final VoidCallback onTap;
  final String? badge;
  final bool removable;
  final bool deep;
  final bool outline;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color fg;

    if (deep) {
      bg = AppColor.deepColor;
      border = AppColor.deepColor;
      fg = Colors.white;
    } else if (danger) {
      bg = AppColor.redSoft;
      border = AppColor.DealColor;
      fg = AppColor.DealColor;
    } else if (outline) {
      bg = AppColor.backgroundColor;
      border = AppColor.borderColor;
      fg = AppColor.mutedColor;
    } else {
      bg = AppColor.softColor;
      border = AppColor.primaryColor;
      fg = AppColor.deepColor;
    }

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyleClass.captionStyle(color: fg).copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 6),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColor.limeColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    badge!,
                    style: TextStyleClass.captionStyle(
                      color: AppColor.deepColor,
                    ).copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 9,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
              if (removable) ...[
                const SizedBox(width: 6),
                Text(
                  '×',
                  style: TextStyleClass.captionStyle(
                    color: danger ? fg : AppColor.primaryColor,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SearchResultsBarWidget extends StatelessWidget {
  const SearchResultsBarWidget({super.key});

  String _sortLabel(String mode) {
    switch (mode) {
      case 'newest':
        return LanguageProvider.translate('search', 'sort_newest');
      default:
        return LanguageProvider.translate('search', 'sort_best_selling');
    }
  }

  void _showSortSheet(BuildContext context, CategoriesProductSearchProvider search) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColor.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  LanguageProvider.translate('search', 'sort_title'),
                  style: TextStyleClass.smallStyle(color: AppColor.deepColor)
                      .copyWith(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                const SizedBox(height: 12),
                _SortOption(
                  label: LanguageProvider.translate('search', 'sort_best_selling'),
                  selected: search.sortMode == 'best_selling',
                  onTap: () {
                    search.setSortMode('best_selling');
                    Navigator.pop(ctx);
                  },
                ),
                _SortOption(
                  label: LanguageProvider.translate('search', 'sort_newest'),
                  selected: search.sortMode == 'newest',
                  onTap: () {
                    search.setSortMode('newest');
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final search = context.watch<CategoriesProductSearchProvider>();
    final count = search.data?.length ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        10,
        AppSpacing.pageGutter,
        10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            LanguageProvider.translate('search', 'results_count')
                .replaceAll('*count*', '$count'),
            style: TextStyleClass.smallStyle(color: AppColor.deepColor)
                .copyWith(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          InkWell(
            onTap: () => _showSortSheet(context, search),
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Text(
                  _sortLabel(search.sortMode),
                  style: TextStyleClass.captionStyle(color: AppColor.mutedColor)
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: AppColor.mutedColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  const _SortOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: TextStyleClass.smallStyle(color: AppColor.deepColor).copyWith(
          fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
        ),
      ),
      trailing: selected
          ? Icon(Icons.check_rounded, color: AppColor.primaryColor)
          : null,
    );
  }
}
