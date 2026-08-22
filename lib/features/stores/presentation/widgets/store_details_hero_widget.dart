import 'package:cached_network_image/cached_network_image.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/app_images.dart';
import 'package:flouka/core/constants/constants.dart';
import 'package:flouka/core/dialog/report_dialog.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/core/widgets/flouka_back_button.dart';
import 'package:flouka/core/widgets/svg_widget.dart';
import 'package:flouka/features/chat/presentation/provider/message_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/stores/domain/entity/store_details_entity.dart';
import 'package:flouka/features/stores/presentation/providers/store_details_provider.dart';
import 'package:flouka/features/stores/presentation/widgets/store_stat_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class StoreDetailsHeroWidget extends StatelessWidget {
  const StoreDetailsHeroWidget({
    super.key,
    required this.store,
  });

  final StoreDetailsEntity store;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<StoreDetailsProvider>();
    final top = MediaQuery.paddingOf(context).top;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.deepColor,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(26),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.limeColor.withValues(alpha: 0.13),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.pageGutter,
              top + 8,
              AppSpacing.pageGutter,
              18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloukaBackButton(
                      onTap: navPop,
                      color: Colors.white,
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                    ),
                    Material(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => _showMenu(context, provider),
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          width: 38,
                          height: 38,
                          child: Icon(Icons.more_horiz, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: AppColor.limeColor,
                          width: 2.5,
                        ),
                        color: AppColor.softColor,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: store.vendor?.logo != null
                          ? CachedNetworkImage(
                              imageUrl: store.vendor!.logo,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.name,
                            style: TextStyleClass.headStyle(color: Colors.white)
                                .copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                              letterSpacing: -0.02,
                            ),
                          ),
                          if (store.bio.isNotEmpty)
                            Text(
                              store.bio,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleClass.captionStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                              ).copyWith(fontSize: 12.5, height: 1.3),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StoreStatItem(
                        title: 'seller_ratings',
                        value: store.avgRating?.toString() ?? '0',
                        variant: StoreStatVariant.glass,
                        accentValue: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StoreStatItem(
                        title: 'products',
                        value: '${store.productsCount ?? 0}',
                        variant: StoreStatVariant.glass,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StoreStatItem(
                        title: 'customers',
                        value: '${store.customersCount ?? 0}',
                        variant: StoreStatVariant.glass,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _StoreCta(
                        label: store.isFollowed
                            ? LanguageProvider.translate('buttons', 'unfollow')
                            : LanguageProvider.translate('buttons', 'follow'),
                        filled: true,
                        onTap: () => provider.updateFollow(store.id),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _StoreCta(
                        label: LanguageProvider.translate(
                          'global',
                          'chat_vendor',
                        ),
                        filled: false,
                        onTap: () {
                          context.read<MessageProvider>().goToMessagePage(
                                orderId: 0,
                                storeId: store.id,
                              );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context, StoreDetailsProvider provider) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColor.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: Text(
                  LanguageProvider.translate('buttons', 'report'),
                ),
                onTap: () {
                  navPop();
                  reportDialog(
                    title: LanguageProvider.translate('global', 'complaint'),
                    type: 'vendor',
                    id: store.vendor?.id ?? 0,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.block_outlined),
                title: Text(
                  LanguageProvider.translate('buttons', 'block'),
                ),
                onTap: () {
                  navPop();
                  provider.confirmBlock(vendorId: store.vendor?.id ?? 0);
                },
              ),
              ListTile(
                leading: SvgWidget(svg: AppImages.share, width: 22),
                title: Text(
                  LanguageProvider.translate('settings', 'share'),
                ),
                onTap: () async {
                  navPop();
                  final url = '${Constants.baseUri}store?id=${store.id}';
                  await Share.share(
                    "${LanguageProvider.translate('settings', 'share_store_description').replaceFirst('*name*', store.vendor?.name ?? store.name)}\n$url",
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StoreCta extends StatelessWidget {
  const _StoreCta({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColor.limeColor : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: filled
                ? null
                : Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 1.2,
                  ),
          ),
          child: Text(
            label,
            style: TextStyleClass.smallStyle(
              color: filled ? AppColor.deepColor : Colors.white,
            ).copyWith(fontWeight: FontWeight.w800, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
