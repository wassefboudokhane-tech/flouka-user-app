import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/widgets/flouka_screen_header.dart';
import 'package:flouka/core/widgets/loading_animation_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_lotties.dart';
import '../../../../core/helper_function/helper_function.dart';
import '../provider/ticket_message_provider.dart';
import '../widgets/tickets_messages_widget.dart';
import '../widgets/tickets_send_message_widget.dart';

class TicketMessagePage extends StatelessWidget {
  const TicketMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ticketMessageProvider = Provider.of<TicketMessageProvider>(context);
    if (ticketMessageProvider.ticketEntity != null) {
      delay(300).then((value) {
        ticketMessageProvider.scrollToBottom();
      });
    }

    final title = ticketMessageProvider.ticketEntity?.title ??
        LanguageProvider.translate('ticket', 'support_ticket');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.canvasColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FloukaScreenHeader(title: title),
              Expanded(
                child: ticketMessageProvider.ticketEntity == null
                    ? const Center(
                        child: LoadingAnimationWidget(gif: Lotties.loading),
                      )
                    : const Column(
                        children: [
                          Expanded(child: TicketMessagesWidget()),
                          TicketSendMessageWidget(),
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
