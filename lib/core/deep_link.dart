/// Parses flouka.app (and custom scheme) URLs into in-app locations.
class FkDeepLink {
  const FkDeepLink({required this.kind, this.handle, this.slug, this.query});

  final FkDeepLinkKind kind;
  final String? handle;
  final String? slug;
  final String? query;

  String get location {
    switch (kind) {
      case FkDeepLinkKind.home:
        return '/';
      case FkDeepLinkKind.search:
        return query == null || query!.isEmpty ? '/search' : '/search?q=${Uri.encodeQueryComponent(query!)}';
      case FkDeepLinkKind.creator:
        return '/shop/${handle!}';
      case FkDeepLinkKind.collection:
        return '/shop/${handle!}/${slug!}';
      case FkDeepLinkKind.product:
        return '/p/${slug!}';
      case FkDeepLinkKind.brand:
        return '/marque/${slug!}';
      case FkDeepLinkKind.studio:
        return '/studio';
      case FkDeepLinkKind.unknown:
        return '/404';
    }
  }

  static const hosts = ['flouka.app', 'www.flouka.app'];

  static FkDeepLink parse(Uri uri) {
    final host = uri.host.toLowerCase();
    final isCustom = uri.scheme == 'flouka';
    final isApp = isCustom || hosts.contains(host);
    if (!isApp && uri.scheme != 'https' && uri.scheme != 'http') {
      return const FkDeepLink(kind: FkDeepLinkKind.unknown);
    }
    if (!isApp && uri.scheme.startsWith('http') && !hosts.contains(host)) {
      return const FkDeepLink(kind: FkDeepLinkKind.unknown);
    }

    final parts = <String>[
      if (isCustom && host.isNotEmpty) host,
      ...uri.pathSegments.where((s) => s.isNotEmpty),
    ];
    if (parts.isEmpty) return const FkDeepLink(kind: FkDeepLinkKind.home);

    final head = parts.first.toLowerCase();
    if (head == 'search' || head == 'recherche') {
      return FkDeepLink(kind: FkDeepLinkKind.search, query: uri.queryParameters['q']);
    }
    if (head == 'p' && parts.length >= 2) {
      return FkDeepLink(kind: FkDeepLinkKind.product, slug: parts[1]);
    }
    if ((head == 'marque' || head == 'marques' || head == 'brand') && parts.length >= 2) {
      return FkDeepLink(kind: FkDeepLinkKind.brand, slug: parts[1]);
    }
    if (head == 'studio' || head == 'createur') {
      return const FkDeepLink(kind: FkDeepLinkKind.studio);
    }
    if (head == 'shop' && parts.length >= 2) {
      final handle = parts[1];
      if (parts.length >= 3) {
        return FkDeepLink(kind: FkDeepLinkKind.collection, handle: handle, slug: parts[2]);
      }
      return FkDeepLink(kind: FkDeepLinkKind.creator, handle: handle);
    }
    return const FkDeepLink(kind: FkDeepLinkKind.unknown);
  }
}

enum FkDeepLinkKind { home, search, creator, collection, product, brand, studio, unknown }
