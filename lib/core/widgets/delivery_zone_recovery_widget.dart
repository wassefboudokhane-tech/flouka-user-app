import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/recovery_card_widget.dart';
import 'package:flouka/features/address/presentation/providers/address_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/stores/presentation/providers/stores_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeliveryZoneRecoveryWidget extends StatelessWidget {
  const DeliveryZoneRecoveryWidget({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final stores = context.watch<StoresProvider>().homeStores.take(3).toList();

    return RecoveryCardWidget(
      section: 'recovery',
      titleKey: 'delivery_zone_title',
      preservedKey: 'delivery_zone_preserved',
      actionKey: 'delivery_zone_address',
      onAction: () {
        Provider.of<AddressProvider>(context, listen: false).goToAddressPage();
      },
      secondaryKey: 'delivery_zone_relay',
      onSecondary: () {
        Provider.of<AddressProvider>(context, listen: false).goToAddressPage();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: AppSpacing.deliveryMapPreviewHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xffE9E4DC), AppColor.canvasColor],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.borderColor),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    LanguageProvider.translate(
                      'recovery',
                      'delivery_zone_map',
                    ),
                    style: TextStyleClass.captionStyle(
                      color: AppColor.mutedColor,
                    ).copyWith(fontSize: 10.5, letterSpacing: 0.06),
                  ),
                ),
                Positioned(
                  left: -30,
                  top: 20,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.primaryColor.withValues(alpha: 0.45),
                        width: 2,
                      ),
                      color: AppColor.primaryColor.withValues(alpha: 0.07),
                    ),
                  ),
                ),
                Positioned(
                  right: 56,
                  top: 64,
                  child: Transform.rotate(
                    angle: -0.785398,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColor.DealColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(99),
                          topRight: Radius.circular(99),
                          bottomRight: Radius.circular(99),
                          bottomLeft: Radius.circular(2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.DealColor.withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (message != null && message!.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColor.DealColor, width: 1.5),
              ),
              child: Text(
                message!,
                style: TextStyleClass.smallStyle(color: AppColor.mutedColor)
                    .copyWith(height: 1.45),
              ),
            ),
          const SizedBox(height: 10),
          _RecoveryOption(
            highlighted: true,
            title: LanguageProvider.translate(
              'recovery',
              'delivery_zone_use_tunis',
            ),
            subtitle: LanguageProvider.translate(
              'recovery',
              'delivery_zone_use_tunis_sub',
            ),
            onTap: () {
              Provider.of<AddressProvider>(context, listen: false)
                  .goToAddressPage();
            },
          ),
          const SizedBox(height: 8),
          _RecoveryOption(
            title: LanguageProvider.translate('recovery', 'delivery_zone_relay'),
            subtitle: LanguageProvider.translate(
              'recovery',
              'delivery_zone_relay_sub',
            ),
            onTap: () {
              Provider.of<AddressProvider>(context, listen: false)
                  .goToAddressPage();
            },
          ),
          const SizedBox(height: 8),
          _RecoveryOption(
            title: LanguageProvider.translate('recovery', 'delivery_zone_alert'),
            subtitle: LanguageProvider.translate(
              'recovery',
              'delivery_zone_alert_sub',
            ),
            onTap: () {},
          ),
          if (stores.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              LanguageProvider.translate('recovery', 'delivery_zone_vendors'),
              style: TextStyleClass.smallStyle(color: AppColor.mutedColor)
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Row(
              children: stores
                  .map(
                    (store) => Expanded(
                      child: Container(
                        height: 52,
                        margin: const EdgeInsetsDirectional.only(end: 8),
                        decoration: BoxDecoration(
                          color: AppColor.softColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.borderColor),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          store.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleClass.captionStyle(
                            color: AppColor.deepColor,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _RecoveryOption extends StatelessWidget {
  const _RecoveryOption({
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlighted = false,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlighted ? AppColor.softColor : AppColor.backgroundColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: highlighted ? AppColor.borderColor : AppColor.borderColor,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: highlighted ? AppColor.limeColor : AppColor.softColor,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Icon(
                  highlighted ? Icons.home_outlined : Icons.inventory_2_outlined,
                  size: 14,
                  color: AppColor.deepColor,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyleClass.smallStyle(color: AppColor.inkColor)
                          .copyWith(fontWeight: FontWeight.w700, fontSize: 12.5),
                    ),
                    Text(
                      subtitle,
                      style: TextStyleClass.captionStyle(
                        color: AppColor.mutedColor,
                      ).copyWith(fontSize: 11, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
