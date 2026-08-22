import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/app_lotties.dart';
import 'package:flouka/core/widgets/empty_animation.dart';
import 'package:flouka/core/widgets/flouka_screen_header.dart';
import 'package:flouka/core/widgets/loading_animation_widget.dart';
import 'package:flouka/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/add_ticket_provider.dart';
import '../provider/tickets_provider.dart';
import '../widgets/ticket_widget.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ticketsProvider = Provider.of<TicketsProvider>(context);
    ticketsProvider.pagination();

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FloukaScreenHeader(
              title: LanguageProvider.translate('ticket', 'support_ticket'),
              trailing: Material(
                color: AppColor.deepColor,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: InkWell(
                  onTap: () => Provider.of<AddTicketProvider>(
                    context,
                    listen: false,
                  ).goToAddTicketPage(),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: AppColor.limeColor, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          LanguageProvider.translate('ticket', 'add_ticket'),
                          style: TextStyleClass.captionStyle(
                            color: Colors.white,
                          ).copyWith(fontWeight: FontWeight.w700, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ticketsProvider.refresh(),
                child: Builder(
                  builder: (context) {
                    if (ticketsProvider.tickets == null) {
                      return const Center(
                        child: LoadingAnimationWidget(gif: Lotties.loading),
                      );
                    }
                    if (ticketsProvider.tickets!.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 48),
                          EmptyAnimation(
                            title: '',
                            gif: Lotties.noSearch,
                          ),
                        ],
                      );
                    }
                    return ListView.separated(
                      controller: ticketsProvider.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.pageGutter,
                        4,
                        AppSpacing.pageGutter,
                        24,
                      ),
                      itemCount: ticketsProvider.tickets!.length +
                          (ticketsProvider.paginationStarted ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        if (index >= ticketsProvider.tickets!.length) {
                          return const Center(child: LoadingWidget());
                        }
                        return TicketWidget(
                          ticket: ticketsProvider.tickets![index],
                        );
                      },
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
