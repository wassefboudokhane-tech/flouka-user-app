abstract final class PaymentResult {
  static const paid = 'paid';
  static const failed = 'failed';

  static String? fromUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.path.contains('callback')) return null;
    return switch (uri.queryParameters['status']) {
      'paid' => paid,
      'failed' => failed,
      _ => null,
    };
  }
}
