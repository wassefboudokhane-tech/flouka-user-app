import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/app_images.dart';
import 'package:flouka/core/helper_function/location.dart';
import 'package:flouka/core/widgets/flouka_primary_button.dart';
import 'package:flouka/features/address/presentation/providers/address_details_provider.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/navbar/presentation/provider/nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

/// Prompt to set a primary address after signup — no decorative map art.
class SelectDefaultAddressPage extends StatelessWidget {
  const SelectDefaultAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Image.asset(AppImages.logo, width: 112),
              const Spacer(),
              Text(
                LanguageProvider.translate('address', 'ask_address'),
                style: TextStyleClass.normalStyle(color: AppColor.inkColor)
                    .copyWith(fontSize: 15, height: 1.45),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final LatLng? current = await determinePosition();
                        if (!context.mounted) return;
                        if (current != null) {
                          Provider.of<AuthProvider>(context, listen: false)
                              .setLatLng(current);
                        }
                        Provider.of<NavBarProvider>(context, listen: false)
                            .goToNavView();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.deepColor,
                        side: BorderSide(color: AppColor.borderColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                      child: Text(
                        LanguageProvider.translate('on_boarding', 'skip'),
                        style: TextStyleClass.smallStyle(color: AppColor.deepColor)
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FloukaPrimaryButton(
                      onTap: () {
                        Provider.of<AddressDetailsProvider>(
                          context,
                          listen: false,
                        ).goToAddressDetailsPage(firstAddress: true);
                      },
                      text: 'add_new_address',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
