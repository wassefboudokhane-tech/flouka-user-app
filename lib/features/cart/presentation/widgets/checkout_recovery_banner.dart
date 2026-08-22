import 'package:flouka/core/network/recovery_error_handler.dart';
import 'package:flouka/core/widgets/delivery_zone_recovery_widget.dart';
import 'package:flouka/core/widgets/server_error_recovery_widget.dart';
import 'package:flouka/core/widgets/session_expired_recovery_widget.dart';
import 'package:flouka/features/cart/presentation/providers/checkout_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutRecoveryBanner extends StatelessWidget {
  const CheckoutRecoveryBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final recovery = context.watch<CheckoutProvider>().activeRecovery;
    if (recovery == null || recovery.type == RecoveryErrorType.none) {
      return const SizedBox.shrink();
    }
    if (recovery.type == RecoveryErrorType.stock) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: switch (recovery.type) {
        RecoveryErrorType.deliveryZone => DeliveryZoneRecoveryWidget(
            message: recovery.message,
          ),
        RecoveryErrorType.sessionExpired => const SessionExpiredRecoveryWidget(),
        RecoveryErrorType.server => ServerErrorRecoveryWidget(
            incidentRef: recovery.incidentRef ?? RecoveryErrorHandler.generateIncidentRef(),
            message: recovery.message,
          ),
        RecoveryErrorType.offline => const SizedBox.shrink(),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
