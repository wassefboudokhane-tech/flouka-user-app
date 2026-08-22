import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_theme.dart';
import 'package:flouka/core/constants/constants.dart';
import 'package:flouka/features/reels/presentation/providers/video_provider.dart';
import 'package:flouka/features/reels/presentation/views/reels_tab_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/helper_function/navigation.dart';

class VideosHomePage extends StatelessWidget {
  const VideosHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);
    final hasReels =
        videoProvider.reelItems != null && videoProvider.reelItems!.isNotEmpty;

    return AnnotatedRegion(
      value: lightBarColor(),
      child: Scaffold(
        extendBodyBehindAppBar: hasReels,
        extendBody: hasReels,
        appBar: hasReels
            ? null
            : AppBar(
                iconTheme: IconThemeData(color: AppColor.inkColor),
              ),
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              const ReelsTabContent(),
              if (hasReels)
                PositionedDirectional(
                  top: 4.h,
                  start: 3.w,
                  child: Container(
                    margin: EdgeInsets.all(1.5.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.inkColor.withValues(alpha: 0.3),
                    ),
                    child: Transform.scale(
                      scale: Constants.isTablet ? 2 : 1,
                      child: BackButton(
                        color: AppColor.backgroundColor,
                        onPressed: navPop,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
