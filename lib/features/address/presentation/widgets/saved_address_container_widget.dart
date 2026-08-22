import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/address_entity.dart';
import '../providers/address_details_provider.dart';
import '../providers/address_provider.dart';

class SavedAddressContainerWidget extends StatelessWidget {
  const SavedAddressContainerWidget({super.key, required this.address});

  final AddressEntity address;

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.read<AddressProvider>();
    final auth = context.read<AuthProvider>();
    final isDefault = address.isDefault == true;
    final label = address.addressName?.trim().isNotEmpty == true
        ? address.addressName!
        : LanguageProvider.translate('address', 'default_address_name');

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        0,
        AppSpacing.pageGutter,
        10,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDefault ? AppColor.primaryColor : AppColor.borderColor,
          width: isDefault ? 1.6 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 18,
                color: AppColor.primaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyleClass.smallStyle(color: AppColor.deepColor)
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
              if (isDefault)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColor.limeColor,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    LanguageProvider.translate('address', 'default_badge')
                        .toUpperCase(),
                    style: TextStyleClass.captionStyle(
                      color: AppColor.deepColor,
                    ).copyWith(fontWeight: FontWeight.w800, fontSize: 10),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            [
              if ((address.address ?? '').isNotEmpty) address.address!,
              if ((auth.userEntity?.name ?? '').isNotEmpty)
                auth.userEntity!.name!,
              if ((address.phone ?? '').isNotEmpty) address.phone!,
            ].join('\n'),
            style: TextStyleClass.captionStyle(color: AppColor.inkColor)
                .copyWith(fontSize: 12.5, height: 1.45, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: const Color(0xFF2F9E44),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  LanguageProvider.translate('address', 'deliverable'),
                  style: TextStyleClass.captionStyle(
                    color: const Color(0xFF2F9E44),
                  ).copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 4,
            children: [
              _ActionLink(
                label: LanguageProvider.translate('address', 'edit'),
                color: AppColor.primaryColor,
                onTap: () {
                  context
                      .read<AddressDetailsProvider>()
                      .goToAddressDetailsPage(addressEntity: address);
                },
              ),
              if (!isDefault)
                _ActionLink(
                  label: LanguageProvider.translate('address', 'delete'),
                  color: AppColor.DealColor,
                  onTap: () =>
                      addressProvider.showDeleteLocation(address.id!),
                ),
              if (!isDefault)
                _ActionLink(
                  label: LanguageProvider.translate(
                    'address',
                    'set_as_default',
                  ),
                  color: AppColor.deepColor,
                  bold: true,
                  onTap: () => addressProvider.setAsDefault(address),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionLink extends StatelessWidget {
  const _ActionLink({
    required this.label,
    required this.color,
    required this.onTap,
    this.bold = false,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          label,
          style: TextStyleClass.captionStyle(color: color).copyWith(
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            fontSize: 12.5,
          ),
        ),
      ),
    );
  }
}
