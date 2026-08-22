import 'package:cached_network_image/cached_network_image.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/app_images.dart';
import 'package:flouka/features/cart/domain/entity/cart_entity.dart';
import 'package:flouka/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';

class CartVendorGroupWidget extends StatelessWidget {
  const CartVendorGroupWidget({super.key, required this.group});

  final CartVendorGroup group;

  @override
  Widget build(BuildContext context) {
    final store = group.store;
    final storeName = store?.name ?? LanguageProvider.translate('global', 'seller');
    final logo = store?.logo ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColor.borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: AppColor.softColor,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.vendorLogo),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: logo.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: logo,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Image.asset(
                              AppImages.logo,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(AppImages.logo, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    storeName,
                    style: TextStyleClass.smallStyle(color: AppColor.deepColor)
                        .copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  LanguageProvider.translate('cart', 'vendor_delivery'),
                  style: TextStyleClass.captionStyle(color: AppColor.mutedColor)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          for (var i = 0; i < group.items.length; i++) ...[
            CartItemWidget(cartEntity: group.items[i]),
            if (i < group.items.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: AppColor.borderColor,
                indent: AppSpacing.pageGutter,
                endIndent: AppSpacing.pageGutter,
              ),
          ],
        ],
      ),
    );
  }
}
