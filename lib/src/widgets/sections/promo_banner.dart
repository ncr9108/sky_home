import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

class PromoBannerSection extends StatelessWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const PromoBannerSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = hexColor(section.bgColor);

    return GestureDetector(
      onTap: () => openLink(section.buttonLink, onLinkTap),
      child: Container(
        color: bg,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Banner image
            if (section.imageUrl?.isNotEmpty == true)
              SizedBox(
                height: 180,
                width: double.infinity,
                child: netImage(section.imageUrl, height: 180),
              )
            else
              Container(height: 180, width: double.infinity, color: bg),

            // Gradient overlay
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Colors.transparent, Colors.black45],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (section.title?.isNotEmpty == true)
                    Text(
                      section.title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (section.subtitle?.isNotEmpty == true) ...[
                    const SizedBox(height: 6),
                    Text(
                      section.subtitle!,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                  if (section.buttonText?.isNotEmpty == true) ...[
                    const SizedBox(height: 14),
                    SectionButton(
                      text: section.buttonText,
                      link: section.buttonLink,
                      onLinkTap: onLinkTap,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
