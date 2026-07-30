import 'package:cached_network_image/cached_network_image.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/app_images.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/settings_provider.dart';
import '../widgets/settings_action_buttons.dart';
import '../widgets/settings_section_container.dart';
import '../widgets/settings_section_title.dart';
import '../widgets/settings_widget.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<AuthProvider>();
    final user = profileProvider.userEntity;
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final image = user?.image;
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.pageGutter,
                top + 16,
                AppSpacing.pageGutter,
                28,
              ),
              decoration: BoxDecoration(
                color: AppColor.deepColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    LanguageProvider.translate('settings', 'title'),
                    style: TextStyleClass.headStyle(color: Colors.white)
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    backgroundImage: image == null
                        ? const AssetImage(AppImages.logo)
                        : CachedNetworkImageProvider(image),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.name ??
                        LanguageProvider.translate('settings', 'hi_guest'),
                    style: TextStyleClass.semiHeadStyle(color: Colors.white)
                        .copyWith(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (user?.phone != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      user?.phone ?? '',
                      style: TextStyleClass.smallStyle().copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageGutter,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (settingsProvider.accountSettings.isNotEmpty) ...[
                    SettingsSectionTitle(
                      title: LanguageProvider.translate(
                        'settings',
                        'account_settings',
                      ),
                    ),
                    SettingsSectionContainer(
                      children: List.generate(
                        settingsProvider.accountSettings.length,
                        (index) => SettingsWidget(
                          data: settingsProvider.accountSettings[index],
                          last: index ==
                              settingsProvider.accountSettings.length - 1,
                        ),
                      ),
                    ),
                  ],
                  SettingsSectionTitle(
                    title: LanguageProvider.translate(
                      'settings',
                      'general_settings',
                    ),
                  ),
                  SettingsSectionContainer(
                    children: List.generate(
                      settingsProvider.generalSettings.length,
                      (index) {
                        return SettingsWidget(
                          data: settingsProvider.generalSettings[index],
                          last: index ==
                              settingsProvider.generalSettings.length - 1,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  SettingsActionButtons(authProvider: profileProvider),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
