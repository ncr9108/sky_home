import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

/// Renders a video thumbnail with a play button.
/// Tapping opens the video URL in the browser via url_launcher.
/// Pass [onLinkTap] to handle navigation yourself (e.g., push a video player screen).
class VideoBlockSection extends StatelessWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const VideoBlockSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = hexColor(section.bgColor);
    final fg = hexColor(section.textColor, fallback: Colors.black);
    // imageUrl = video URL, subtitle = thumbnail image URL
    final videoUrl = section.imageUrl;
    final thumbnail = section.subtitle;

    return Container(
      color: bg,
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 12),

          // Thumbnail + play button
          GestureDetector(
            onTap: () => openLink(videoUrl, onLinkTap),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: thumbnail?.isNotEmpty == true
                        ? netImage(thumbnail, height: 200)
                        : Container(
                            height: 200,
                            color: Colors.black87,
                          ),
                  ),
                ),
                // Play button circle
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),

          if (section.bodyText?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            Text(
              section.bodyText!,
              style: TextStyle(color: fg.withOpacity(0.8), fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}
