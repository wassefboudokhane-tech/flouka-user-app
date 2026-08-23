import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/features/cart/presentation/widgets/cart_bubble_widget.dart';
import 'package:flouka/features/navbar/presentation/provider/nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/models/deep_link.dart';
import '../widgets/bottom_navigation_bar_widget.dart';

class NavBarView extends StatefulWidget {
  const NavBarView({super.key});

  @override
  State<NavBarView> createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DeepLinkService().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    final contentBottomInset =
        bottomSafe + AppSpacing.navShellBottomInset;
    final bubbleBottom =
        bottomSafe + AppSpacing.cartBubbleBottomOffset;

    return Consumer<NavBarProvider>(
      builder: (context, nav, _) {
        // Hide floating cart on Reels — it overlaps the full-bleed video + dock.
        final hideCartBubble = nav.useFrostedDock;

        return Scaffold(
          extendBody: true,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: contentBottomInset),
                child: nav.body[nav.currentIndex],
              ),
              if (!hideCartBubble)
                PositionedDirectional(
                  end: AppSpacing.dockMarginH,
                  bottom: bubbleBottom,
                  child: const CartBubbleWidget(),
                ),
            ],
          ),
          bottomNavigationBar: const CustomBottomNavBarWidget(),
        );
      },
    );
  }
}
