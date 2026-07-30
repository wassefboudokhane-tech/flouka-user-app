import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/categories/presentation/providers/categories_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Horizontal category pills for search — Mode / Maison style (web shop parity).
class CategoriesViewAllFilterWidget extends StatelessWidget {
  const CategoriesViewAllFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final search = Provider.of<CategoriesProductSearchProvider>(context);

    return Consumer<CategoryProvider>(
      builder: (context, provider, _) {
        final filters = provider.categories;
        if (filters.isEmpty && provider.isLoading) {
          return const SizedBox(
            height: 40,
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        if (filters.isEmpty) return const SizedBox.shrink();

        final selected = search.category;

        return SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                final allSelected = selected == null;
                return _Pill(
                  label: LanguageProvider.translate('global', 'see_all'),
                  selected: allSelected,
                  lime: true,
                  onTap: () => search.selectCategory(null),
                );
              }
              final filter = filters[index - 1];
              final isSelected = filter == selected;
              return _Pill(
                label: filter.name,
                selected: isSelected,
                onTap: () => search.selectCategory(filter),
              );
            },
          ),
        );
      },
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
    this.lime = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool lime;

  @override
  Widget build(BuildContext context) {
    final bg = lime
        ? (selected ? AppColor.limeColor : AppColor.softColor)
        : (selected ? AppColor.deepColor : Colors.white);
    final fg = lime
        ? AppColor.deepColor
        : (selected ? Colors.white : AppColor.inkColor);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: selected && !lime
                ? AppColor.deepColor
                : AppColor.borderColor,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyleClass.smallStyle(color: fg).copyWith(
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ),
    );
  }
}
