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
        date: LanguageProvider.translate('time', 'today'),
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
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    _TimelineDot(state: steps[i].state),
                    if (i < steps.length - 1)
                      Container(
                        width: 1,
                        height: 22,
                        color: steps[i].state == _StepState.done || steps[i].state == _StepState.active
                            ? AppColor.inkColor
                            : AppColor.borderColor,
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                steps[i].title,
                                style: TextStyleClass.smallStyle(
                                  color: steps[i].state == _StepState.upcoming ? AppColor.mutedColor : AppColor.inkColor,
                                ).copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              steps[i].date,
                              style: TextStyleClass.captionStyle(color: AppColor.mutedColor),
                            ),
                          ],
                        ),
                        if (steps[i].subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            steps[i].subtitle!,
                            style: TextStyleClass.captionStyle(color: AppColor.mutedColor),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
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
    final done = state == _StepState.done || state == _StepState.active;
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: done ? AppColor.inkColor : AppColor.canvasColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: done ? AppColor.inkColor : AppColor.borderColor),
      ),
    );
  }
}
