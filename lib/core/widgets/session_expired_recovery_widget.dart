import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/core/network/connectivity_status_provider.dart';
import 'package:flouka/core/widgets/recovery_card_widget.dart';
import 'package:flouka/features/auth/presentation/views/login_view.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionExpiredRecoveryWidget extends StatelessWidget {
  const SessionExpiredRecoveryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RecoveryCardWidget(
      section: 'recovery',
      titleKey: 'session_expired_title',
      preservedKey: 'session_expired_preserved',
      actionKey: 'session_expired_action',
      onAction: () {
        context.read<ConnectivityStatusProvider>().clearSessionExpired();
        navP(const LoginView());
      },
      child: Text(
        LanguageProvider.translate('recovery', 'session_expired_hint'),
        style: TextStyleClass.captionStyle(color: AppColor.mutedColor),
      ),
    );
  }
}
