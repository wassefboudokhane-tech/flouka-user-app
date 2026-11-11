import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/creators/presentation/providers/creators_provider.dart';
import 'package:flouka/features/creators/presentation/widgets/creator_avatar.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/domain/entity/product_entity.dart';
import 'package:flouka/features/products/presentation/providers/home_products_provider.dart';
import 'package:flouka/features/products/presentation/widgets/hot_deals_home_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A creator's shop: who they are, then the products they recommend.
class CreatorStorefrontPage extends StatelessWidget {
  const CreatorStorefrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreatorsProvider>();
    final creator = provider.current;
    if (creator == null) {
      return Scaffold(
        backgroundColor: AppColor.canvasColor,
        appBar: AppBar(backgroundColor: AppColor.deepColor),
      );
    }

    // Sample creators have no picks of their own: show live home products so
    // the screen can be reviewed with real cards.
    final List<ProductEntity> products = provider.isDemo
        ? context.watch<HomeProductsProvider>().productsList
        : creator.products;

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.deepColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppRadius.homeHeader),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                AppSpacing.pageGutter,
                MediaQuery.paddingOf(context).top + 8,
                AppSpacing.pageGutter,
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    tooltip:
                        MaterialLocalizations.of(context).backButtonTooltip,
                    icon: const BackButtonIcon(),
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CreatorAvatar(
                        creator: creator,
                        size: 72,
                        ringColor: AppColor.limeColor,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              creator.name,
                              style: TextStyleClass.semiHeadStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              [
                                '@${creator.handle}',
                                if ((creator.niche ?? '').isNotEmpty)
                                  creator.niche!,
                              ].join(' · '),
                              style: TextStyleClass.smallStyle(
                                color: const Color(0xFFD9C8EC),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (creator.bio.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Text(
                      creator.bio,
                      style: TextStyleClass.smallStyle(
                        color: const Color(0xFFF1E9F8),
                      ).copyWith(height: 1.45),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      LanguageProvider.translate('creators', 'affiliate_note'),
                      style: TextStyleClass.captionStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageGutter,
              18,
              AppSpacing.pageGutter,
              10,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                LanguageProvider.translate('creators', 'picks_title'),
                style: TextStyleClass.railTitleStyle(color: AppColor.inkColor),
              ),
            ),
          ),
          if (provider.loadingCurrent)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            )
          else if (products.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  LanguageProvider.translate('creators', 'empty_picks'),
                  textAlign: TextAlign.center,
                  style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageGutter,
                0,
                AppSpacing.pageGutter,
                32,
              ),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final cardW =
                      (constraints.crossAxisExtent - AppSpacing.cardGap) / 2;
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.cardGap,
                      crossAxisSpacing: AppSpacing.cardGap,
                      childAspectRatio: cardW /
                          HotDealsHomeContainerWidget.estimatedHeight(cardW),
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => HotDealsHomeContainerWidget(
                        product: products[index],
                      ),
                      childCount: products.length,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
