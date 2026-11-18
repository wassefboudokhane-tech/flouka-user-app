import 'package:share_plus/share_plus.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/creators/presentation/providers/creators_provider.dart';
import 'package:flouka/features/creators/presentation/widgets/creator_avatar.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/domain/entity/product_entity.dart';
import 'package:flouka/features/products/presentation/widgets/hot_deals_home_container_widget.dart';
import 'package:flouka/core/creator_social.dart';
import 'package:flouka/features/creators/domain/entity/creator_entity.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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

    final List<ProductEntity> products = creator.products;

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColor.borderColor)),
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
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).backButtonTooltip,
                    icon: const BackButtonIcon(),
                    color: AppColor.inkColor,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CreatorAvatar(
                        creator: creator,
                        size: 72,
                        ringColor: AppColor.borderColor,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              creator.name,
                              style: TextStyleClass.semiHeadStyle(
                                color: AppColor.inkColor,
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
                                color: AppColor.mutedColor,
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
                        color: AppColor.mutedColor,
                      ).copyWith(height: 1.45),
                    ),
                  ],
                  const SizedBox(height: 14),
                  _FollowShareRow(creator: creator),
                  if (_socials(creator).isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final (label, uri) in _socials(creator))
                          OutlinedButton(
                            onPressed: () => launchUrl(uri, mode: LaunchMode.externalApplication),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColor.inkColor,
                              side: const BorderSide(color: Color(0xFF1A1A1A)),
                              visualDensity: VisualDensity.compact,
                              textStyle: TextStyleClass.captionStyle().copyWith(fontSize: 12.5),
                              shape: const RoundedRectangleBorder(),
                            ),
                            child: Text(label),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.softColor,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      LanguageProvider.translate('creators', 'affiliate_note'),
                      style: TextStyleClass.captionStyle(color: AppColor.inkColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_posts(creator).isNotEmpty) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.pageGutter, 18, AppSpacing.pageGutter, 10),
              sliver: SliverToBoxAdapter(
                child: Text(
                  LanguageProvider.translate('creators', 'posts_title'),
                  style: TextStyleClass.railTitleStyle(color: AppColor.inkColor),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 64,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
                  itemCount: _posts(creator).length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final (post, uri) = _posts(creator)[i];
                    return InkWell(
                      onTap: () => launchUrl(uri, mode: LaunchMode.externalApplication),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 220),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFEAEAEE)),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('▶ ${platformLabel(post.platform)}',
                                style: TextStyleClass.smallStyle(color: AppColor.inkColor)),
                            Text(
                              [post.brandName, post.productTitle].whereType<String>().join(' · '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleClass.captionStyle(color: AppColor.mutedColor),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
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
                      childAspectRatio:
                          cardW /
                          HotDealsHomeContainerWidget.estimatedHeight(cardW),
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Stack(
                        children: [
                          Positioned.fill(
                            child: HotDealsHomeContainerWidget(
                              product: products[index],
                              creator: creator,
                            ),
                          ),
                          if (creator.validatedProductIds.contains(products[index].id))
                            PositionedDirectional(
                              top: 8,
                              start: 8,
                              child: _BrandValidatedBadge(),
                            ),
                        ],
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

List<(String, Uri)> _socials(CreatorEntity creator) => [
      for (final (label, network, user) in [
        ('Instagram', 'instagram', creator.instagram),
        ('TikTok', 'tiktok', creator.tiktok),
      ])
        if (safeExternalUri(creatorSocialUrl(network, user)) case final uri?) ('$label @$user', uri),
    ];

List<(CreatorPostEntity, Uri)> _posts(CreatorEntity creator) => [
      for (final post in creator.posts)
        if (safeExternalUri(post.videoUrl) case final uri?) (post, uri),
    ];

class _BrandValidatedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        '✓ ${LanguageProvider.translate('creators', 'brand_validated')}',
        style: TextStyleClass.captionStyle(color: AppColor.inkColor),
      ),
    );
  }
}

class _FollowShareRow extends StatelessWidget {
  const _FollowShareRow({required this.creator});

  final CreatorEntity creator;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreatorsProvider>();
    final following = provider.isFollowing(creator);
    final count = provider.followersOf(creator);
    final shape = const RoundedRectangleBorder();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: following
                  ? FilledButton(
                      onPressed: () => _toggle(context, provider),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColor.inkColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(44),
                        shape: shape,
                      ),
                      child: Text(LanguageProvider.translate('creators', 'following')),
                    )
                  : OutlinedButton(
                      onPressed: () => _toggle(context, provider),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.inkColor,
                        side: BorderSide(color: AppColor.inkColor),
                        minimumSize: const Size.fromHeight(44),
                        shape: shape,
                      ),
                      child: Text(LanguageProvider.translate('creators', 'follow')),
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => SharePlus.instance.share(
                  ShareParams(text: '${creator.name}\n${creatorShareUrl(creator.id, creator.handle)}'),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.inkColor,
                  side: BorderSide(color: AppColor.inkColor),
                  minimumSize: const Size.fromHeight(44),
                  shape: shape,
                ),
                child: Text(LanguageProvider.translate('creators', 'share')),
              ),
            ),
          ],
        ),
        if (count > 0) ...[
          const SizedBox(height: 6),
          Text(
            LanguageProvider.translate('creators', 'followers').replaceAll('*num*', '$count'),
            style: TextStyleClass.captionStyle(),
          ),
        ],
      ],
    );
  }

  void _toggle(BuildContext context, CreatorsProvider provider) {
    provider.toggleFollow(
      creator,
      signedIn: AuthProvider.isLogin(),
      signIn: () => Provider.of<AuthProvider>(context, listen: false).goToLoginView(replace: false),
    );
  }
}
