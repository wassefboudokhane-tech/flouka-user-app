import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flutter/material.dart';

class ProfileMenuRowWidget extends StatelessWidget {
  const ProfileMenuRowWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.trailing,
    this.badge,
    this.showChevron = true,
  });

  final String title;
  final VoidCallback onTap;
  final String? trailing;
  final String? badge;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColor.softColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.circle, size: 8, color: AppColor.primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyleClass.smallStyle(color: AppColor.inkColor)
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 13.5),
              ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: TextStyleClass.captionStyle(color: AppColor.mutedColor)
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
              ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColor.limeColor,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  badge!,
                  style: TextStyleClass.captionStyle(color: AppColor.deepColor)
                      .copyWith(fontWeight: FontWeight.w800, fontSize: 10),
                ),
              ),
            ],
            if (showChevron && trailing == null && badge == null) ...[
              const SizedBox(width: 8),
              Transform.rotate(
                angle: 0.785398,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColor.mutedColor, width: 1.8),
                      right: BorderSide(color: AppColor.mutedColor, width: 1.8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
