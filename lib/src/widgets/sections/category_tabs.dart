import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

/// Category tabs — horizontal scroll of circle-image tiles with labels.
class CategoryTabsSection extends StatelessWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const CategoryTabsSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = section.categoryItems
        .where((c) => c.title.isNotEmpty)
        .toList();
    if (items.isEmpty) return const SizedBox.shrink();

    final bg = hexColor(section.bgColor);
    final fg = hexColor(section.textColor, fallback: Colors.black);

    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                section.title!,
                style: TextStyle(
                  color: fg,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () => openLink(item.link, onLinkTap),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        // Circle image
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: item.imageUrl?.isNotEmpty == true
                              ? netImage(item.imageUrl, fit: BoxFit.cover)
                              : Center(
                                  child: Icon(
                                    Icons.category_outlined,
                                    color: Colors.grey[400],
                                    size: 28,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 68,
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: fg,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
