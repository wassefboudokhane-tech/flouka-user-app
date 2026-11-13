import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/flouka_network_image.dart';
import 'package:flouka/features/creators/domain/entity/creator_entity.dart';
import 'package:flutter/material.dart';

/// Round creator avatar; falls back to initials when there is no photo.
class CreatorAvatar extends StatelessWidget {
  const CreatorAvatar({
    super.key,
    required this.creator,
    required this.size,
    this.ringColor,
  });

  final CreatorEntity creator;
  final double size;
  final Color? ringColor;

  @override
  Widget build(BuildContext context) {
    final avatar = creator.avatar;
    final hasPhoto = avatar != null && avatar.isNotEmpty;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.borderColor,
        border: Border.all(
          color: ringColor ?? AppColor.primaryColor,
          width: size >= 64 ? 3 : 2.5,
        ),
        image: hasPhoto
            ? DecorationImage(
                image: floukaImageProvider(avatar),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: hasPhoto
          ? null
          : Text(
              creator.initials,
              style: TextStyleClass.normalStyle(
                color: AppColor.deepColor,
                fontSize: size * 0.3,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
    );
  }
}
