import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/widgets/flouka_screen_header.dart';
import 'package:flouka/core/widgets/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_lotties.dart';
import '../../../../core/helper_function/helper_function.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/message_provider.dart';
import '../widgets/messages_widget.dart';
import '../widgets/send_message_widget.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);
    if (messageProvider.chatEntity != null) {
      delay(300).then((value) {
        messageProvider.scrollToBottom();
      });
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.canvasColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FloukaScreenHeader(
                title: LanguageProvider.translate('chat', 'chat'),
              ),
              Expanded(
                child: messageProvider.chatEntity == null
                    ? const Center(
                        child: LoadingAnimationWidget(gif: Lotties.chats),
                      )
                    : const Column(
                        children: [
                          Expanded(child: MessagesWidget()),
                          SendMessageWidget(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
