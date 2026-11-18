import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/creators/presentation/providers/creators_provider.dart';
import 'package:flouka/features/creators/presentation/widgets/creator_portrait.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// "Acheter par créateur": large vertical portraits.
class HomeCreatorsRowWidget extends StatelessWidget {
  const HomeCreatorsRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreatorsProvider>();
    final creators = provider.creators;
    if (creators.isEmpty) return const SizedBox.shrink();

    const width = 156.0;
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LanguageProvider.translate('home', 'by_creator'),
                  style: TextStyleClass.railTitleStyle(color: AppColor.inkColor),
                ),
                const SizedBox(height: 4),
                Text(
                  LanguageProvider.translate('home', 'by_creator_text'),
                  style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: width * 4 / 3 + 26,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
              itemCount: creators.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final creator = creators[index];
                return Semantics(
                  button: true,
                  label: creator.name,
                  child: InkWell(
                    onTap: () => provider.openStorefront(creator),
                    child: SizedBox(
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CreatorPortrait(creator: creator, width: width),
                          const SizedBox(height: 6),
                          Text(
                            creator.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyleClass.smallStyle(color: AppColor.inkColor),
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
