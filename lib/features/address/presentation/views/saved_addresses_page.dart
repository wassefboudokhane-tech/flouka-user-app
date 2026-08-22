import 'package:dotted_border/dotted_border.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/app_lotties.dart';
import 'package:flouka/core/widgets/empty_animation.dart';
import 'package:flouka/core/widgets/flouka_screen_header.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/address_provider.dart';
import '../providers/map_provider.dart';
import '../widgets/saved_address_container_widget.dart';

class SavedAddressesPage extends StatelessWidget {
  const SavedAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressProvider>();
    final mapProvider = context.read<MapProvider>();
    final count = addressProvider.address?.length ?? 0;

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FloukaScreenHeader(
              title: LanguageProvider.translate('address', 'my_addresses'),
              badge: count > 0 ? '$count' : null,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => addressProvider.refresh(),
                child: Builder(
                  builder: (context) {
                    if (addressProvider.address == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (addressProvider.address!.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 48),
                          const Center(
                            child: EmptyAnimation(
                              gif: Lotties.address,
                              title: 'no_address',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              LanguageProvider.translate('global', 'no_address'),
                              style: TextStyleClass.smallStyle(
                                color: AppColor.mutedColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 4, bottom: 8),
                      itemCount: addressProvider.address!.length + 1,
                      itemBuilder: (context, index) {
                        if (index == addressProvider.address!.length) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.pageGutter,
                              4,
                              AppSpacing.pageGutter,
                              8,
                            ),
                            child: Text(
                              LanguageProvider.translate(
                                'address',
                                'max_note',
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyleClass.captionStyle(
                                color: AppColor.mutedColor,
                              ).copyWith(fontSize: 11.5, height: 1.4),
                            ),
                          );
                        }
                        return SavedAddressContainerWidget(
                          address: addressProvider.address![index],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageGutter,
                4,
                AppSpacing.pageGutter,
                16,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: mapProvider.goToMapPage,
                  borderRadius: BorderRadius.circular(16),
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      radius: const Radius.circular(16),
                      color: AppColor.primaryColor,
                      dashPattern: const [6, 4],
                      strokeWidth: 1.4,
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      height: AppSpacing.ctaHeight,
                      alignment: Alignment.center,
                      child: Text(
                        '+ ${LanguageProvider.translate('address', 'add_address')}',
                        style: TextStyleClass.buttonStyle(
                          color: AppColor.primaryColor,
                        ).copyWith(fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
