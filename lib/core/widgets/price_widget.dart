import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({super.key, required this.price, this.fontSize, this.color});
  final num price;
  final double? fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = TextStyleClass.priceStyle(color: color ?? AppColor.deepColor)
        .copyWith(fontSize: fontSize);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            price.toString(),
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          LanguageProvider.translate('global', 'currency'),
          style: style,
        ),
      ],
    );
  }
}
