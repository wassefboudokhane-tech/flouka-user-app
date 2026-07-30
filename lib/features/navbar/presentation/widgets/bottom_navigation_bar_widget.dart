import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/features/reels/presentation/providers/video_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../provider/nav_bar_provider.dart';
import 'bottom_nav_bar_item_widget.dart';

class CustomBottomNavBarWidget extends StatelessWidget {
  const CustomBottomNavBarWidget({super.key});

  static const double _fabSize = 56;
  static const double _fabHole = 56;

  @override
  Widget build(BuildContext context) {
    return Consumer<NavBarProvider>(
      builder: (context, nav, child) {
        return SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColor.borderColor)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageGutter,
                    10,
                    AppSpacing.pageGutter,
                    10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      nav.bottomNavigationBarItemEntity.length,
                      (index) {
                        if (index == 2) {
                          return const SizedBox(width: _fabHole);
                        }
                        return BottomNavBarItemWidget(
                          bottomNaBarEntity:
                              nav.bottomNavigationBarItemEntity[index],
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: -18,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<VideoProvider>(
                          Constants.globalContext(),
                          listen: false,
                        ).goToVideosPage();
                      },
                      child: Container(
                        width: _fabSize,
                        height: _fabSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColor.deepColor,
                              AppColor.primaryColor,
                            ],
                          ),
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.primaryColor
                                  .withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
