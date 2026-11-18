import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/flouka_network_image.dart';
import 'package:flouka/features/creators/domain/entity/creator_entity.dart';
import 'package:flutter/material.dart';

/// Tall creator portrait: cover photo, otherwise the avatar, otherwise initials.
class CreatorPortrait extends StatelessWidget {
  const CreatorPortrait({
    super.key,
    required this.creator,
    required this.width,
  });

  final CreatorEntity creator;
  final double width;

  String? get _photo {
    final cover = creator.cover;
    if (cover != null && cover.isNotEmpty) return cover;
    final avatar = creator.avatar;
    if (avatar != null && avatar.isNotEmpty) return avatar;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final photo = _photo;
    return Container(
      width: width,
      height: width * 4 / 3,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColor.softColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColor.borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: photo == null
          ? Text(
              creator.initials,
              style: TextStyleClass.semiHeadStyle(
                color: AppColor.inkColor,
              ).copyWith(fontSize: width * 0.28),
            )
          : FloukaNetworkImage(url: photo, fit: BoxFit.cover, width: width, height: width * 4 / 3),
    );
  }
}
