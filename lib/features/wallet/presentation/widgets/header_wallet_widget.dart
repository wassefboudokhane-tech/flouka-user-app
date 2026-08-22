import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/app_color.dart';
import '../../../../core/config/app_radius.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/config/app_styles.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/helper_function/convert.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/wallet_provider.dart';

class HeaderWalletWidget extends StatelessWidget {
  const HeaderWalletWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    final ops = walletProvider.myOperations ?? const [];

    double cashback = 0;
    var pendingRefunds = 0;
    for (final op in ops) {
      final amount = convertDataToDouble(op.price);
      if (op.operation == 'earn') {
        cashback += amount;
      }
      if (op.operation == 'refund') {
        pendingRefunds += 1;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(
            AppSpacing.pageGutter,
            0,
            AppSpacing.pageGutter,
            12,
          ),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColor.deepColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LanguageProvider.translate('global', 'your_credit'),
                style: TextStyleClass.captionStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                ).copyWith(fontWeight: FontWeight.w500, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${authProvider.userEntity?.wallet ?? 0}',
                    style: TextStyleClass.headStyle(color: Colors.white)
                        .copyWith(fontSize: 36, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    LanguageProvider.translate('global', 'currency'),
                    style: TextStyleClass.smallStyle(color: AppColor.limeColor)
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: AppColor.limeColor,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: InkWell(
                        onTap: walletProvider.showChargeSheet,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: SizedBox(
                          height: 44,
                          child: Center(
                            child: Text(
                              LanguageProvider.translate('wallet', 'recharge'),
                              style: TextStyleClass.captionStyle(
                                color: AppColor.deepColor,
                              ).copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: InkWell(
                        onTap: () {
                          showToast(
                            LanguageProvider.translate(
                              'wallet',
                              'withdraw_soon',
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            LanguageProvider.translate('wallet', 'withdraw'),
                            style: TextStyleClass.captionStyle(
                              color: Colors.white,
                            ).copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageGutter,
            0,
            AppSpacing.pageGutter,
            12,
          ),
          child: Row(
            children: [
              Expanded(
                child: _WalletStatCard(
                  value: cashback > 0
                      ? '+${formatPrice(cashback)}'
                      : '+0',
                  label: LanguageProvider.translate(
                    'wallet',
                    'cashback_earned',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _WalletStatCard(
                  value: '$pendingRefunds',
                  label: LanguageProvider.translate(
                    'wallet',
                    'pending_refunds',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WalletStatCard extends StatelessWidget {
  const _WalletStatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyleClass.semiHeadStyle(color: AppColor.deepColor)
                .copyWith(fontSize: 20, fontWeight: FontWeight.w800, height: 1),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyleClass.captionStyle(color: AppColor.mutedColor)
                .copyWith(fontSize: 11, height: 1.3),
          ),
        ],
      ),
    );
  }
}
