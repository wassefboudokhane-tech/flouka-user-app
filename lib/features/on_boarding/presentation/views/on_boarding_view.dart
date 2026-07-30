import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/widgets/button_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/on_boarding_provider.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final onBoardingProvider = Provider.of<OnBoardingProvider>(context);
    return Scaffold(
      backgroundColor: onBoardingProvider.selected.color,
      body: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        width: double.infinity,
        height: double.infinity,
        color: onBoardingProvider.selected.color,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter, vertical: 20),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final imageMaxH = (constraints.maxHeight * 0.36).clamp(120.0, 280.0);
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    LanguageProvider.translate('global', 'app_name'),
                                    style: TextStyleClass.normalStyle(
                                      color: onBoardingProvider.index == 2
                                          ? AppColor.limeColor
                                          : AppColor.deepColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                ButtonWidget(
                                  onTap: () {
                                    onBoardingProvider.skipButtonPressed();
                                  },
                                  borderRadius: AppRadius.btn,
                                  height: 36,
                                  text: 'skip',
                                  takeSmallestWidth: true,
                                  color: Colors.transparent,
                                  borderColor: onBoardingProvider.index == 2
                                      ? Colors.white
                                      : AppColor.deepColor.withAlpha(150),
                                  textStyle: TextStyleClass.smallStyle(
                                    color: onBoardingProvider.index == 2
                                        ? Colors.white
                                        : AppColor.deepColor.withAlpha(150),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: imageMaxH,
                                maxWidth: constraints.maxWidth * 0.85,
                              ),
                              child: Image.asset(
                                onBoardingProvider.selected.image.replaceAll(
                                  '*lang*',
                                  LanguageProvider.languageCode() ?? "fr",
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LanguageProvider.translate(
                                  'on_boarding',
                                  onBoardingProvider.selected.title1,
                                ),
                                style: TextStyleClass.headStyle(
                                  color: onBoardingProvider.index == 0
                                      ? AppColor.deepColor
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                LanguageProvider.translate(
                                  'on_boarding',
                                  onBoardingProvider.selected.title2,
                                ),
                                style: TextStyleClass.headStyle(
                                  color: onBoardingProvider.selected.textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                LanguageProvider.translate(
                                  'on_boarding',
                                  onBoardingProvider.selected.description,
                                ),
                                style: TextStyleClass.normalStyle(
                                  color: onBoardingProvider.selected.descColor,
                                ),
                              ),
                              Row(
                                children: [
                                  ...List.generate(3, (index) {
                                    return Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          onBoardingProvider
                                              .onNextButtonPressed(index);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 4,
                                          ),
                                          child: Container(
                                            height: 3,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(AppRadius.pill),
                                              color: index ==
                                                      onBoardingProvider.index
                                                  ? onBoardingProvider
                                                      .selected.stepColor
                                                  : Colors.white.withAlpha(80),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ButtonWidget(
                                onTap: () {
                                  onBoardingProvider.onNextButtonPressed();
                                },
                                text: 'next',
                                color: onBoardingProvider.selected.btnColor,
                                textStyle: TextStyleClass.normalStyle(
                                  color: onBoardingProvider
                                      .selected.btnTextColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
