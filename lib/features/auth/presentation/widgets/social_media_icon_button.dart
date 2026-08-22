import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/social_auth_entity.dart';

class SocialMediaIconButton extends StatelessWidget {
  const SocialMediaIconButton({super.key, required this.socialAuthEntity});

  final SocialAuthEntity socialAuthEntity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: socialAuthEntity.onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageGutter,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: AppColor.borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(socialAuthEntity.image, width: 22, height: 22),
              const SizedBox(width: 12),
              Text(
                LanguageProvider.translate("auth", socialAuthEntity.text),
                style: TextStyleClass.normalStyle(color: AppColor.inkColor)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
