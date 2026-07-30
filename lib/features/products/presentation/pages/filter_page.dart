import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/core/widgets/flouka_primary_button.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flouka/features/products/presentation/providers/search_filter_provider.dart';
import 'package:flouka/features/products/presentation/widgets/filter_children_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Shop filters — Flouka merch tokens, clear sections + price labels.
class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchFilterProvider provider = Provider.of(context);

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      appBar: AppBar(
        title: Text(LanguageProvider.translate('filters', 'filter')),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                itemCount: provider.mainFilters.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final text = provider.mainFilters[index];
                  final hasValue = text['value'] != null;
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(
                        color: hasValue
                            ? AppColor.primaryColor.withValues(alpha: 0.45)
                            : AppColor.borderColor,
                      ),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        splashColor: AppColor.primaryColor.withValues(alpha: 0.06),
                      ),
                      child: ExpansionTile(
                        initiallyExpanded:
                            text['title'] == 'category' || text['title'] == 'price',
                        tilePadding: const EdgeInsets.symmetric(horizontal: 14),
                        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                        iconColor: AppColor.primaryColor,
                        collapsedIconColor: AppColor.mutedColor,
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                LanguageProvider.translate(
                                  'filter',
                                  text['title'],
                                ),
                                style: TextStyleClass.normalStyle(
                                  color: AppColor.deepColor,
                                ).copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            if (hasValue)
                              Flexible(
                                child: Text(
                                  provider.getFilterLabel(text['value']),
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyleClass.captionStyle(
                                    color: AppColor.primaryColor,
                                  ).copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                          ],
                        ),
                        children: [
                          FilterChildrenWidget(data: text),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColor.borderColor)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: provider.resetFilters,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.deepColor,
                        side: BorderSide(color: AppColor.primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                      child: Text(
                        LanguageProvider.translate('buttons', 'reset'),
                        style: TextStyleClass.smallStyle(color: AppColor.deepColor)
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FloukaPrimaryButton(
                      width: double.infinity,
                      onTap: () {
                        Provider.of<CategoriesProductSearchProvider>(
                          context,
                          listen: false,
                        ).getProductsFromFilter();
                        navPop();
                      },
                      text: 'apply',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
