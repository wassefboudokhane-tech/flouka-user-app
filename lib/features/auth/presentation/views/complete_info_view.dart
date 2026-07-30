import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/widgets/button_widget.dart';
import 'package:flouka/core/widgets/list_text_field_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/app_images.dart';
import '../providers/complete_info_provider.dart';

class CompleteInfoView extends StatelessWidget {
  const CompleteInfoView({super.key, required this.isEdit});

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    final completeInfoProvider = Provider.of<CompleteInfoProvider>(context);

    completeInfoProvider.isEdit = isEdit;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          LanguageProvider.translate(
            'auth',
            completeInfoProvider.isEdit ? 'edit_profile' : 'complete_profile',
          ),
          style: TextStyleClass.headStyle().copyWith(fontSize: 17),
        ),
        leading: const BackButton(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Form(
              key: completeInfoProvider.formKey,
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.pageGutter,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 3.h),
                            ListTextFieldWidget(
                              inputs:
                                  completeInfoProvider.completeInfoTextFieldList,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: ButtonWidget(
                        onTap: () {
                          completeInfoProvider.updateProfileButton();
                        },
                        text: isEdit ? 'save' : 'sign_up',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Image.asset(AppImages.topAuth),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
