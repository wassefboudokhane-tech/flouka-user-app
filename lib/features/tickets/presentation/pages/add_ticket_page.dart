import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/widgets/button_widget.dart';
import 'package:flouka/core/widgets/flouka_screen_header.dart';
import 'package:flouka/core/widgets/list_text_field_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/add_ticket_provider.dart';

class AddTicketPage extends StatelessWidget {
  AddTicketPage({super.key});
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final addTicketCubit = Provider.of<AddTicketProvider>(context);

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FloukaScreenHeader(
                title: LanguageProvider.translate('ticket', 'add_ticket'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pageGutter,
                    vertical: 8,
                  ),
                  child: ListTextFieldWidget(
                    inputs: addTicketCubit.ticketInputs,
                    color: AppColor.softColor,
                    borderColor: Colors.transparent,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageGutter,
                  8,
                  AppSpacing.pageGutter,
                  16,
                ),
                child: ButtonWidget(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      addTicketCubit.createTicket();
                    }
                  },
                  text: 'start_chat',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
