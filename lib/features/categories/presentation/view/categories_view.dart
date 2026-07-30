import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/flouka_search_pill.dart';
import 'package:flouka/features/categories/presentation/providers/categories_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Shop-first categories tab — search + Mode/Maison pills + category tiles.
class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  static const _merchPills = [
    ('Mode', 'mode'),
    ('Maison', 'maison'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      appBar: AppBar(
        title: Text(LanguageProvider.translate('navbar', 'categories')),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CategoryProvider>().refresh();
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageGutter,
            vertical: 16,
          ),
          children: [
            FloukaSearchPill(
              hint: LanguageProvider.translate('global', 'search'),
              readOnly: true,
              onTap: () {
                Provider.of<CategoriesProductSearchProvider>(
                  context,
                  listen: false,
                ).goToPage();
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final pill in _merchPills)
                  InkWell(
                    onTap: () {
                      Provider.of<CategoriesProductSearchProvider>(
                        context,
                        listen: false,
                      ).goToPage({'category': pill.$1});
                    },
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(color: AppColor.borderColor),
                      ),
                      child: Text(
                        pill.$1,
                        style: TextStyleClass.smallStyle(color: AppColor.deepColor)
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                InkWell(
                  onTap: () {
                    Provider.of<CategoriesProductSearchProvider>(
                      context,
                      listen: false,
                    ).goToPage();
                  },
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.limeColor,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      LanguageProvider.translate('global', 'see_all'),
                      style: TextStyleClass.smallStyle(color: AppColor.deepColor)
                          .copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              LanguageProvider.translate('navbar', 'categories'),
              style: TextStyleClass.railTitleStyle(),
            ),
            const SizedBox(height: 12),
            Consumer<CategoryProvider>(
              builder: (context, provider, _) {
                final cats = provider.categories;
                if (cats.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Text(
                      LanguageProvider.translate('orders', 'empty_search'),
                      style: TextStyleClass.smallStyle(
                        color: AppColor.mutedColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cats.length.clamp(0, 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.cardGap,
                    crossAxisSpacing: AppSpacing.cardGap,
                    childAspectRatio: 1.15,
                  ),
                  itemBuilder: (context, index) {
                    final cat = cats[index];
                    return InkWell(
                      onTap: () {
                        Provider.of<CategoriesProductSearchProvider>(
                          context,
                          listen: false,
                        ).goToPage({
                          'category_id': cat.id,
                          'category': cat.name,
                        });
                      },
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(color: AppColor.borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(AppSpacing.cardPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColor.softColor,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.btn),
                                  image: cat.image != null &&
                                          cat.image!.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(cat.image!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: cat.image == null || cat.image!.isEmpty
                                    ? Icon(
                                        Icons.grid_view_rounded,
                                        color: AppColor.primaryColor,
                                        size: 28,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              cat.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleClass.smallStyle(
                                color: AppColor.inkColor,
                              ).copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: AppSpacing.section),
          ],
        ),
      ),
    );
  }
}
