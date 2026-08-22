import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/convert.dart';
import 'package:flouka/core/helper_function/loading.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/core/helper_function/text_form_field_validation.dart';
import 'package:flouka/core/dialog/snack_bar.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/cart/domain/entity/payment_method_entity.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/navbar/presentation/provider/nav_bar_provider.dart';
import 'package:flouka/features/orders/presentation/provider/order_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderConfirmedView extends StatefulWidget {
  const OrderConfirmedView({
    super.key,
    required this.orderId,
    required this.total,
    required this.paymentMethod,
    required this.vendorNames,
  });

  final int orderId;
  final num total;
  final PaymentMethodEntity paymentMethod;
  final List<String> vendorNames;

  @override
  State<OrderConfirmedView> createState() => _OrderConfirmedViewState();
}

class _OrderConfirmedViewState extends State<OrderConfirmedView> {
  final _emailController = TextEditingController();
  bool _emailSaved = false;
  bool _savingEmail = false;

  @override
  void initState() {
    super.initState();
    final email = context.read<AuthProvider>().userEntity?.email;
    if (email != null && email.trim().isNotEmpty) {
      _emailController.text = email.trim();
      _emailSaved = true;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool get _needsEmail {
    final email = context.read<AuthProvider>().userEntity?.email;
    return !_emailSaved && (email == null || email.trim().isEmpty);
  }

  Future<void> _saveEmail() async {
    final value = _emailController.text.trim();
    final error = validateEmail(value);
    if (error != null) {
      showToast(error, isSnack: true);
      return;
    }
    setState(() => _savingEmail = true);
    loading();
    final result = await context.read<AuthProvider>().authUseCase
        .updateProfile({'email': value});
    dismissLoading();
    if (!mounted) return;
    setState(() => _savingEmail = false);
    result.fold(
      (l) => showToast(
        l.message ?? LanguageProvider.translate('error', 'error'),
        isSnack: true,
      ),
      (r) {
        context.read<AuthProvider>().userEntity = r;
        context.read<AuthProvider>().rebuild();
        setState(() => _emailSaved = true);
        showToast(
          LanguageProvider.translate('order_confirmed', 'email_saved'),
          isSnack: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final paymentLine = widget.paymentMethod.toAPI == 'cash'
        ? LanguageProvider.translate('order_confirmed', 'cod_payment')
            .replaceAll('*amount*', formatPrice(widget.total))
        : LanguageProvider.translate('order_confirmed', 'paid_online')
            .replaceAll('*amount*', formatPrice(widget.total));

    return Scaffold(
      backgroundColor: AppColor.deepColor,
      body: Stack(
        children: [
          Positioned(
            top: 60,
            left: -70,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.limeColor.withValues(alpha: 0.16),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 40, 24, bottom + 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: AppColor.limeColor,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Center(
                              child: Transform.rotate(
                                angle: -0.785398,
                                child: Container(
                                  width: 34,
                                  height: 19,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: AppColor.deepColor,
                                        width: 5,
                                      ),
                                      bottom: BorderSide(
                                        color: AppColor.deepColor,
                                        width: 5,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            LanguageProvider.translate(
                              'order_confirmed',
                              'title',
                            ),
                            style: TextStyleClass.screenTitleStyle(
                              color: Colors.white,
                            ).copyWith(fontSize: 38, height: 1.04),
                          ),
                          const SizedBox(height: 13),
                          Text(
                            LanguageProvider.translate(
                              'order_confirmed',
                              'subtitle',
                            )
                                .replaceAll(
                                  '*vendors*',
                                  widget.vendorNames.join(' · '),
                                )
                                .replaceAll('*payment*', paymentLine),
                            style: TextStyleClass.normalStyle(
                              color: Colors.white.withValues(alpha: 0.62),
                            ).copyWith(fontSize: 15.5, height: 1.5),
                          ),
                          const SizedBox(height: 28),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.14),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      LanguageProvider.translate(
                                        'order_confirmed',
                                        'order_number',
                                      ),
                                      style: TextStyleClass.smallStyle(
                                        color: Colors.white
                                            .withValues(alpha: 0.55),
                                      ).copyWith(fontSize: 12.5),
                                    ),
                                    Text(
                                      '#FLK-${widget.orderId}',
                                      style: TextStyleClass.smallStyle(
                                        color: Colors.white,
                                      ).copyWith(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                if (widget.vendorNames.isNotEmpty) ...[
                                  Divider(
                                    height: 26,
                                    color:
                                        Colors.white.withValues(alpha: 0.12),
                                  ),
                                  Row(
                                    children: [
                                      for (var i = 0;
                                          i < widget.vendorNames.length;
                                          i++) ...[
                                        if (i > 0) const Spacer(),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: i == 0
                                                ? CrossAxisAlignment.start
                                                : CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                widget.vendorNames[i],
                                                style: TextStyleClass
                                                    .captionStyle(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.5),
                                                ).copyWith(fontSize: 11),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                LanguageProvider.translate(
                                                  'order_confirmed',
                                                  'eta_soon',
                                                ),
                                                style:
                                                    TextStyleClass.smallStyle(
                                                  color: i == 0
                                                      ? AppColor.limeColor
                                                      : Colors.white,
                                                ).copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                ),
                                                textAlign: i == 0
                                                    ? TextAlign.start
                                                    : TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (_needsEmail) ...[
                            const SizedBox(height: 16),
                            _EmailInvoiceCard(
                              controller: _emailController,
                              saving: _savingEmail,
                              onSave: _saveEmail,
                            ),
                          ] else if (_emailSaved) ...[
                            const SizedBox(height: 12),
                            Text(
                              LanguageProvider.translate(
                                'order_confirmed',
                                'email_saved',
                              ),
                              style: TextStyleClass.captionStyle(
                                color: AppColor.limeColor,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppColor.limeColor
                                        .withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 13,
                                      height: 13,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColor.limeColor,
                                          width: 1.8,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    LanguageProvider.translate(
                                      'order_confirmed',
                                      'change_tip',
                                    ),
                                    style: TextStyleClass.captionStyle(
                                      color: Colors.white
                                          .withValues(alpha: 0.65),
                                    ).copyWith(fontSize: 12, height: 1.45),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Material(
                    color: AppColor.limeColor,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: InkWell(
                      onTap: () {
                        Provider.of<OrderDetailsProvider>(
                          context,
                          listen: false,
                        ).goToPage({'order_id': widget.orderId});
                        navPop();
                      },
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Center(
                          child: Text(
                            LanguageProvider.translate(
                              'order_confirmed',
                              'track_order',
                            ),
                            style: TextStyleClass.buttonStyle(
                              color: AppColor.deepColor,
                            ).copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 15.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      navPU();
                      Provider.of<NavBarProvider>(context, listen: false)
                          .changeIndex(0);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.2,
                      ),
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                    child: Text(
                      LanguageProvider.translate(
                        'order_confirmed',
                        'continue_shopping',
                      ),
                      style: TextStyleClass.buttonStyle(color: Colors.white)
                          .copyWith(fontWeight: FontWeight.w700, fontSize: 14.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailInvoiceCard extends StatelessWidget {
  const _EmailInvoiceCard({
    required this.controller,
    required this.saving,
    required this.onSave,
  });

  final TextEditingController controller;
  final bool saving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LanguageProvider.translate('order_confirmed', 'email_title'),
            style: TextStyleClass.smallStyle(color: Colors.white).copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            LanguageProvider.translate('order_confirmed', 'email_subtitle'),
            style: TextStyleClass.captionStyle(
              color: Colors.white.withValues(alpha: 0.6),
            ).copyWith(height: 1.4, fontSize: 12.5),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              style: TextStyleClass.textFieldStyle().copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: LanguageProvider.translate(
                  'order_confirmed',
                  'email_hint',
                ),
                hintStyle: TextStyleClass.textFieldStyle(
                  color: AppColor.mutedColor,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: Material(
              color: AppColor.limeColor,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: InkWell(
                onTap: saving ? null : onSave,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: Center(
                  child: Text(
                    LanguageProvider.translate(
                      'order_confirmed',
                      'email_cta',
                    ),
                    style: TextStyleClass.buttonStyle(color: AppColor.deepColor)
                        .copyWith(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
