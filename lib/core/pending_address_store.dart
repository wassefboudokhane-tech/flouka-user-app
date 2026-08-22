/// Holds address payload while the user completes OTP before create_address.
class PendingAddressStore {
  static Map<String, dynamic>? data;

  static bool get hasData => data != null && data!.isNotEmpty;

  static void clear() => data = null;
}
