import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/widgets/flouka_screen_header.dart';
import 'package:flouka/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/wallet_provider.dart';
import '../widgets/header_wallet_widget.dart';
import '../widgets/user_list_of_operations_widget.dart';

class UserWalletHome extends StatelessWidget {
  const UserWalletHome({super.key, this.fromHome = true});

  final bool fromHome;

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    walletProvider.pagination();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.canvasColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FloukaScreenHeader(
                title: LanguageProvider.translate('settings', 'wallet'),
              ),
              const HeaderWalletWidget(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => walletProvider.refresh(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: walletProvider.controller,
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      const ListOfTransactionWidgets(),
                      if (walletProvider.paginationStarted)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: LoadingWidget()),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
