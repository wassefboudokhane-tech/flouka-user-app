import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/app_images.dart';
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
    final isLast = onBoardingProvider.isLastSlide;
    final isDeepSlide = onBoardingProvider.index >= 1;

    return Scaffold(
      backgroundColor: onBoardingProvider.selected.color,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: double.infinity,
        height: double.infinity,
        color: onBoardingProvider.selected.color,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pageGutter,
          vertical: 20,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final imageMaxH =
                  (constraints.maxHeight * 0.36).clamp(120.0, 280.0);
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Image.asset(AppImages.logo, width: 36, height: 36),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  LanguageProvider.translate(
                                    'global',
                                    'app_name',
                                  ),
                                  style: TextStyleClass.normalStyle(
                                    color: isDeepSlide
                                        ? Colors.white
                                        : AppColor.deepColor,
                                  ).copyWith(fontWeight: FontWeight.w800),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ButtonWidget(
                                onTap: onBoardingProvider.skipButtonPressed,
                                borderRadius: AppRadius.btn,
                                height: 36,
                                text: 'skip',
                                takeSmallestWidth: true,
                                color: Colors.transparent,
                                borderColor: isDeepSlide
                                    ? Colors.white.withValues(alpha: 0.45)
                                    : AppColor.deepColor.withAlpha(150),
                                textStyle: TextStyleClass.smallStyle(
                                  color: isDeepSlide
                                      ? Colors.white.withValues(alpha: 0.85)
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
                                LanguageProvider.languageCode() ?? 'fr',
                              ),
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) {
                                final fallback = onBoardingProvider
                                    .selected.image
                                    .replaceAll('_*lang*', '');
                                return Image.asset(
                                  fallback,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 96,
                                    color: isDeepSlide
                                        ? AppColor.limeColor
                                        : AppColor.deepColor,
                                  ),
                                );
                              },
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
                              children: List.generate(3, (index) {
                                return Expanded(
                                  child: InkWell(
                                    onTap: () => onBoardingProvider
                                        .onNextButtonPressed(index),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 4,
                                      ),
                                      child: Container(
                                        height: 3,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            AppRadius.pill,
                                          ),
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
                            ),
                            const SizedBox(height: 12),
                            ButtonWidget(
                              onTap: onBoardingProvider.onNextButtonPressed,
                              text: isLast ? 'get_started' : 'next',
                              color: onBoardingProvider.selected.btnColor,
                              textStyle: TextStyleClass.normalStyle(
                                color: onBoardingProvider.selected.btnTextColor,
                              ).copyWith(fontWeight: FontWeight.w800),
                            ),
                            if (isLast) ...[
                              const SizedBox(height: 10),
                              Center(
                                child: TextButton(
                                  onPressed: onBoardingProvider
                                      .finishOnboardingAsGuest,
                                  child: Text(
                                    LanguageProvider.translate(
                                      'auth',
                                      'guest_description',
                                    ),
                                    style: TextStyleClass.smallStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.85,
                                      ),
                                    ).copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
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
