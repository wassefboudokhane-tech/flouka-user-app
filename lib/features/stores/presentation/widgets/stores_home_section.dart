import 'package:cached_network_image/cached_network_image.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/see_all_button.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/stores/presentation/providers/store_details_provider.dart';
import 'package:flouka/features/stores/presentation/providers/stores_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

/// Featured shops rail — mirrors web `FeaturedShopsRail`.
class StoresHomeSection extends StatelessWidget {
  const StoresHomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StoresProvider>();
    final stores = provider.homeStores;
    if (stores.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffE6DDF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  gradient: LinearGradient(
                    colors: [AppColor.limeColor, AppColor.primaryColor],
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  LanguageProvider.translate('home', 'retail_stores'),
                  style: TextStyleClass.normalStyle(color: AppColor.deepColor)
                      .copyWith(fontWeight: FontWeight.w800, fontSize: 16.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SeeAllButton(
                onPressed: () => context.read<StoresProvider>().goToPage(),
              ),
            ],
          ),
          SizedBox(height: 1.2.h),
          SizedBox(
            height: 16.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: stores.length,
              separatorBuilder: (_, __) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final store = stores[index];
                return InkWell(
                  onTap: () {
                    Provider.of<StoreDetailsProvider>(context, listen: false)
                        .goToStoreDetailsPage(store.id);
                  },
                  child: SizedBox(
                    width: (MediaQuery.sizeOf(context).width * 0.22)
                        .clamp(72.0, 120.0)
                        .toDouble(),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColor.limeColor.withValues(alpha: 0.75),
                              width: 2.5,
                            ),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(store.vendor.logo),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 0.8.h),
                        Text(
                          store.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyleClass.smallStyle(
                            color: AppColor.inkColor,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
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
