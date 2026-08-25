import 'package:cached_network_image/cached_network_image.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/convert.dart';
import 'package:flouka/features/address/presentation/providers/address_provider.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/auth/presentation/providers/complete_info_provider.dart';
import 'package:flouka/features/favorite/presentation/providers/favorite_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/notification/presentation/provider/notifications_provider.dart';
import 'package:flouka/features/orders/domain/entity/order_entity.dart';
import 'package:flouka/features/orders/presentation/provider/order_provider.dart';
import 'package:flouka/features/settings/presentation/provider/settings_provider.dart';
import 'package:flouka/features/settings/presentation/widgets/profile_menu_row_widget.dart';
import 'package:flouka/features/settings/presentation/widgets/settings_action_buttons.dart';
import 'package:flouka/features/stores/presentation/providers/followed_stores_provider.dart';
import 'package:flouka/features/tickets/presentation/provider/tickets_provider.dart';
import 'package:flouka/features/wallet/presentation/provider/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!AuthProvider.isLogin()) return;
      context.read<FavoriteProvider>().getData();
      context.read<FollowedStoresProvider>().getData();
      context.read<AddressProvider>().getData();
      if (context.read<OrderProvider>().data == null) {
        context.read<OrderProvider>().refresh();
      }
    });
  }

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  String _languageLabel(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return 'Français';
    }
  }

  int _activeOrders(List<OrderEntity>? orders) {
    if (orders == null) return 0;
    return orders.where((o) => o.status.isActive).length;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.userEntity;
    final settingsProvider = context.watch<SettingsProvider>();
    final favorites = context.watch<FavoriteProvider>();
    final orders = context.watch<OrderProvider>();
    final addresses = context.watch<AddressProvider>();
    final followed = context.watch<FollowedStoresProvider>();
    final tickets = context.watch<TicketsProvider>();
    final language = context.watch<LanguageProvider>();

    final openTickets =
        tickets.tickets?.where((t) => t.status != 'closed').length ?? 0;

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageGutter,
                  6,
                  AppSpacing.pageGutter,
                  14,
                ),
                child: Text(
                  LanguageProvider.translate('settings', 'title'),
                  style: TextStyleClass.screenTitleStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageGutter,
                ),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColor.deepColor,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: AppSpacing.profileInitialsSize / 2,
                        backgroundColor: AppColor.limeColor,
                        backgroundImage: user?.image != null
                            ? CachedNetworkImageProvider(user!.image!)
                            : null,
                        child: user?.image == null
                            ? Text(
                                _initials(user?.name),
                                style:
                                    TextStyleClass.semiHeadStyle(
                                      color: AppColor.deepColor,
                                    ).copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                    ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ??
                                  LanguageProvider.translate(
                                    'settings',
                                    'hi_guest',
                                  ),
                              style:
                                  TextStyleClass.semiHeadStyle(
                                    color: Colors.white,
                                  ).copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                    height: 1.1,
                                  ),
                            ),
                            if (user?.phone != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                user!.phone ?? '',
                                style: TextStyleClass.captionStyle(
                                  color: Colors.white.withValues(alpha: 0.55),
                                ).copyWith(fontSize: 12),
                              ),
                            ],
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (AuthProvider.isLogin()) {
                            context
                                .read<CompleteInfoProvider>()
                                .goToCompleteInfoView(isEdit: true);
                          } else {
                            auth.goToLoginView();
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.13),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 7,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                        ),
                        child: Text(
                          LanguageProvider.translate('buttons', 'EDIT'),
                          style:
                              TextStyleClass.captionStyle(
                                color: Colors.white,
                              ).copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 11.5,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageGutter,
                  14,
                  AppSpacing.pageGutter,
                  0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        value: formatPrice(user?.wallet ?? 0),
                        label: LanguageProvider.translate(
                          'settings',
                          'wallet_balance',
                        ),
                        onTap: () =>
                            context.read<WalletProvider>().goToWalletPage(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        value: '${_activeOrders(orders.data)}',
                        label: LanguageProvider.translate(
                          'settings',
                          'active_orders',
                        ),
                        showDot: _activeOrders(orders.data) > 0,
                        onTap: () => context.read<OrderProvider>().goToPage(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _MenuSection(
                title: LanguageProvider.translate('settings', 'my_account'),
                children: [
                  ProfileMenuRowWidget(
                    title: LanguageProvider.translate('global', 'my_orders'),
                    onTap: () => context.read<OrderProvider>().goToPage(),
                    showChevron: true,
                  ),
                  ProfileMenuRowWidget(
                    title: LanguageProvider.translate('settings', 'favorite'),
                    trailing: '${favorites.favoriteIds.length}',
                    onTap: () => context.read<FavoriteProvider>().goToPage(),
                    showChevron: false,
                  ),
                  ProfileMenuRowWidget(
                    title: LanguageProvider.translate('settings', 'address'),
                    trailing: '${addresses.address?.length ?? 0}',
                    onTap: () =>
                        context.read<AddressProvider>().goToAddressPage(),
                    showChevron: false,
                  ),
                  ProfileMenuRowWidget(
                    title: LanguageProvider.translate(
                      'settings',
                      'followed_stores',
                    ),
                    trailing: '${followed.stores?.length ?? 0}',
                    onTap: () =>
                        context.read<FollowedStoresProvider>().goToPage(),
                    showChevron: false,
                  ),
                ],
              ),
              _MenuSection(
                title: LanguageProvider.translate('settings', 'help_settings'),
                children: [
                  ProfileMenuRowWidget(
                    title: LanguageProvider.translate('settings', 'support'),
                    badge: openTickets > 0 ? '$openTickets' : null,
                    onTap: () {
                      settingsProvider.generalSettings.firstWhere(
                        (e) => e['title'] == 'support',
                      )['onTap']();
                    },
                  ),
                  ProfileMenuRowWidget(
                    title: LanguageProvider.translate('settings', 'language'),
                    trailing: _languageLabel(language.appLocal),
                    onTap: () => language.showLanguageDialog(),
                    showChevron: false,
                  ),
                  ProfileMenuRowWidget(
                    title: LanguageProvider.translate(
                      'settings',
                      'notifications',
                    ),
                    onTap: () => context
                        .read<NotificationProvider>()
                        .goToNotificationPage(),
                  ),
                  ProfileMenuRowWidget(
                    title: LanguageProvider.translate(
                      'settings',
                      'privacy_security',
                    ),
                    onTap: () => settingsProvider.goToPrivacy(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageGutter,
                ),
                child: SettingsActionButtons(authProvider: auth),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.onTap,
    this.showDot = false,
  });

  final String value;
  final String label;
  final VoidCallback onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.backgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColor.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    value,
                    style: TextStyleClass.headStyle(
                      color: AppColor.deepColor,
                    ).copyWith(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  if (showDot) ...[
                    const SizedBox(width: 6),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: AppColor.limeColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyleClass.captionStyle(
                  color: AppColor.mutedColor,
                ).copyWith(fontSize: 11, height: 1.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        0,
        AppSpacing.pageGutter,
        14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyleClass.captionStyle(color: AppColor.mutedColor)
                .copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  letterSpacing: 0.1,
                ),
          ),
          const SizedBox(height: 9),
          Container(
            decoration: BoxDecoration(
              color: AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColor.borderColor),
            ),
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    Divider(
                      height: 1,
                      color: AppColor.canvasColor,
                      indent: 14,
                      endIndent: 14,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
