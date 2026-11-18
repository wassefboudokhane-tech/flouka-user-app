import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/creators/presentation/providers/creators_provider.dart';
import 'package:flouka/features/creators/presentation/widgets/creator_portrait.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// "Creators to follow" row on home. Hidden when there are no creators.
class HomeCreatorsRowWidget extends StatelessWidget {
  const HomeCreatorsRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreatorsProvider>();
    final creators = provider.creators;
    if (creators.isEmpty) return const SizedBox.shrink();

    const width = 132.0;
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageGutter,
            ),
            child: Text(
              LanguageProvider.translate('creators', 'follow_title'),
              style: TextStyleClass.railTitleStyle(color: AppColor.inkColor),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: width * 4 / 3 + 28,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageGutter,
              ),
              itemCount: creators.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final creator = creators[index];
                return Semantics(
                  button: true,
                  label: creator.name,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () => provider.openStorefront(creator),
                    child: SizedBox(
                      width: width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CreatorPortrait(creator: creator, width: width),
                          const SizedBox(height: 6),
                          Text(
                            creator.name.split(' ').first,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyleClass.captionStyle(
                              color: AppColor.inkColor,
                            ).copyWith(fontWeight: FontWeight.w500),
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
      ),
    );
  }
}
