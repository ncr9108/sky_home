import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

class BannerGridSection extends StatelessWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const BannerGridSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final banners = section.bannerItems
        .where((b) => b.mediaUrl.isNotEmpty)
        .toList();
    if (banners.isEmpty) return const SizedBox.shrink();

    final bg = hexColor(section.bgColor);
    final fg = hexColor(section.textColor, fallback: Colors.black);

    return Container(
      color: bg,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title?.isNotEmpty == true) ...[
            Text(
              section.title!,
              style: TextStyle(
                color: fg,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
          ],
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return _BannerCard(
                banner: banner,
                onLinkTap: onLinkTap,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  final BannerItem banner;
  final void Function(String)? onLinkTap;

  const _BannerCard({required this.banner, this.onLinkTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openLink(banner.link, onLinkTap),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Media (image or video thumbnail) ────────────────────────────
            if (banner.isVideo)
              _VideoThumbnail(url: banner.mediaUrl)
            else
              netImage(banner.mediaUrl),

            // ── Gradient overlay (always shown for readability) ──────────────
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black54, Colors.transparent],
                  stops: [0.0, 0.55],
                ),
              ),
            ),

            // ── Play icon for videos ─────────────────────────────────────────
            if (banner.isVideo)
              Center(
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),

            // ── Title (only if showTitle == true) ────────────────────────────
            if (banner.showTitle && banner.title?.isNotEmpty == true)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Text(
                    banner.title!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Shows a dark thumbnail with a network image overlay (for video).
/// The actual image is the video's thumbnail stored in mediaUrl.
/// If no thumbnail is set, shows a dark placeholder.
class _VideoThumbnail extends StatelessWidget {
  final String url;
  const _VideoThumbnail({required this.url});

  @override
  Widget build(BuildContext context) {
    // If the URL looks like a direct video (mp4/mov), show a dark bg.
    // If it's YouTube/Vimeo, we can't easily get the thumbnail here
    // without an API call, so show a dark bg too.
    final looksLikeImage = url.contains('.jpg') ||
        url.contains('.jpeg') ||
        url.contains('.png') ||
        url.contains('.webp');

    if (looksLikeImage) {
      return netImage(url);
    }
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Icon(Icons.videocam_outlined, color: Colors.grey[600], size: 36),
      ),
    );
  }
}
