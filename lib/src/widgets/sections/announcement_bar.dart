import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

/// Announcement / ticker bar — shows [section.title] as a scrolling marquee
/// (if [section.announcementMarquee] is true) or a static centred label.
class AnnouncementBarSection extends StatefulWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const AnnouncementBarSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  State<AnnouncementBarSection> createState() => _AnnouncementBarSectionState();
}

class _AnnouncementBarSectionState extends State<AnnouncementBarSection>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scroll;
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );

    if (widget.section.announcementMarquee) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startMarquee());
    }
  }

  Future<void> _startMarquee() async {
    while (mounted && widget.section.announcementMarquee) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted || !_scroll.hasClients) return;
      await _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(seconds: 16),
        curve: Curves.linear,
      );
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 500));
      _scroll.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.section.title ?? '';
    if (text.isEmpty) return const SizedBox.shrink();

    final bg = hexColor(widget.section.bgColor, fallback: Colors.black);
    final fg = hexColor(widget.section.textColor, fallback: Colors.white);
    final isMarquee = widget.section.announcementMarquee;
    final hasLink = widget.section.buttonLink?.isNotEmpty == true;

    Widget content = Text(
      text,
      style: TextStyle(
        color: fg,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      maxLines: isMarquee ? 1 : null,
      textAlign: isMarquee ? TextAlign.left : TextAlign.center,
    );

    if (isMarquee) {
      content = SingleChildScrollView(
        controller: _scroll,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: content,
        ),
      );
    }

    return GestureDetector(
      onTap: hasLink
          ? () => openLink(widget.section.buttonLink, widget.onLinkTap)
          : null,
      child: Container(
        width: double.infinity,
        color: bg,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: content,
      ),
    );
  }
}
