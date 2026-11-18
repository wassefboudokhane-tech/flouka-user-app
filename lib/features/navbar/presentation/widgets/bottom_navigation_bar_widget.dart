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
            // Over videos the dock floats; elsewhere it is a flat bar under a hairline.
            padding: frosted
                ? const EdgeInsetsDirectional.only(
                    start: AppSpacing.dockMarginH,
                    end: AppSpacing.dockMarginH,
                    bottom: AppSpacing.dockMarginBottom,
                  )
                : EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(frosted ? AppRadius.pill : 0),
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
                    borderRadius: BorderRadius.circular(frosted ? AppRadius.pill : 0),
                    border: frosted
                        ? Border.all(color: Colors.white.withValues(alpha: 0.18))
                        : Border(top: BorderSide(color: AppColor.borderColor)),
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
