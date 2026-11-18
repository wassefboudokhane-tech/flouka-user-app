import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';

/// The home promise: people pick, not an algorithm.
class HomeClaimWidget extends StatelessWidget {
  const HomeClaimWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final claim = TextStyleClass.semiHeadStyle(color: AppColor.inkColor).copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w300,
      height: 1.08,
      letterSpacing: -0.4,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pageGutter, 18, AppSpacing.pageGutter, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              style: claim,
              children: [
                TextSpan(text: '${LanguageProvider.translate('home', 'claim_1')} '),
                TextSpan(
                  text: LanguageProvider.translate('home', 'claim_em'),
                  style: claim.copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),
                ),
                TextSpan(text: LanguageProvider.translate('home', 'claim_2')),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            LanguageProvider.translate('home', 'claim_sub'),
            style: TextStyleClass.smallStyle(color: AppColor.mutedColor).copyWith(height: 1.45, fontSize: 15),
          ),
          const SizedBox(height: 10),
          Text(
            LanguageProvider.translate('home', 'trust_line'),
            style: TextStyleClass.captionStyle(color: AppColor.mutedColor),
          ),
        ],
      ),
    );
  }
}
