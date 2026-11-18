import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/creator_social.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/domain/entity/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// "Ils l'ont filmé": creators' videos of this product, opened where they
/// were posted (Flouka stores no video).
class ProductCreatorVideosWidget extends StatelessWidget {
  const ProductCreatorVideosWidget({super.key, required this.videos});

  final List<ProductCreatorVideo> videos;

  @override
  Widget build(BuildContext context) {
    final playable = [
      for (final v in videos)
        if (safeExternalUri(v.videoUrl) case final uri?) (v, uri),
    ];
    if (playable.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                LanguageProvider.translate('products', 'creator_videos_title'),
                style: TextStyleClass.railTitleStyle(),
              ),
            ),
            Text(
              LanguageProvider.translate('products', 'creator_videos_count')
                  .replaceAll('*num*', '${playable.length}'),
              style: TextStyleClass.captionStyle(),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 116,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: playable.length,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (context, i) {
              final (video, uri) = playable[i];
              return Semantics(
                button: true,
                label: '${platformLabel(video.platform)} · ${video.creatorName}',
                child: InkWell(
                  onTap: () => launchUrl(uri, mode: LaunchMode.externalApplication),
                  child: Container(
                    width: 84,
                    color: i.isEven ? AppColor.inkColor : AppColor.deepColor,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                        const Spacer(),
                        Text(
                          video.creatorName.split(' ').first,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleClass.captionStyle(color: Colors.white)
                              .copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          platformLabel(video.platform),
                          style: TextStyleClass.captionStyle(color: Colors.white70)
                              .copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
