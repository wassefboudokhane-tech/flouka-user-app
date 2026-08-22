import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/stores/presentation/pages/store_reviews_page.dart';
import 'package:flouka/features/stores/presentation/providers/store_details_provider.dart';
import 'package:flouka/features/stores/presentation/providers/stores_provider.dart';
import 'package:flouka/features/stores/presentation/widgets/all_reviews_container.dart';
import 'package:flouka/features/stores/presentation/widgets/store_products_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoresTabsWidget extends StatelessWidget {
  const StoresTabsWidget({super.key});

  static const List<String> titles = ['products', 'reviews'];

  @override
  Widget build(BuildContext context) {
    final storesProvider = context.watch<StoresProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: List.generate(titles.length, (index) {
            final selected = storesProvider.current == index;
            return Expanded(
              child: InkWell(
                onTap: () => storesProvider.changeCurrent(index),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 11),
                  child: Column(
                    children: [
                      Text(
                        LanguageProvider.translate('global', titles[index]),
                        style: TextStyleClass.smallStyle(
                          color: selected
                              ? AppColor.deepColor
                              : AppColor.mutedColor,
                        ).copyWith(
                          fontWeight:
                              selected ? FontWeight.w800 : FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Container(
                        height: 2.5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColor.deepColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
        Divider(height: 1, color: AppColor.borderColor),
        const SizedBox(height: 12),
        if (storesProvider.current == 0)
          const StoreProductsWidget()
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  final storeId = context
                      .read<StoreDetailsProvider>()
                      .storeDetailsEntity
                      ?.id;
                  if (storeId != null) {
                    navP(StoreReviewsPage(storeId: storeId));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    LanguageProvider.translate('global', 'see_all'),
                    style: TextStyleClass.captionStyle(
                      color: AppColor.primaryColor,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const AllReviewsContainer(),
            ],
          ),
      ],
    );
  }
}
