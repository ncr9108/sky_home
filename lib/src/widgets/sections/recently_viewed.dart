import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

/// Recently Viewed products section.
///
/// Requires the host app to provide a [recentlyViewedBuilder] that receives
/// the [HomeSection] and renders product cards for the recently viewed items.
/// If no builder is provided, a placeholder message is shown in debug mode
/// and the section is hidden in release builds.
class RecentlyViewedSection extends StatelessWidget {
  final HomeSection section;
  /// Builder callback — receives [context] and [section]. Typically renders
  /// a horizontal list of recently viewed product cards from local storage.
  final Widget Function(BuildContext, HomeSection)? recentlyViewedBuilder;
  final void Function(String)? onLinkTap;

  const RecentlyViewedSection({
    super.key,
    required this.section,
    this.recentlyViewedBuilder,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = hexColor(section.bgColor);
    final fg = hexColor(section.textColor, fallback: Colors.black);

    if (recentlyViewedBuilder != null) {
      return Container(
        color: bg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (section.title?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(
                  section.title!,
                  style: TextStyle(
                    color: fg,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            recentlyViewedBuilder!(context, section),
          ],
        ),
      );
    }

    // Debug placeholder — hidden in release
    assert(() {
      debugPrint(
        '[SkyHome] RecentlyViewedSection: pass recentlyViewedBuilder to '
        'SkyHomeWidget to render this section.',
      );
      return true;
    }());

    return const SizedBox.shrink();
  }
}
