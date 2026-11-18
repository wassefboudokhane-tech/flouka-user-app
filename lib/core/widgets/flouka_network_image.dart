import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Product photos on the web must use [NetworkImage].
///
/// [CachedNetworkImageProvider] fetches bytes with XHR. The image host does
/// not send CORS headers, so those requests finish with HTTP status 0.
/// [NetworkImage] can still paint the photo from an HTML image element.
ImageProvider floukaImageProvider(
  String url, {
  bool? web,
}) {
  final onWeb = web ?? kIsWeb;
  if (onWeb) {
    return NetworkImage(url);
  }
  return CachedNetworkImageProvider(url);
}

/// Shopper photo that stays visible when the image host omits CORS headers.
class FloukaNetworkImage extends StatelessWidget {
  const FloukaNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.error,
  });

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? error;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: floukaImageProvider(url),
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, exception, stackTrace) =>
          error ?? const SizedBox.shrink(),
    );
  }
}
