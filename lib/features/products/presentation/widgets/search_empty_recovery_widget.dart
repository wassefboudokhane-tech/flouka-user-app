import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/dialog/snack_bar.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchEmptyRecoveryWidget extends StatelessWidget {
  const SearchEmptyRecoveryWidget({super.key});

  String _activeFilterLabel(CategoriesProductSearchProvider provider) {
    final inputs = provider.inputs;
    if (inputs == null) return '';
    if (inputs['category'] != null) {
      return inputs['category'].toString();
    }
    if (inputs['best_selling'] != null) {
      return LanguageProvider.translate('global', 'best_selling');
    }
    if (inputs['max_price'] != null) {
      return '< ${inputs['max_price']}';
    }
    return inputs.entries.first.value?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CategoriesProductSearchProvider>();
    final filter = _activeFilterLabel(provider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: AppColor.backgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColor.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColor.softColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColor.borderColor),
              ),
              child: Center(
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.deepColor, width: 2.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              LanguageProvider.translate('recovery', 'search_empty_title'),
              style: TextStyleClass.headStyle(color: AppColor.deepColor)
                  .copyWith(fontSize: 21, height: 1.15),
            ),
            const SizedBox(height: 9),
            Text(
              filter.isEmpty
                  ? LanguageProvider.translate('recovery', 'search_empty_body')
                  : LanguageProvider.translate('recovery', 'search_empty_filter')
                      .replaceAll('*filter*', filter),
              style: TextStyleClass.normalStyle(color: AppColor.mutedColor)
                  .copyWith(fontSize: 13.5, height: 1.5),
            ),
            const SizedBox(height: 18),
            Material(
              color: AppColor.limeColor,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: InkWell(
                onTap: () => provider.clearSearch(),
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      LanguageProvider.translate(
                        'recovery',
                        'search_empty_action',
                      ),
                      style: TextStyleClass.buttonStyle(
                        color: AppColor.deepColor,
                      ).copyWith(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 9),
            OutlinedButton(
              onPressed: () {
                showToast(
                  LanguageProvider.translate(
                    'recovery',
                    'search_price_alert_saved',
                  ),
                  isSnack: true,
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColor.mutedColor,
                side: BorderSide(color: AppColor.borderColor),
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
              child: Text(
                LanguageProvider.translate(
                  'recovery',
                  'search_price_alert',
                ),
                style: TextStyleClass.smallStyle(color: AppColor.mutedColor)
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 13.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
