import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/app_lotties.dart';
import 'package:flouka/core/widgets/flouka_screen_header.dart';
import 'package:flouka/core/widgets/loading_animation_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/notifications_provider.dart';
import '../widgets/notification_widget.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FloukaScreenHeader(
              title: LanguageProvider.translate('global', 'notifications'),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => notificationProvider.refresh(),
                child: Builder(
                  builder: (context) {
                    final notifications = notificationProvider.notifications;
                    if (notifications == null) {
                      return const Center(
                        child: LoadingAnimationWidget(gif: Lotties.loading),
                      );
                    }
                    if (notifications.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 80),
                          Center(
                            child: Text(
                              LanguageProvider.translate(
                                'global',
                                'no_notifications',
                              ),
                              style: TextStyleClass.smallStyle(
                                color: AppColor.mutedColor,
                              ).copyWith(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 4, bottom: 24),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        return NotificationWidget(
                          notificationEntity: notifications[index],
                          unread: index < 3,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
