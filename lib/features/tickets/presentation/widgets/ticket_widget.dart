import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/convert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entities/ticket_entity.dart';
import '../provider/ticket_message_provider.dart';

class TicketWidget extends StatelessWidget {
  const TicketWidget({super.key, required this.ticket});
  final TicketEntity ticket;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pageGutter, 0, AppSpacing.pageGutter, 10),
      child: InkWell(
        onTap: () {
          context.read<TicketMessageProvider>().goToMessagePage(id: ticket.id);
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColor.canvasColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColor.borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LanguageProvider.translate('ticket', 'ticket_number').replaceFirst('*id*', '${ticket.id}'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleClass.smallStyle(color: AppColor.inkColor).copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      LanguageProvider.translate('ticket', 'ticket_category').replaceFirst('*cat*', ticket.ticketCategory?.name ?? ''),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleClass.captionStyle(color: AppColor.mutedColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      LanguageProvider.translate('ticket', 'ticket_date').replaceFirst('*date*', convertDateTimeToStringDMY(ticket.createdAt)),
                      maxLines: 1,
                      style: TextStyleClass.captionStyle(color: AppColor.mutedColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                LanguageProvider.translate('ticket', ticket.status),
                style: TextStyleClass.captionStyle(color: AppColor.inkColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
