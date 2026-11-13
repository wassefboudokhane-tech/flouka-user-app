import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/creators/presentation/providers/creators_provider.dart';
import 'package:flouka/features/creators/presentation/widgets/creator_avatar.dart';
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

    const size = AppSpacing.storyCircleSize;
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
            height: size + 26,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageGutter,
              ),
              itemCount: creators.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final creator = creators[index];
                return Semantics(
                  button: true,
                  label: creator.name,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => provider.openStorefront(creator),
                    child: SizedBox(
                      width: size + 6,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CreatorAvatar(creator: creator, size: size),
                          const SizedBox(height: 5),
                          Text(
                            creator.name.split(' ').first,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyleClass.captionStyle(
                              color: AppColor.navColor,
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
