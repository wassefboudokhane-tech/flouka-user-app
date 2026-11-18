import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/pages/filter_page.dart';
import 'package:flutter/material.dart';

/// Quick ways into the filters: brand and price. Both open the filter page,
/// which holds the real filters (the old chips listed placeholder brands).
class ShopProductsPageFilter extends StatelessWidget {
  const ShopProductsPageFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = [
      LanguageProvider.translate('filter', 'brand'),
      LanguageProvider.translate('filter', 'price'),
    ];
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) => InkWell(
          onTap: () => navP(const FilterPage()),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.borderColor),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(labels[index], style: TextStyleClass.smallStyle(color: AppColor.inkColor)),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColor.inkColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
