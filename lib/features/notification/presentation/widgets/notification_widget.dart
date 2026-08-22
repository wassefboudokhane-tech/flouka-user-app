import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/helper_function/convert.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/notification_entity.dart';
import '../pages/notification_details_page.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
    required this.notificationEntity,
    this.unread = true,
  });

  final NotificationEntity notificationEntity;
  final bool unread;

  String _timeLabel(DateTime date) {
    final now = DateTime.now();
    if (now.difference(date).inHours < 24 &&
        now.day == date.day &&
        now.month == date.month &&
        now.year == date.year) {
      return LanguageProvider.translate('time', 'today');
    }
    return getDiffTime(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        0,
        AppSpacing.pageGutter,
        10,
      ),
      child: Material(
        color: AppColor.softColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {
            navP(
              NotificationDetailsPage(
                title: notificationEntity.title,
                data: notificationEntity.description,
              ),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (unread)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: 5,
                      end: 10,
                    ),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notificationEntity.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleClass.smallStyle(
                                color: AppColor.deepColor,
                              ).copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _timeLabel(notificationEntity.createdAt),
                            style: TextStyleClass.captionStyle(
                              color: AppColor.mutedColor,
                            ).copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notificationEntity.description,
                        style: TextStyleClass.captionStyle(
                          color: AppColor.mutedColor,
                        ).copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
