import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_theme.dart';
import 'package:flouka/core/constants/app_images.dart';
import 'package:flouka/core/constants/constants.dart';
import 'package:flouka/core/widgets/flouka_primary_button.dart';
import 'package:flouka/features/auth/presentation/providers/otp_provider.dart';
import 'package:flouka/features/auth/presentation/widgets/otp_container_with_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OTPView extends StatelessWidget {
  const OTPView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle:
            Constants.isTablet ? barColor() : lightBarColor(),
      ),
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion(
        value: Constants.isTablet ? barColor() : lightBarColor(),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: IgnorePointer(
                child: Image.asset(AppImages.topAuth, fit: BoxFit.fitWidth),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IgnorePointer(
                child: Image.asset(AppImages.bottomAuth, fit: BoxFit.fitWidth),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.pageGutter + 8,
                      ),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Image.asset(AppImages.logo, width: 112),
                          const SizedBox(height: 28),
                          const OtpContainerWithButton(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageGutter + 8,
                      8,
                      AppSpacing.pageGutter + 8,
                      16,
                    ),
                    child: FloukaPrimaryButton(
                      text: 'send',
                      onTap: () {
                        Provider.of<OtpProvider>(context, listen: false)
                            .checkCode();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
