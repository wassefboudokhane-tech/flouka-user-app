import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/widgets/flouka_screen_header.dart';
import 'package:flouka/core/widgets/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_lotties.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/common_question_provider.dart';
import '../widgets/common_question_widget.dart';

class CommonQuestionsView extends StatelessWidget {
  const CommonQuestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final commonQuestionsProvider =
        Provider.of<CommonQuestionsProvider>(context);
    commonQuestionsProvider.pagination();
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
              child: SingleChildScrollView(
                controller: commonQuestionsProvider.controller,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Builder(
                  builder: (context) {
                    if (commonQuestionsProvider.commonQuestionList == null) {
                      return const LoadingAnimationWidget(
                        gif: Lotties.loading,
                      );
                    }
                    if (commonQuestionsProvider.commonQuestionList!.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: List.generate(
                        commonQuestionsProvider.commonQuestionList!.length,
                        (index) => CommonQuestionWidget(
                          commonQuestionEntity: commonQuestionsProvider
                              .commonQuestionList![index],
                        ),
                      ),
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
