import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

/// Renders a single featured product.
/// Uses the injected product data from the backend when available,
/// falls back to section.imageUrl if set manually.
class ProductHighlightSection extends StatelessWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const ProductHighlightSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = hexColor(section.bgColor);
    final fg = hexColor(section.textColor, fallback: Colors.black);

    // Use the injected product if available, otherwise fall back to manual fields
    final product = section.products.isNotEmpty ? section.products.first : null;
    final imageUrl = section.imageUrl?.isNotEmpty == true
        ? section.imageUrl
        : product?.imageUrl;
    final productTitle = product?.title ?? section.subtitle ?? '';
    final price = product?.formattedPrice ?? '';

    return Container(
      color: bg,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section heading
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

          // Product row
          GestureDetector(
            onTap: product != null
                ? () => openLink(product.id, onLinkTap)
                : (section.buttonLink?.isNotEmpty == true
                    ? () => openLink(section.buttonLink, onLinkTap)
                    : null),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 140,
                    height: 160,
                    child: netImage(imageUrl, height: 160, width: 140),
                  ),
                ),
                const SizedBox(width: 16),

                // Product info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (productTitle.isNotEmpty)
                        Text(
                          productTitle,
                          style: TextStyle(
                            color: fg,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      if (price.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          price,
                          style: TextStyle(
                            color: fg.withOpacity(0.75),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      SectionButton(
                        text: section.buttonText ?? 'View Product',
                        link: section.buttonLink ??
                            (product != null ? product.id : null),
                        onLinkTap: onLinkTap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
