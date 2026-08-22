import 'package:flouka/features/navbar/presentation/provider/nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/app_color.dart';
import '../../../../core/config/app_radius.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/config/app_styles.dart';
import '../../../../core/widgets/svg_widget.dart';
import '../../domain/entities/bottom_nav_bar_entity.dart';

class BottomNavBarItemWidget extends StatelessWidget {
  const BottomNavBarItemWidget({
    super.key,
    required this.bottomNaBarEntity,
    this.frosted = false,
  });
  final BottomNaBarEntity bottomNaBarEntity;
  final bool frosted;

  @override
  Widget build(BuildContext context) {
    final navBarProvider = Provider.of<NavBarProvider>(context, listen: false);
    final active = navBarProvider.currentIndex == bottomNaBarEntity.index;

    Color iconColor;
    Color labelColor;
    Color? pillColor;

    if (frosted) {
      pillColor = active ? AppColor.limeColor : Colors.transparent;
      iconColor = active
          ? AppColor.deepColor
          : Colors.white.withValues(alpha: 0.55);
      labelColor = active
          ? Colors.white
          : Colors.white.withValues(alpha: 0.55);
    } else {
      pillColor = active ? AppColor.deepColor : Colors.transparent;
      iconColor = active ? AppColor.limeColor : AppColor.mutedColor;
      labelColor = active ? AppColor.deepColor : AppColor.mutedColor;
    }

    return InkWell(
      onTap: () {
        navBarProvider.changeIndex(bottomNaBarEntity.index);
      },
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSpacing.navActivePillW,
            height: AppSpacing.navActivePillH,
            decoration: BoxDecoration(
              color: pillColor,
              borderRadius:
                  BorderRadius.circular(AppSpacing.navActivePillRadius),
            ),
            alignment: Alignment.center,
            child: SvgWidget(
              width: 21,
              svg: bottomNaBarEntity.svgImage,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            bottomNaBarEntity.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyleClass.captionStyle(color: labelColor).copyWith(
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              fontSize: 10,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
