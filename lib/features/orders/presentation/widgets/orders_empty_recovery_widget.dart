import 'package:flouka/core/widgets/recovery_card_widget.dart';
import 'package:flouka/features/navbar/presentation/provider/nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersEmptyRecoveryWidget extends StatelessWidget {
  const OrdersEmptyRecoveryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RecoveryCardWidget(
      section: 'recovery',
      titleKey: 'orders_empty_title',
      preservedKey: 'orders_empty_preserved',
      actionKey: 'orders_empty_action',
      onAction: () {
        Provider.of<NavBarProvider>(context, listen: false).changeIndex(0);
      },
    );
  }
}
