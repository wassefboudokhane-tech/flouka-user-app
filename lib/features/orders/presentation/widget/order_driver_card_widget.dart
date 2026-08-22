import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/chat/presentation/provider/message_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDriverCardWidget extends StatelessWidget {
  const OrderDriverCardWidget({
    super.key,
    required this.storeId,
    this.driverName,
  });

  final int storeId;
  final String? driverName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColor.softColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.borderColor),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driverName ??
                      LanguageProvider.translate('orders', 'driver_default'),
                  style: TextStyleClass.smallStyle(color: AppColor.inkColor)
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                Text(
                  LanguageProvider.translate('orders', 'driver_calls_before'),
                  style: TextStyleClass.captionStyle(color: AppColor.mutedColor)
                      .copyWith(fontSize: 11.5, height: 1.3),
                ),
              ],
            ),
          ),
          Material(
            color: AppColor.limeColor,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                Provider.of<MessageProvider>(context, listen: false)
                    .goToMessagePage(orderId: 0, storeId: storeId);
              },
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.phone_in_talk_outlined, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
