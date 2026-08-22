import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flutter/material.dart';

class FloukaBackButton extends StatelessWidget {
  const FloukaBackButton({
    super.key,
    this.onTap,
    this.color,
    this.backgroundColor,
  });

  final VoidCallback? onTap;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final chevronColor = color ?? AppColor.deepColor;
    return Material(
      color: backgroundColor ?? AppColor.backgroundColor,
      borderRadius: BorderRadius.circular(AppRadius.checkoutBack),
      child: InkWell(
        onTap: onTap ?? () => Navigator.maybePop(context),
        borderRadius: BorderRadius.circular(AppRadius.checkoutBack),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: Transform.rotate(
              angle: 0.785398,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: chevronColor, width: 2),
                    bottom: BorderSide(color: chevronColor, width: 2),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
