import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/app_lotties.dart';
import 'package:flouka/core/constants/constants.dart';
import 'package:flouka/core/helper_function/helper_function.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';

/// Success bottom sheet — deferred so it never opens while Navigator is locked.
///
/// Optional [onCheckout] shows a lime CTA to go to checkout / cart validate.
void successDialog({
  VoidCallback? then,
  String? msg,
  String? lottie,
  int? sec,
  VoidCallback? onCheckout,
}) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (!Constants.globalContext().mounted) return;
    _showSuccessSheet(
      then: then,
      msg: msg,
      lottie: lottie,
      autoCloseMs: sec ?? (onCheckout != null ? 5000 : 2500),
      onCheckout: onCheckout,
    );
  });
}

void _showSuccessSheet({
  VoidCallback? then,
  String? msg,
  String? lottie,
  required int autoCloseMs,
  VoidCallback? onCheckout,
}) {
  var sheetClosed = false;
  var goCheckout = false;

  void afterClose() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (goCheckout && onCheckout != null) {
        onCheckout();
        return;
      }
      then?.call();
    });
  }

  showModalBottomSheet<void>(
    context: Constants.globalContext(),
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: AppColor.backgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
      return Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.pageGutter,
          20,
          AppSpacing.pageGutter,
          16 + bottomInset,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              lottie ?? Lotties.success,
              fit: BoxFit.contain,
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 8),
            Text(
              LanguageProvider.translate('success', msg ?? 'success'),
              style: TextStyleClass.normalStyle(color: AppColor.inkColor)
                  .copyWith(fontWeight: FontWeight.w700, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (onCheckout != null) ...[
              SizedBox(
                width: double.infinity,
                height: AppSpacing.ctaHeight,
                child: Material(
                  color: AppColor.limeColor,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: InkWell(
                    onTap: () {
                      if (sheetClosed) return;
                      goCheckout = true;
                      sheetClosed = true;
                      Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: Center(
                      child: Text(
                        LanguageProvider.translate('cart', 'validate_order'),
                        style: TextStyleClass.buttonStyle(
                          color: AppColor.deepColor,
                        ).copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {
                  if (sheetClosed) return;
                  sheetClosed = true;
                  Navigator.of(context).pop();
                },
                child: Text(
                  LanguageProvider.translate('cart', 'continue_shopping'),
                  style: TextStyleClass.smallStyle(color: AppColor.mutedColor)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ] else
              SizedBox(
                width: double.infinity,
                height: AppSpacing.ctaHeight,
                child: Material(
                  color: AppColor.limeColor,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: InkWell(
                    onTap: () {
                      if (sheetClosed) return;
                      sheetClosed = true;
                      Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: Center(
                      child: Text(
                        LanguageProvider.translate('buttons', 'confirm'),
                        style: TextStyleClass.buttonStyle(
                          color: AppColor.deepColor,
                        ).copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    },
  ).whenComplete(() {
    sheetClosed = true;
    afterClose();
  });

  delay(autoCloseMs).then((_) {
    if (sheetClosed) return;
    final ctx = Constants.globalContext();
    if (!ctx.mounted) return;
    final nav = Navigator.of(ctx, rootNavigator: true);
    if (!nav.canPop()) return;
    sheetClosed = true;
    nav.pop();
  });
}
