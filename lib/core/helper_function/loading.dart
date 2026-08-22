import 'package:flouka/core/config/app_color.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';

bool isLoadingStart = false;

/// Light blocking overlay — thin lime progress bar, no spinning circle.
void loading() {
  if (isLoadingStart) return;
  isLoadingStart = true;
  showDialog(
    context: Constants.globalContext(),
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.18),
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 3,
                  backgroundColor: AppColor.limeColor.withValues(alpha: 0.35),
                  color: AppColor.deepColor,
                ),
              ),
            ),
          ),
        ),
      );
    },
  ).then((value) {
    isLoadingStart = false;
  });
}

/// Closes the loading dialog only — never pops the underlying route.
void dismissLoading() {
  if (!isLoadingStart) return;
  final ctx = Constants.globalContext();
  if (!ctx.mounted) {
    isLoadingStart = false;
    return;
  }
  final nav = Navigator.of(ctx, rootNavigator: true);
  if (nav.canPop()) {
    nav.pop();
  } else {
    isLoadingStart = false;
  }
}
