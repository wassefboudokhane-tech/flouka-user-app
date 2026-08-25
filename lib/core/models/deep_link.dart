import 'package:app_links/app_links.dart';
import 'package:flouka/features/products/presentation/providers/products_details_provider.dart';
import 'package:flouka/features/stores/presentation/providers/store_details_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../helper_function/convert.dart';

enum DeepLinkKind { store, product }

class DeepLinkTarget {
  final DeepLinkKind kind;
  final int id;

  const DeepLinkTarget(this.kind, this.id);
}

DeepLinkTarget? parseDeepLink(Uri? uri) {
  if (uri == null) return null;
  final id = convertStringToInt(uri.queryParameters['id']);
  if (id <= 0) return null;
  if (uri.pathSegments.contains('store')) {
    return DeepLinkTarget(DeepLinkKind.store, id);
  }
  if (uri.pathSegments.contains('product')) {
    return DeepLinkTarget(DeepLinkKind.product, id);
  }
  return null;
}

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final _appLinks = AppLinks();
  bool _initialized = false;

  void _handleUri(Uri? uri) {
    final target = parseDeepLink(uri);
    if (target == null) return;
    if (target.kind == DeepLinkKind.store) {
      Provider.of<StoreDetailsProvider>(
        Constants.globalContext(),
        listen: false,
      ).goToStoreDetailsPage(target.id);
    } else {
      Provider.of<ProductDetailsProvider>(
        Constants.globalContext(),
        listen: false,
      ).goToPage({'product_id': target.id});
    }
  }

  void init() {
    if (_initialized) return; // prevent reinit
    _initialized = true;

    // Listen for incoming links while app is running
    _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri);
    });

    // Handle initial link when app is opened from a link
    _appLinks.getInitialLink().then((uri) {
      _handleUri(uri);
    });
  }
}
