import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/categories/presentation/view/categories_tab_content.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/navbar/presentation/provider/nav_bar_provider.dart';
import 'package:flouka/features/reels/presentation/providers/video_provider.dart';
import 'package:flouka/features/reels/presentation/views/reels_tab_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NavBarProvider>().setExploreTabIndex(_tabIndex);
    });
  }

  void _selectTab(int index) {
    if (_tabIndex == index) return;
    setState(() => _tabIndex = index);
    context.read<NavBarProvider>().setExploreTabIndex(index);
    if (index == 1) {
      final videoProvider = context.read<VideoProvider>();
      if (videoProvider.reelItems == null) {
        videoProvider.refresh();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageGutter,
                6,
                AppSpacing.pageGutter,
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LanguageProvider.translate('navbar', 'explore'),
                    style: TextStyleClass.screenTitleStyle(),
                  ),
                  const SizedBox(height: 14),
                  _ExploreSegmentedTabs(
                    index: _tabIndex,
                    onChanged: _selectTab,
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _tabIndex,
                children: const [
                  CategoriesTabContent(),
                  ReelsTabContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreSegmentedTabs extends StatelessWidget {
  const _ExploreSegmentedTabs({
    required this.index,
    required this.onChanged,
  });

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segment(
              label: LanguageProvider.translate('navbar', 'categories'),
              selected: index == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _Segment(
              label: LanguageProvider.translate('navbar', 'reels'),
              selected: index == 1,
              showNewBadge: true,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
    this.showNewBadge = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool showNewBadge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColor.deepColor : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyleClass.smallStyle(
                  color: selected
                      ? AppColor.backgroundColor
                      : AppColor.mutedColor,
                ).copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  fontSize: 13.5,
                ),
              ),
              if (showNewBadge && !selected) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColor.limeColor,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    LanguageProvider.translate('navbar', 'reels_new'),
                    style: TextStyleClass.captionStyle(
                      color: AppColor.deepColor,
                    ).copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 9,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
