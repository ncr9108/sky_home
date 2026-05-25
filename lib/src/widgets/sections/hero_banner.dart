import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

class HeroBannerSection extends StatelessWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const HeroBannerSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = hexColor(section.bgColor);
    final fg = hexColor(section.textColor, fallback: Colors.white);

    return Container(
      color: bg,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background image
          if (section.imageUrl?.isNotEmpty == true)
            SizedBox(
              height: 420,
              width: double.infinity,
              child: netImage(section.imageUrl, height: 420),
            )
          else
            Container(
              height: 420,
              width: double.infinity,
              color: bg,
            ),

          // Dark overlay for text readability
          if (section.imageUrl?.isNotEmpty == true)
            Container(
              height: 420,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),

          // Text + button
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (section.title?.isNotEmpty == true)
                  Text(
                    section.title!,
                    style: TextStyle(
                      color: section.imageUrl?.isNotEmpty == true
                          ? Colors.white
                          : fg,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                if (section.subtitle?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  Text(
                    section.subtitle!,
                    style: TextStyle(
                      color: section.imageUrl?.isNotEmpty == true
                          ? Colors.white70
                          : fg.withOpacity(0.8),
                      fontSize: 16,
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
          ),
        ],
      ),
    );
  }
}
