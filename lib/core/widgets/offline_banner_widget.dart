import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/recovery_card_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';

class OfflineBannerWidget extends StatelessWidget {
  const OfflineBannerWidget({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.deepColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  LanguageProvider.translate('recovery', 'offline_banner'),
                  style: TextStyleClass.captionStyle(
                    color: AppColor.limeColor,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (onRetry != null)
                TextButton(
                  onPressed: onRetry,
                  child: Text(
                    LanguageProvider.translate('recovery', 'offline_retry'),
                    style: TextStyleClass.captionStyle(
                      color: AppColor.backgroundColor,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
