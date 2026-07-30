import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/core/widgets/flouka_search_pill.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/pages/filter_page.dart';
import 'package:flouka/features/products/presentation/widgets/shop_products_page_filter.dart';
import 'package:flouka/features/products/presentation/widgets/shop_products_grid.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/widgets/svg_widget.dart';

class ShopProductsPage extends StatelessWidget {
  const ShopProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FloukaSearchPill(
                      hint: LanguageProvider.translate('global', 'search'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      navP(const FilterPage());
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
              const SizedBox(height: 12),
              const ShopProductsPageFilter(),
              const SizedBox(height: 8),
              const Expanded(
                child: ShopProductsGrid(
                  padding: EdgeInsets.only(top: 4, bottom: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
