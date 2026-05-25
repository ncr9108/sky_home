import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

class TestimonialSection extends StatelessWidget {
  final HomeSection section;

  const TestimonialSection({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final reviews = section.reviews;
    if (reviews.isEmpty) return const SizedBox.shrink();

    final bg = hexColor(section.bgColor);
    final fg = hexColor(section.textColor, fallback: Colors.black);

    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                section.title!,
                style: TextStyle(
                  color: fg,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 14),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: reviews.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final review = reviews[index];
                final name = review['name'] as String? ?? 'Customer';
                final text = review['text'] as String? ?? '';
                final rating = (review['rating'] as num?)?.toInt() ?? 5;
                final avatar = review['avatar'] as String?;

                return Container(
                  width: 220,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: fg.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: fg.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stars
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Review text
                      Expanded(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: fg.withOpacity(0.85),
                            fontSize: 13,
                            height: 1.4,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Reviewer
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: fg.withOpacity(0.15),
                            backgroundImage: avatar?.isNotEmpty == true
                                ? NetworkImage(avatar!)
                                : null,
                            child: avatar?.isNotEmpty == true
                                ? null
                                : Text(
                                    name.isNotEmpty
                                        ? name[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      color: fg,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(
                                color: fg,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
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
