/// Creator attribution: remembers which creator sent the shopper so the order
/// can credit them. Last click wins, and the credit expires after [window].
class CreatorAttribution {
  final String ref;
  final DateTime capturedAt;

  const CreatorAttribution(this.ref, this.capturedAt);
}

final RegExp _creatorRefPattern = RegExp(r'^[A-Za-z0-9_.\-]{2,40}$');

/// Normalises a creator handle or code; returns null when it is not usable.
String? normalizeCreatorRef(String? raw) {
  if (raw == null) return null;
  var value = raw.trim();
  if (value.startsWith('@')) value = value.substring(1);
  if (!_creatorRefPattern.hasMatch(value)) return null;
  return value.toLowerCase();
}

/// Reads the creator from a shared link (`?creator=yasmine` or `?ref=yasmine`).
String? parseCreatorRef(Uri? uri) {
  if (uri == null) return null;
  return normalizeCreatorRef(
    uri.queryParameters['creator'] ?? uri.queryParameters['ref'],
  );
}

class CreatorAttributionStore {
  static const Duration window = Duration(days: 7);

  static CreatorAttribution? _current;

  /// Overridable clock so expiry can be tested.
  static DateTime Function() now = DateTime.now;

  /// Set from backend settings. Until the API accepts `creator_ref`, sending
  /// it would make order creation fail, so orders leave it out.
  static bool backendReady = false;

  /// Called after every change so the value can be persisted.
  static void Function(CreatorAttribution? value)? onChanged;

  /// Records a creator click. Returns false when [rawRef] is not a valid ref.
  static bool capture(String? rawRef) {
    final ref = normalizeCreatorRef(rawRef);
    if (ref == null) return false;
    _current = CreatorAttribution(ref, now());
    onChanged?.call(_current);
    return true;
  }

  /// The creator to credit right now, or null when none or expired.
  static String? activeRef() {
    final current = _current;
    if (current == null) return null;
    if (now().difference(current.capturedAt) > window) {
      clear();
      return null;
    }
    return current.ref;
  }

  /// The creator to send with an order, or null when none applies or the
  /// backend cannot take it yet.
  static String? refForOrder() => backendReady ? activeRef() : null;

  static void clear() {
    if (_current == null) return;
    _current = null;
    onChanged?.call(null);
  }

  /// Restores a persisted click without triggering [onChanged].
  static void restore(String? ref, int? capturedAtMs) {
    final normalized = normalizeCreatorRef(ref);
    if (normalized == null || capturedAtMs == null) {
      _current = null;
      return;
    }
    _current = CreatorAttribution(
      normalized,
      DateTime.fromMillisecondsSinceEpoch(capturedAtMs),
    );
  }
}
