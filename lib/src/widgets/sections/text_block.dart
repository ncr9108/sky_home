import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

class TextBlockSection extends StatelessWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const TextBlockSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = hexColor(section.bgColor);
    final fg = hexColor(section.textColor, fallback: Colors.black);

    return Container(
      color: bg,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title?.isNotEmpty == true)
            Text(
              section.title!,
              style: TextStyle(
                color: fg,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (section.bodyText?.isNotEmpty == true) ...[
            const SizedBox(height: 10),
            Text(
              section.bodyText!,
              style: TextStyle(
                color: fg.withOpacity(0.85),
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ],
          if (section.buttonText?.isNotEmpty == true) ...[
            const SizedBox(height: 20),
            SectionButton(
              text: section.buttonText,
              link: section.buttonLink,
              onLinkTap: onLinkTap,
            ),
          ],
        ],
      ),
    );
  }
}
