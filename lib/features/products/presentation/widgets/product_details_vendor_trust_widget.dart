import 'package:cached_network_image/cached_network_image.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/domain/entity/product_entity.dart';
import 'package:flouka/features/stores/presentation/providers/store_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsVendorTrustWidget extends StatelessWidget {
  const ProductDetailsVendorTrustWidget({
    super.key,
    required this.store,
    this.rating,
  });

  final StoreEntity store;
  final double? rating;

  @override
  Widget build(BuildContext context) {
    final rate = rating ?? store.rate;
    final reviews = store.customersCount;
    final location = store.address;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 38,
                  height: 38,
                  color: AppColor.softColor,
                  child: store.logo.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: store.logo,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: TextStyleClass.normalStyle(
                        color: AppColor.inkColor,
                      ).copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        height: 1.2,
                      ),
                    ),
                    if (rate > 0 || location.isNotEmpty)
                      Text(
                        [
                          if (rate > 0)
                            '★ ${rate.toStringAsFixed(1).replaceAll('.', ',')}',
                          if (reviews > 0) '$reviews ${LanguageProvider.translate('global', 'all_reviews')}',
                          if (location.isNotEmpty) location,
                        ].join(' · '),
                        style: TextStyleClass.captionStyle(
                          color: AppColor.mutedColor,
                        ).copyWith(fontSize: 11.5, height: 1.3),
                      ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Provider.of<StoreDetailsProvider>(context, listen: false)
                      .goToStoreDetailsPage(store.id);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.deepColor,
                  side: BorderSide(color: AppColor.deepColor, width: 1.2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                child: Text(
                  LanguageProvider.translate('buttons', 'follow'),
                  style: TextStyleClass.captionStyle(color: AppColor.deepColor)
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 11.5),
                ),
              ),
            ],
          ),
          Divider(height: 23, color: AppColor.canvasColor),
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 320;
              final bullets = [
                LanguageProvider.translate('global', 'cod_badge'),
                LanguageProvider.translate('global', 'delivery_24_48'),
                LanguageProvider.translate('global', 'return_7_days'),
              ];
              if (narrow) {
                return Column(
                  children: [
                    for (var i = 0; i < bullets.length; i++) ...[
                      if (i > 0) const SizedBox(height: 8),
                      _TrustBullet(label: bullets[i]),
                    ],
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final label in bullets)
                    Expanded(child: _TrustBullet(label: label)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TrustBullet extends StatelessWidget {
  const _TrustBullet({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: AppColor.limeColor,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            label,
            softWrap: true,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyleClass.captionStyle(color: AppColor.mutedColor)
                .copyWith(fontWeight: FontWeight.w500, fontSize: 10, height: 1.25),
          ),
        ),
      ],
    );
  }
}
