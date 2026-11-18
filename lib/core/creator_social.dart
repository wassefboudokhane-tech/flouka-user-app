/// Creator social accounts and publication links. Pure, so it can be tested.
final RegExp _username = RegExp(r'^[A-Za-z0-9._]{1,30}$');

/// Public profile URL for an Instagram or TikTok username, or null.
String? creatorSocialUrl(String network, String? username) {
  if (username == null || !_username.hasMatch(username)) return null;
  switch (network) {
    case 'instagram':
      return 'https://www.instagram.com/$username/';
    case 'tiktok':
      return 'https://www.tiktok.com/@$username';
  }
  return null;
}

/// Only http(s) links are ever opened.
Uri? safeExternalUri(String? url) {
  if (url == null) return null;
  final uri = Uri.tryParse(url.trim());
  if (uri == null || !(uri.scheme == 'https' || uri.scheme == 'http') || uri.host.isEmpty) {
    return null;
  }
  return uri;
}

String platformLabel(String? platform) {
  switch (platform) {
    case 'instagram':
      return 'Instagram';
    case 'tiktok':
      return 'TikTok';
    case 'youtube':
      return 'YouTube';
    case 'facebook':
      return 'Facebook';
  }
  return 'Video';
}

/// The creator's page on the website, with their ref so the share credits them.
String creatorShareUrl(int id, String handle) =>
    'https://flouka.tn/creators/$id?creator=${Uri.encodeQueryComponent(handle)}';
