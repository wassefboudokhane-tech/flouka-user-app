import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/convert.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/orders/domain/entity/order_details_entity.dart';
import 'package:flutter/material.dart';

class OrderTrackingTimelineWidget extends StatelessWidget {
  const OrderTrackingTimelineWidget({super.key, required this.order});

  final OrderDetailsEntity order;

  List<_TimelineStep> _steps() {
    final created = order.createdAt != null
        ? convertDateTimeToString(DateTime.parse(order.createdAt!))
        : '';
    final level = order.status?.level ?? 1;

    return [
      _TimelineStep(
        title: LanguageProvider.translate('orders', 'order_accepted'),
        date: created,
        state: _StepState.done,
      ),
      _TimelineStep(
        title: LanguageProvider.translate('orders', 'order_shipped'),
        date: created,
        subtitle: LanguageProvider.translate('orders', 'order_shipped_desc'),
        state: level >= 4 ? _StepState.done : _StepState.pending,
      ),
      _TimelineStep(
        title: LanguageProvider.translate('orders', 'delivery_in_progress'),
        date: LanguageProvider.translate('orders', 'today'),
        state: level >= 7
            ? _StepState.active
            : level >= 4
                ? _StepState.pending
                : _StepState.upcoming,
      ),
      _TimelineStep(
        title: LanguageProvider.translate('orders', 'completed'),
        date: LanguageProvider.translate('orders', 'expected_delivery'),
        state: level >= 10 ? _StepState.done : _StepState.upcoming,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final steps = _steps();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              for (var i = 0; i < steps.length; i++) ...[
                _TimelineDot(state: steps[i].state),
                if (i < steps.length - 1)
                  Container(
                    width: 2,
                    height: steps[i].subtitle != null ? 60 : 34,
                    color: steps[i].state == _StepState.done ||
                            steps[i].state == _StepState.active
                        ? AppColor.limeColor
                        : AppColor.borderColor,
                  ),
              ],
            ],
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              children: [
                for (final step in steps) ...[
                  SizedBox(
                    height: step.subtitle != null ? 94 : 34,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  step.title,
                                  style: TextStyleClass.smallStyle(
                                    color: step.state == _StepState.upcoming
                                        ? AppColor.mutedColor
                                        : step.state == _StepState.active
                                            ? AppColor.deepColor
                                            : AppColor.inkColor,
                                  ).copyWith(
                                    fontWeight: step.state == _StepState.active
                                        ? FontWeight.w800
                                        : FontWeight.w700,
                                    fontSize: 13.5,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              Text(
                                step.date,
                                style: TextStyleClass.captionStyle(
                                  color: step.state == _StepState.active
                                      ? AppColor.deepColor
                                      : AppColor.mutedColor,
                                ).copyWith(
                                  fontWeight: step.state == _StepState.active
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          if (step.subtitle != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              step.subtitle!,
                              style: TextStyleClass.captionStyle(
                                color: AppColor.mutedColor,
                              ).copyWith(fontSize: 11.5, height: 1.4),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _StepState { done, active, pending, upcoming }

class _TimelineStep {
  const _TimelineStep({
    required this.title,
    required this.date,
    required this.state,
    this.subtitle,
  });

  final String title;
  final String date;
  final String? subtitle;
  final _StepState state;
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({required this.state});

  final _StepState state;

  @override
  Widget build(BuildContext context) {
    if (state == _StepState.active) {
      return Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColor.deepColor,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Center(
          child: Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(
              color: AppColor.limeColor,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
      );
    }

    if (state == _StepState.done) {
      return Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColor.limeColor,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Center(
          child: Transform.rotate(
            angle: -0.785398,
            child: Container(
              width: 12,
              height: 7,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppColor.deepColor, width: 2),
                  bottom: BorderSide(color: AppColor.deepColor, width: 2),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppColor.canvasColor,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: AppColor.borderColor),
      ),
    );
  }
}
