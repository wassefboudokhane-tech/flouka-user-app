import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/widgets/flouka_screen_header.dart';
import 'package:flutter/material.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entities/common_question_entity.dart';
import '../widgets/common_question_details_widget.dart';

class CommonQuestionDetailsview extends StatelessWidget {
  const CommonQuestionDetailsview({
    super.key,
    required this.commonQuestionEntity,
  });

  final CommonQuestionEntity commonQuestionEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FloukaScreenHeader(
              title: LanguageProvider.translate('global', 'common_questions'),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageGutter,
                ),
                itemCount: commonQuestionEntity.faq.length,
                itemBuilder: (ctx, i) {
                  return CommonQuestionDetailsWidget(
                    faqEntity: commonQuestionEntity.faq[i],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
