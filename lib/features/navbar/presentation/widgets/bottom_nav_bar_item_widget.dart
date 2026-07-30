import 'package:flouka/features/navbar/presentation/provider/nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/app_color.dart';
import '../../../../core/config/app_styles.dart';
import '../../../../core/widgets/svg_widget.dart';
import '../../domain/entities/bottom_nav_bar_entity.dart';

class BottomNavBarItemWidget extends StatelessWidget {
  const BottomNavBarItemWidget({super.key, required this.bottomNaBarEntity});
  final BottomNaBarEntity bottomNaBarEntity;

  @override
  Widget build(BuildContext context) {
    final navBarProvider = Provider.of<NavBarProvider>(context, listen: false);
    final active = navBarProvider.currentIndex == bottomNaBarEntity.index;
    return InkWell(
      onTap: () {
        navBarProvider.changeIndex(bottomNaBarEntity.index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgWidget(
            width: 24,
            svg: bottomNaBarEntity.svgImage,
            color: active ? AppColor.primaryColor : AppColor.mutedColor,
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 56,
            child: Text(
              bottomNaBarEntity.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyleClass.captionStyle(
                color: active ? AppColor.primaryColor : AppColor.mutedColor,
              ).copyWith(
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
