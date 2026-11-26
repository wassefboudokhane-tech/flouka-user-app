import 'package:url_launcher/url_launcher.dart';

/// Brand checkout lives on the brand site. Never in-app webview, never IAP.
class BrandLink {
  static const utmSource = 'flouka';

  static Uri tracked(Uri brandUri, {String? creatorHandle, String? productSlug}) {
    final params = Map<String, String>.from(brandUri.queryParameters);
    params.putIfAbsent('utm_source', () => utmSource);
    if (creatorHandle != null && creatorHandle.isNotEmpty) {
      params.putIfAbsent('utm_medium', () => 'creator');
      params.putIfAbsent('utm_campaign', () => creatorHandle);
      params.putIfAbsent('creator', () => creatorHandle);
    }
    if (productSlug != null && productSlug.isNotEmpty) {
      params.putIfAbsent('utm_content', () => productSlug);
    }
    return brandUri.replace(queryParameters: params);
  }

  /// Opens the brand URL in an external browser / Custom Tabs / Safari.
  static Future<bool> open(
    Uri brandUri, {
    String? creatorHandle,
    String? productSlug,
    Future<void> Function(Uri uri)? launcher,
  }) async {
    final uri = tracked(brandUri, creatorHandle: creatorHandle, productSlug: productSlug);
    if (launcher != null) {
      await launcher(uri);
      return true;
    }
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
