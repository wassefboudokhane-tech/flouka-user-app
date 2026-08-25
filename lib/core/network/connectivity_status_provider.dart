import 'package:flutter/material.dart';

class ConnectivityStatusProvider extends ChangeNotifier {
  bool isOffline = false;
  bool sessionExpired = false;

  void markOffline() {
    if (!isOffline) {
      isOffline = true;
      notifyListeners();
    }
  }

  void markOnline() {
    if (isOffline) {
      isOffline = false;
      notifyListeners();
    }
  }

  void markSessionExpired() {
    sessionExpired = true;
    notifyListeners();
  }

  void clearSessionExpired() {
    sessionExpired = false;
    notifyListeners();
  }

  Future<void> retryLastAction(Future<void> Function() retryAction) async {
    await retryAction();
  }
}
