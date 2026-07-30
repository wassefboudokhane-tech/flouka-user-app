import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/app_images.dart';
import 'package:flouka/core/dialog/guest_dialog.dart';
import 'package:flouka/core/widgets/svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
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
          SvgWidget(svg: AppImages.location, width: 5.w, color: Colors.white),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LanguageProvider.translate('home', 'deliver_to'),
                  style: TextStyleClass.smallStyle(color: AppColor.limeColor)
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 11.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: TextStyleClass.normalStyle(color: Colors.white)
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 13.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }
}
