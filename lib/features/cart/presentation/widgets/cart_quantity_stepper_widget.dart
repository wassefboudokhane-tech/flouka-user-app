import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flutter/material.dart';

class CartQuantityStepperWidget extends StatelessWidget {
  const CartQuantityStepperWidget({
    super.key,
    required this.count,
    required this.max,
    this.onAdd,
    this.onRemove,
  });

  final int count;
  final num max;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperText(
            label: '−',
            enabled: count > 1,
            muted: true,
            onTap: onRemove,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11),
            child: Text(
              '$count',
              style: TextStyleClass.smallStyle(color: AppColor.inkColor)
                  .copyWith(fontWeight: FontWeight.w800, fontSize: 13),
            ),
          ),
          _StepperText(
            label: '+',
            enabled: count < max,
            muted: false,
            onTap: onAdd,
          ),
        ],
      ),
    );
  }
}

class _StepperText extends StatelessWidget {
  const _StepperText({
    required this.label,
    required this.enabled,
    required this.muted,
    this.onTap,
  });

  final String label;
  final bool enabled;
  final bool muted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Text(
        label,
        style: TextStyleClass.smallStyle(
          color: enabled
              ? (muted ? AppColor.mutedColor : AppColor.deepColor)
              : AppColor.mutedColor.withValues(alpha: 0.4),
        ).copyWith(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    );
  }
}
