enum PendingAddressOperation { create, update }

/// Holds address payload while the user completes OTP.
class PendingAddressStore {
  static Map<String, dynamic>? data;
  static PendingAddressOperation operation = PendingAddressOperation.create;

  static bool get hasData => data != null && data!.isNotEmpty;

  static void save(
    Map<String, dynamic> value, {
    required PendingAddressOperation forOperation,
  }) {
    data = Map<String, dynamic>.from(value);
    operation = forOperation;
  }

  static void clear() {
    data = null;
    operation = PendingAddressOperation.create;
  }
}
