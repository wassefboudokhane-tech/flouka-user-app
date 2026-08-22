import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/cart/presentation/widgets/coupons_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';

/// Cart promo entry — mockup « + Code promo (facultatif) ».
class CartPromoLinkWidget extends StatelessWidget {
  const CartPromoLinkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: AppColor.backgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (ctx) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  20,
                  16,
                  MediaQuery.paddingOf(ctx).bottom + 20,
                ),
                child: const CouponsWidget(),
              );
            },
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(Icons.add, size: 18, color: AppColor.primaryColor),
              const SizedBox(width: 6),
              Text(
                LanguageProvider.translate('global', 'coupon_code'),
                style: TextStyleClass.smallStyle(color: AppColor.primaryColor)
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 13.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
