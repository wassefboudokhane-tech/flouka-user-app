import 'package:app_links/app_links.dart';
import 'package:flouka/features/products/presentation/providers/products_details_provider.dart';
import 'package:flouka/features/stores/presentation/providers/store_details_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../creator_attribution.dart';
import '../helper_function/api.dart';
import '../helper_function/convert.dart';
import '../../injection_container.dart';

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
    // A shared creator link credits that creator for the next order.
    CreatorAttributionStore.capture(parseCreatorRef(uri));
    final target = parseDeepLink(uri);
    // ...and counts as a click on that creator's link. Best effort.
    final click = creatorClickPayload(
      uri,
      productId: target?.kind == DeepLinkKind.product ? target!.id : null,
    );
    if (click != null) {
      sl<ApiHandel>().post('track_click', click).then((_) {}, onError: (_) {});
    }
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
