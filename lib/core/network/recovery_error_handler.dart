import 'package:flutter/material.dart';

enum RecoveryErrorType {
  none,
  offline,
  sessionExpired,
  deliveryZone,
  server,
  stock,
  coupon,
}

class RecoveryErrorInfo {
  const RecoveryErrorInfo({
    required this.type,
    this.message,
    this.incidentRef,
  });

  final RecoveryErrorType type;
  final String? message;
  final String? incidentRef;
}

abstract class RecoveryErrorHandler {
  static String generateIncidentRef() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return 'FK-${now.toRadixString(36).toUpperCase().substring(now.toRadixString(36).length - 6)}';
  }

  static RecoveryErrorInfo parse(Object? error, {String? message}) {
    final text = (message ?? error.toString()).toLowerCase();

    if (_isOffline(error, text)) {
      return RecoveryErrorInfo(type: RecoveryErrorType.offline, message: message);
    }
    if (_isSessionExpired(text)) {
      return RecoveryErrorInfo(type: RecoveryErrorType.sessionExpired, message: message);
    }
    if (_isDeliveryZone(text)) {
      return RecoveryErrorInfo(type: RecoveryErrorType.deliveryZone, message: message);
    }
    if (_isStock(text)) {
      return RecoveryErrorInfo(type: RecoveryErrorType.stock, message: message);
    }
    if (text.contains('coupon') ||
        text.contains('promo') ||
        text.contains('code promo') ||
        text.contains('promo code')) {
      return RecoveryErrorInfo(type: RecoveryErrorType.coupon, message: message);
    }
    return RecoveryErrorInfo(
      type: RecoveryErrorType.server,
      message: message,
      incidentRef: generateIncidentRef(),
    );
  }

  static bool _isOffline(Object? error, String text) {
    if (text.contains('socket') ||
        text.contains('connection') ||
        text.contains('network') ||
        text.contains('timeout')) {
      return true;
    }
    return error.runtimeType.toString().contains('DioException') &&
        text.contains('null');
  }

  static bool _isSessionExpired(String text) =>
      text.contains('401') ||
      text.contains('unauthorized') ||
      text.contains('identifiants') ||
      text.contains('unauthenticated') ||
      (text.contains('token') && text.contains('expir'));

  static bool _isDeliveryZone(String text) =>
      text.contains('zone') ||
      text.contains('livraison') && text.contains('hors') ||
      text.contains('delivery') && text.contains('area') ||
      text.contains('address') && text.contains('deliver');

  static bool _isStock(String text) =>
      text.contains('stock') ||
      text.contains('rupture') ||
      text.contains('disponib');
}
