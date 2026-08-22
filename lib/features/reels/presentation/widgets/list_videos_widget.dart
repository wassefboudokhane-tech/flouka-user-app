import 'package:cached_network_image/cached_network_image.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/dialog/guest_dialog.dart';
import 'package:flouka/core/dialog/snack_bar.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/reels/presentation/providers/video_provider.dart';
import 'package:flouka/features/reels/presentation/widgets/reels_product_overlay_widget.dart';
import 'package:flouka/features/reels/presentation/widgets/video_widget.dart';
import 'package:flouka/features/stores/presentation/providers/store_details_provider.dart';
import 'package:flouka/flouka_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListVideosWidget extends StatefulWidget {
  const ListVideosWidget({super.key});

  @override
  State<ListVideosWidget> createState() => _ListVideosWidgetState();
}

class _ListVideosWidgetState extends State<ListVideosWidget> {
  final Set<int> _followedVendors = {};
  final Set<int> _likedReels = {};

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);
    return Builder(
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ModalRoute? route = ModalRoute.of(context);
          if (route is PageRoute) {
            routeObserver.subscribe(videoProvider, route);
          }
        });
        if (videoProvider.reelItems == null ||
            videoProvider.reelItems!.isEmpty) {
          return const SizedBox();
        }
        return PageView(
          controller: videoProvider.controller,
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          onPageChanged: (val) {
            videoProvider.stopCurrentVideo(
              videoProvider.reelItems![videoProvider.previousNextPage],
            );
            videoProvider.changePageViewIndex(val);
            videoProvider.playVideo(videoProvider.reelItems![val]);
          },
          children: List.generate(videoProvider.reelItems!.length, (index) {
            final reelItem = videoProvider.reelItems![index];
            final reel = reelItem.reel;
            final followed = _followedVendors.contains(reel.vendorId);
            final liked = _likedReels.contains(reel.id);

            return InkWell(
              onDoubleTap: () {
                if (!AuthProvider.isLogin()) {
                  showGuestDialog();
                  return;
                }
                setState(() => _likedReels.add(reel.id));
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        VideoWidget(reelItem: reelItem, onTap: () {}),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 160,
                    child: Column(
                      children: [
                        _ReelAction(
                          icon: liked ? Icons.favorite : Icons.favorite_border,
                          color: liked ? AppColor.DealColor : Colors.white,
                          onTap: () {
                            if (!AuthProvider.isLogin()) {
                              showGuestDialog();
                              return;
                            }
                            setState(() {
                              if (liked) {
                                _likedReels.remove(reel.id);
                              } else {
                                _likedReels.add(reel.id);
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        _ReelAction(
                          icon: Icons.bookmark_border,
                          onTap: () {
                            if (!AuthProvider.isLogin()) {
                              showGuestDialog();
                              return;
                            }
                            showToast(
                              LanguageProvider.translate(
                                'reels',
                                'save_soon',
                              ),
                              isSnack: true,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 72,
                    bottom: 96,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Container(
                                width: 34,
                                height: 34,
                                color: Colors.white.withValues(alpha: 0.2),
                                child: reel.vendorLogo.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: reel.vendorLogo,
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                reel.vendorName,
                                style: TextStyleClass.smallStyle(
                                  color: Colors.white,
                                ).copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Material(
                              color: followed
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : AppColor.limeColor,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.pill),
                              child: InkWell(
                                onTap: () async {
                                  final ok = await context
                                      .read<StoreDetailsProvider>()
                                      .toggleFollowVendor(reel.vendorId);
                                  if (!ok || !mounted) return;
                                  setState(() {
                                    if (followed) {
                                      _followedVendors.remove(reel.vendorId);
                                    } else {
                                      _followedVendors.add(reel.vendorId);
                                    }
                                  });
                                },
                                borderRadius:
                                    BorderRadius.circular(AppRadius.pill),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: Text(
                                    LanguageProvider.translate(
                                      'buttons',
                                      followed ? 'unfollow' : 'follow',
                                    ),
                                    style: TextStyleClass.captionStyle(
                                      color: followed
                                          ? Colors.white
                                          : AppColor.deepColor,
                                    ).copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (reel.title != null) ...[
                          const SizedBox(height: 11),
                          Text(
                            reel.title!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyleClass.normalStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                            ).copyWith(fontSize: 13.5, height: 1.45),
                          ),
                        ],
                        ReelsProductOverlayWidget(reelItem: reelItem),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

class _ReelAction extends StatelessWidget {
  const _ReelAction({
    required this.icon,
    required this.onTap,
    this.color = Colors.white,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}
