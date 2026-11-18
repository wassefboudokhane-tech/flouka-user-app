import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/features/home/presentation/pages/become_creator_page.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';

/// “Les meilleures choses se partagent” — opens the creator application.
class HomeShareBanner extends StatelessWidget {
  const HomeShareBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pageGutter, 18, AppSpacing.pageGutter, 8),
      child: Container(
        color: AppColor.limeColor,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LanguageProvider.translate('home', 'share_claim'),
              style: TextStyleClass.semiHeadStyle(color: AppColor.inkColor).copyWith(
                fontWeight: FontWeight.w300,
                fontSize: 28,
                height: 1.12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              LanguageProvider.translate('home', 'share_text'),
              style: TextStyleClass.smallStyle(color: AppColor.mutedColor).copyWith(height: 1.45),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => navP(const BecomeCreatorPage()),
              style: FilledButton.styleFrom(
                backgroundColor: AppColor.deepColor,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              ),
              child: Text(LanguageProvider.translate('home', 'become_creator')),
            ),
          ],
        ),
      ),
    );
  }
}
