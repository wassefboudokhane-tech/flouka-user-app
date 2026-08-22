import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/constants/app_lotties.dart';
import 'package:flouka/core/widgets/empty_animation.dart';
import 'package:flouka/core/widgets/loading_animation_widget.dart';
import 'package:flouka/features/reels/presentation/providers/video_provider.dart';
import 'package:flouka/features/reels/presentation/widgets/list_videos_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

/// Reels feed body embedded in [ExploreView] (no back button).
class ReelsTabContent extends StatelessWidget {
  const ReelsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        videoProvider.refresh();
      },
      child: Builder(
        builder: (context) {
          if (videoProvider.reelItems == null) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 50.h,
                  child: Center(
                    child: LoadingAnimationWidget(
                      gif: Lotties.videoAnimation,
                      width: 100.w,
                      height: 40.h,
                      topPadding: 0,
                    ),
                  ),
                ),
              ],
            );
          }
          if (videoProvider.reelItems!.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(
                  height: 320,
                  child: EmptyAnimation(title: '', gif: Lotties.noSearch),
                ),
              ],
            );
          }
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xff2A0247),
                  const Color(0xff4A0A7A),
                  const Color(0xff1a0130),
                ],
              ),
            ),
            child: const ListVideosWidget(),
          );
        },
      ),
    );
  }
}
