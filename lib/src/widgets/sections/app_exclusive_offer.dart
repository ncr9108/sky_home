import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

/// App-Exclusive Offer banner — a richly styled full-width card that
/// highlights a deal only available in the app.
class AppExclusiveOfferSection extends StatelessWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const AppExclusiveOfferSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = hexColor(section.bgColor, fallback: const Color(0xFF6C3DE8));
    final fg = hexColor(section.textColor, fallback: Colors.white);
    final hasLink = section.buttonLink?.isNotEmpty == true;
    final hasImage = section.imageUrl?.isNotEmpty == true;

    return GestureDetector(
      onTap: hasLink ? () => openLink(section.buttonLink, onLinkTap) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: bg.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background decorative circles
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              Positioned(
                right: 40,
                bottom: -30,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // "APP EXCLUSIVE" chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.smartphone,
                                    color: Colors.white, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  'APP EXCLUSIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (section.title?.isNotEmpty == true)
                            Text(
                              section.title!,
                              style: TextStyle(
                                color: fg,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          if (section.subtitle?.isNotEmpty == true) ...[
                            const SizedBox(height: 6),
                            Text(
                              section.subtitle!,
                              style: TextStyle(
                                color: fg.withOpacity(0.85),
                                fontSize: 13,
                              ),
                            ),
                          ],
                          if (section.buttonText?.isNotEmpty == true) ...[
                            const SizedBox(height: 14),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: fg,
                                foregroundColor: bg,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: hasLink
                                  ? () => openLink(section.buttonLink, onLinkTap)
                                  : null,
                              child: Text(
                                section.buttonText!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (hasImage) ...[
                      const SizedBox(width: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 90,
                          height: 90,
                          child: netImage(section.imageUrl),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
