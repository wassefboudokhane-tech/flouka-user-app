import 'dart:ui';

import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_shadow.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/features/navbar/presentation/provider/nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bottom_nav_bar_item_widget.dart';

class CustomBottomNavBarWidget extends StatelessWidget {
  const CustomBottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavBarProvider>(
      builder: (context, nav, child) {
        final frosted = nav.useFrostedDock;

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: AppSpacing.dockMarginH,
              end: AppSpacing.dockMarginH,
              bottom: AppSpacing.dockMarginBottom,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: frosted ? 14 : 0,
                  sigmaY: frosted ? 14 : 0,
                ),
                child: Container(
                  height: AppSpacing.dockBarHeight,
                  decoration: BoxDecoration(
                    color: frosted
                        ? Colors.white.withValues(alpha: 0.12)
                        : AppColor.backgroundColor,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(
                      color: frosted
                          ? Colors.white.withValues(alpha: 0.18)
                          : AppColor.borderColor,
                    ),
                    boxShadow: frosted ? null : AppShadow.dock,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (final item in nav.bottomNavigationBarItemEntity)
                        BottomNavBarItemWidget(
                          bottomNaBarEntity: item,
                          frosted: frosted,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
