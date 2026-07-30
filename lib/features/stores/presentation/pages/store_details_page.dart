import 'package:cached_network_image/cached_network_image.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/constants/app_lotties.dart';
import 'package:flouka/core/dialog/report_dialog.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/core/widgets/loading_animation_widget.dart';
import 'package:flouka/features/reviews/presentation/providres/create_rate_provider.dart';
import 'package:flouka/features/reviews/presentation/views/create_review_page.dart';
import 'package:flouka/features/stores/presentation/providers/store_details_provider.dart';
import 'package:flouka/features/stores/presentation/providers/store_reviews_provider.dart';
import 'package:flouka/features/stores/presentation/widgets/stores_tabs_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/config/app_styles.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/config/app_radius.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/svg_widget.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entity/store_details_entity.dart';
import '../providers/stores_product_provider.dart';
import '../providers/stores_provider.dart';
import '../widgets/store_details_section.dart';

class StoreDetailsPage extends StatelessWidget {
  const StoreDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final StoreDetailsProvider storeDetailsProvider = Provider.of<StoreDetailsProvider>(context);
    final StoresProvider storesProvider = Provider.of<StoresProvider>(context);
    final StoresProductProvider storesProductProvider = Provider.of<StoresProductProvider>(context, listen: false);
    final StoreReviewsProvider storeReviewsProvider = Provider.of<StoreReviewsProvider>(context, listen: false);

    if(storesProvider.current==0){
      storesProductProvider.pagination();
    }else{
      storeReviewsProvider.pagination();
    }
    StoreDetailsEntity? storeDetailsEntity = storeDetailsProvider.storeDetailsEntity;
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      appBar: AppBar(
        title: Text(LanguageProvider.translate('home','store_details')),
        actions: storeDetailsEntity==null?null:[
          InkWell(onTap: (){
            reportDialog(title: LanguageProvider.translate("global", "complaint"),
                type: "vendor", id: storeDetailsEntity.vendor?.id??0);
          },child: Icon(Icons.flag_outlined,color: Colors.white,)),
          SizedBox(width: 5.w,),
          InkWell(onTap: (){
            storeDetailsProvider.confirmBlock(vendorId: storeDetailsEntity.vendor?.id??0);
          },child: Icon(Icons.block_outlined,color: Colors.white,)),
          SizedBox(width: 5.w,),
          // PopupMenuButton<ProductMenuAction>(
          //   icon: const Icon(Icons.more_vert),
          //   enabled: true,
          //   onSelected: (value) {
          //     switch (value) {
          //       case ProductMenuAction.report:
          //         reportDialog(title: LanguageProvider.translate("global", "complaint"),
          //             type: "vendor", id: storeDetailsEntity.vendor?.id??0);
          //         break;
          //
          //       case ProductMenuAction.blockVendor:
          //         storeDetailsProvider.confirmBlock(vendorId: storeDetailsEntity.vendor?.id??0);
          //         break;
          //     }
          //   },
          //   itemBuilder: (context) => [
          //     PopupMenuItem(
          //       value: ProductMenuAction.report,
          //       child: Row(
          //         children: [
          //           Icon(Icons.flag_outlined,color: Colors.black,),
          //           SizedBox(width: 12),
          //           Text(LanguageProvider.translate('buttons', 'report'),
          //           style: TextStyleClass.normalStyle(color: Colors.black),),
          //         ],
          //       ),
          //     ),
          //     PopupMenuItem(
          //       value: ProductMenuAction.blockVendor,
          //       child: Row(
          //         children: [
          //           Icon(Icons.block_outlined,color: Colors.black,),
          //           SizedBox(width: 12),
          //           Text(LanguageProvider.translate('buttons', 'block'),
          //           style: TextStyleClass.normalStyle(color: Colors.black),),
          //         ],
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
      body: Builder(
        builder: (context) {
          if (storeDetailsEntity == null) {
            return const Center(child: LoadingAnimationWidget(gif: Lotties.loading));
          }
          return RefreshIndicator(
            onRefresh: () async {
              storeDetailsProvider.refresh(storeDetailsEntity.id,);
              if(storesProvider.current==0){
                storesProductProvider.refresh();
              } else if(storesProvider.current==1){
                storeReviewsProvider.refresh();
              }
            },
            child: Stack(alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Positioned(top: 16,
                  left: 4, right: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CachedNetworkImage( imageUrl: storeDetailsEntity.vendor?.cover ?? "",
                      errorWidget: (context, url, error) { return const Icon(Icons.error); },
                      width: double.infinity, height: 160, fit: BoxFit.cover, ),
                  ),
                ),
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller:storesProvider.current==0 ? storesProductProvider.controller :storeReviewsProvider.controller,
                  child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter).copyWith(top: 120),
                    decoration:const BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppRadius.hero),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(children: [
                          CircleAvatar( radius: 34,backgroundColor: Colors.grey.shade300,
                            backgroundImage: CachedNetworkImageProvider(storeDetailsEntity.vendor!.logo), ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${storeDetailsEntity.name}',style:TextStyleClass.normalStyle(),maxLines: 2,
                                  ),
                                  Row(
                                    children: [
                                      SvgWidget(svg: AppImages.star, color: Colors.amber, width: 16),
                                      const SizedBox(width: 4),
                                      Text(storeDetailsEntity.avgRating.toString(),
                                        style: TextStyleClass.smallStyle().copyWith(fontWeight: FontWeight.bold),),
                                      const SizedBox(width: 4),
                                      Text("(${storeDetailsEntity.productsCount}) ${LanguageProvider.translate("global", "product")}",
                                        style: TextStyleClass.smallStyle(color: Colors.grey.shade700),),
                                    ],
                                  ),
                                  if (storeDetailsEntity.customersCount != null)
                                    Text(
                                      "${storeDetailsEntity.customersCount} ${LanguageProvider.translate('global', 'followers')}",
                                      style: TextStyleClass.smallStyle(color: Colors.grey.shade600),
                                    ),
                                  if (storeDetailsEntity.bio.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        storeDetailsEntity.bio,
                                        style: TextStyleClass.smallStyle(color: Colors.grey.shade600),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: Row(
                              children: [
                                Expanded(
                                  child: _StoreActionPill(
                                    label: LanguageProvider.translate('settings', 'share'),
                                    icon: AppImages.share,
                                    background: AppColor.softColor,
                                    foreground: AppColor.deepColor,
                                    borderColor: const Color(0xffE6DDF2),
                                    onTap: () async {
                                      final url =
                                          '${Constants.baseUri}store?id=${storeDetailsEntity.id}';
                                      final box =
                                          context.findRenderObject() as RenderBox?;
                                      await Share.share(
                                        "${LanguageProvider.translate('settings', 'share_store_description').replaceFirst("*name*", "${storeDetailsEntity.vendor!.name}")}\n$url",
                                        sharePositionOrigin: Constants.isTablet
                                            ? (box!.localToGlobal(Offset.zero) &
                                                box.size)
                                            : null,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _StoreActionPill(
                                    label: storeDetailsEntity.isFollowed
                                        ? LanguageProvider.translate(
                                            'buttons', 'unfollow')
                                        : LanguageProvider.translate(
                                            'buttons', 'follow'),
                                    background: storeDetailsEntity.isFollowed
                                        ? AppColor.deepColor
                                        : AppColor.limeColor,
                                    foreground: storeDetailsEntity.isFollowed
                                        ? Colors.white
                                        : AppColor.deepColor,
                                    onTap: () {
                                      storeDetailsProvider
                                          .updateFollow(storeDetailsEntity.id);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],),
                        const SizedBox(height: 10),
                        const StoreDetailsSection(),
                        const SizedBox(height: 16),
                        const StoresTabsWidget(),
                        const SizedBox(height: 16),
                      ],
                    ), ),
                ), ],
            ),
          );
        },
      ),
    );
  }
}

class _StoreActionPill extends StatelessWidget {
  const _StoreActionPill({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.icon,
    this.borderColor,
  });

  final String label;
  final String? icon;
  final Color background;
  final Color foreground;
  final Color? borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(999),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              SvgWidget(svg: icon!, color: foreground, width: 16),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyleClass.smallStyle(color: foreground)
                    .copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
