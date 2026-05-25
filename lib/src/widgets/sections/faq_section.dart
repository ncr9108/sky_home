import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

/// FAQ / Accordion section — expandable Q&A panels.
class FaqSection extends StatelessWidget {
  final HomeSection section;

  const FaqSection({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final faqs = section.faqItems
        .where((f) => f.question.isNotEmpty)
        .toList();
    if (faqs.isEmpty) return const SizedBox.shrink();

    final bg = hexColor(section.bgColor);
    final fg = hexColor(section.textColor, fallback: Colors.black);
    final dividerColor = fg.withOpacity(0.12);

    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                section.title!,
                style: TextStyle(
                  color: fg,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ...faqs.map(
            (faq) => _FaqTile(faq: faq, fg: fg, dividerColor: dividerColor),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final FaqItem faq;
  final Color fg;
  final Color dividerColor;

  const _FaqTile({
    required this.faq,
    required this.fg,
    required this.dividerColor,
  });

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, color: widget.dividerColor),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding:
                const EdgeInsets.fromLTRB(16, 0, 16, 14),
            title: Text(
              widget.faq.question,
              style: TextStyle(
                color: widget.fg,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            trailing: AnimatedRotation(
              turns: _expanded ? 0.25 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.chevron_right,
                  color: widget.fg.withOpacity(0.5)),
            ),
            onExpansionChanged: (v) => setState(() => _expanded = v),
            children: [
              if (widget.faq.answer.isNotEmpty)
                Text(
                  widget.faq.answer,
                  style: TextStyle(
                    color: widget.fg.withOpacity(0.75),
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
