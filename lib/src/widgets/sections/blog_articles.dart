import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

/// Blog / Articles section — horizontal scroll of article cards with image,
/// title, excerpt, and date.
class BlogArticlesSection extends StatelessWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const BlogArticlesSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final articles = section.articleItems
        .where((a) => a.title.isNotEmpty)
        .toList();
    if (articles.isEmpty) return const SizedBox.shrink();

    final bg = hexColor(section.bgColor);
    final fg = hexColor(section.textColor, fallback: Colors.black);

    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    section.title ?? 'Blog',
                    style: TextStyle(
                      color: fg,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (section.buttonText?.isNotEmpty == true &&
                    section.buttonLink?.isNotEmpty == true)
                  GestureDetector(
                    onTap: () =>
                        openLink(section.buttonLink, onLinkTap),
                    child: Text(
                      section.buttonText!,
                      style: TextStyle(
                        color: fg.withOpacity(0.6),
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                        decorationColor: fg.withOpacity(0.6),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Horizontal article cards
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () => openLink(article.link, onLinkTap),
                  child: Container(
                    width: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnail
                        SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: article.imageUrl?.isNotEmpty == true
                              ? netImage(article.imageUrl, fit: BoxFit.cover)
                              : Container(
                                  color: Colors.grey[100],
                                  child: Center(
                                    child: Icon(
                                      Icons.article_outlined,
                                      color: Colors.grey[400],
                                      size: 36,
                                    ),
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date
                              if (article.date?.isNotEmpty == true)
                                Text(
                                  article.date!,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              const SizedBox(height: 4),
                              // Title
                              Text(
                                article.title,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Excerpt
                              if (article.excerpt?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  article.excerpt!,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 11,
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
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
