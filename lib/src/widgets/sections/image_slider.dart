import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

class ImageSliderSection extends StatefulWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const ImageSliderSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  State<ImageSliderSection> createState() => _ImageSliderSectionState();
}

class _ImageSliderSectionState extends State<ImageSliderSection> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = widget.section.slides;
    if (slides.isEmpty) return const SizedBox.shrink();

    final bg = hexColor(widget.section.bgColor);
    final fg = hexColor(widget.section.textColor, fallback: Colors.black);

    return Container(
      color: bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Optional section title
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

          // Slider
          SizedBox(
            height: 240,
            child: PageView.builder(
              controller: _controller,
              itemCount: slides.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, index) {
                final slide = slides[index];
                return GestureDetector(
                  // Each slide has its OWN tap link
                  onTap: slide.link?.isNotEmpty == true
                      ? () => openLink(slide.link, widget.onLinkTap)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          netImage(slide.url.isNotEmpty ? slide.url : null),
                          // Per-slide title overlay
                          if (slide.title?.isNotEmpty == true)
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
                                  slide.title!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
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
          if (slides.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(slides.length, (i) {
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
