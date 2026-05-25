import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

/// Video slider — horizontal PageView of video thumbnails with play buttons.
/// Tapping a video opens its URL (or calls [onLinkTap] with the link field).
class VideoSliderSection extends StatefulWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const VideoSliderSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  State<VideoSliderSection> createState() => _VideoSliderSectionState();
}

class _VideoSliderSectionState extends State<VideoSliderSection> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videos = widget.section.videoSlides;
    if (videos.isEmpty) return const SizedBox.shrink();

    final bg = hexColor(widget.section.bgColor);
    final fg = hexColor(widget.section.textColor, fallback: Colors.black);

    return Container(
      color: bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.section.title?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                widget.section.title!,
                style: TextStyle(
                  color: fg,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // Video PageView
          SizedBox(
            height: 220,
            child: PageView.builder(
              controller: _controller,
              itemCount: videos.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, index) {
                final video = videos[index];
                // Tap link: use video.link if set, else open the video URL directly
                final tapTarget = video.link?.isNotEmpty == true
                    ? video.link
                    : video.url;

                return GestureDetector(
                  onTap: () => openLink(tapTarget, widget.onLinkTap),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Thumbnail (or dark background if none)
                          video.thumbnail?.isNotEmpty == true
                              ? netImage(video.thumbnail)
                              : Container(color: Colors.black87),

                          // Play button overlay
                          Center(
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),

                          // Title overlay at bottom
                          if (video.title?.isNotEmpty == true)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [Colors.black54, Colors.transparent],
                                  ),
                                ),
                                child: Text(
                                  video.title!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Dot indicators
          if (videos.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(videos.length, (i) {
                  final active = i == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? fg : fg.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
