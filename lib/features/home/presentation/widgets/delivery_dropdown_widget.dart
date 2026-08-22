import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/dialog/guest_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../address/presentation/providers/address_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';

class DeliveryDropdownWidget extends StatelessWidget {
  const DeliveryDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of(context);
    final AddressProvider addressProvider =
        Provider.of<AddressProvider>(context);
    final hasAddress = authProvider.userEntity?.addressEntity != null;
    final label = hasAddress
        ? (authProvider.userEntity?.addressEntity?.addressName ?? '')
        : LanguageProvider.translate('home', 'select_location');

    return InkWell(
      onTap: () {
        checkGuest(() {
          addressProvider.goToAddressPage();
        });
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LanguageProvider.translate('home', 'deliver_to'),
                  style: TextStyleClass.captionStyle(
                    color: AppColor.backgroundColor.withValues(alpha: 0.5),
                  ).copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        style: TextStyleClass.smallStyle(
                          color: AppColor.backgroundColor,
                        ).copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    CustomPaint(
                      size: const Size(8, 5),
                      painter: _LimeChevronPainter(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LimeChevronPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = AppColor.limeColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
