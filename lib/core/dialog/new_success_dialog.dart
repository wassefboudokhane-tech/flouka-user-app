import 'package:flouka/core/dialog/success_dialog.dart';
import 'package:flutter/foundation.dart';

/// Alias kept for call sites — same safe bottom sheet as [successDialog].
void newSuccessDialog({
  VoidCallback? then,
  String? msg,
  String? lottie,
  int? sec,
}) {
  successDialog(
    then: then,
    msg: msg,
    lottie: lottie,
    sec: sec ?? 4000,
  );
}
