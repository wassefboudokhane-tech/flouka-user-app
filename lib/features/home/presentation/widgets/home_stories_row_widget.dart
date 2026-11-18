import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/widgets/flouka_network_image.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/stories/domain/entity/story_entity.dart';
import 'package:flouka/features/stories/presentation/provider/story_provider.dart';
import 'package:flouka/features/stories/presentation/views/stories_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Horizontal vendor stories row for home (58px circles, lime→violet ring).
class HomeStoriesRowWidget extends StatelessWidget {
  const HomeStoriesRowWidget({super.key});

  bool _hasUnwatched(StoryEntity story) {
    return story.stories.any((s) => !s.isWatched);
  }

  @override
  Widget build(BuildContext context) {
    final storyProvider = context.watch<StoryProvider>();
    final stories = storyProvider.data;
    if (stories == null || stories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: AppSpacing.storyCircleSize + 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final story = stories[index];
          final unwatched = _hasUnwatched(story);
          return _HomeStoryItem(
            story: story,
            unwatched: unwatched,
          );
        },
      ),
    );
  }
}

class _HomeStoryItem extends StatelessWidget {
  const _HomeStoryItem({
    required this.story,
    required this.unwatched,
  });

  final StoryEntity story;
  final bool unwatched;

  @override
  Widget build(BuildContext context) {
    const size = AppSpacing.storyCircleSize;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoriesView(story: story),
          ),
        );
      },
      child: SizedBox(
        width: size + 4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size,
              height: size,
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: unwatched
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColor.limeColor,
                          AppColor.primaryColor,
                        ],
                      )
                    : null,
                color: unwatched ? null : AppColor.borderColor,
              ),
              child: Container(
                margin: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.softColor,
                  border: Border.all(color: AppColor.canvasColor, width: 2),
                  image: DecorationImage(
                    image: floukaImageProvider(story.logo),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              story.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyleClass.captionStyle(
                color: unwatched ? AppColor.navColor : AppColor.mutedColor,
              ).copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 10.5,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
