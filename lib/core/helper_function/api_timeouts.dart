/// Timeouts for [ApiHandel].
///
/// On web, [sendTimeout] registers an XHR upload listener and [connectTimeout]
/// aborts the request before a cross-origin POST finishes. Both showed up as
/// first-load Dio timeouts (including a 0s abort). The browser still applies
/// [receiveTimeout].
class ApiTimeouts {
  const ApiTimeouts({
    required this.connectTimeout,
    required this.sendTimeout,
    required this.receiveTimeout,
  });

  final Duration? connectTimeout;
  final Duration? sendTimeout;
  final Duration receiveTimeout;

  static const Duration connect = Duration(seconds: 10);
  static const Duration receive = Duration(seconds: 15);

  factory ApiTimeouts.forPlatform({required bool isWeb}) {
    if (isWeb) {
      return const ApiTimeouts(
        connectTimeout: null,
        sendTimeout: null,
        receiveTimeout: receive,
      );
    }
    return const ApiTimeouts(
      connectTimeout: connect,
      sendTimeout: receive,
      receiveTimeout: receive,
    );
  }
}
