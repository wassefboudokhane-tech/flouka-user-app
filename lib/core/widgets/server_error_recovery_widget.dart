import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/recovery_card_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';

class ServerErrorRecoveryWidget extends StatelessWidget {
  const ServerErrorRecoveryWidget({
    super.key,
    required this.incidentRef,
    this.message,
  });

  final String incidentRef;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return RecoveryCardWidget(
      section: 'recovery',
      titleKey: 'server_error_title',
      preservedKey: 'server_error_preserved',
      actionKey: 'server_error_action',
      onAction: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message != null && message!.isNotEmpty)
            Text(message!, style: TextStyleClass.captionStyle()),
          const SizedBox(height: 8),
          Text(
            LanguageProvider.translate('recovery', 'server_error_ref')
                .replaceAll('*ref*', incidentRef),
            style: TextStyleClass.captionStyle(color: AppColor.deepColor)
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
