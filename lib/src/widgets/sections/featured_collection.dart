import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

/// Renders a featured collection section.
/// Shows real product cards when the backend injects product data.
/// Falls back to placeholders if no products are available.
class FeaturedCollectionSection extends StatelessWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const FeaturedCollectionSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = hexColor(section.bgColor);
    final fg = hexColor(section.textColor, fallback: Colors.black);
    final products = section.products;
    final isHorizontal = section.displayStyle == 'horizontal_scroll';
    final count = products.isNotEmpty
        ? products.length
        : (section.maxProducts ?? 4);

    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    section.collectionTitle ?? section.title ?? 'Collection',
                    style: TextStyle(
                      color: fg,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (section.buttonText?.isNotEmpty == true ||
                    section.collectionId?.isNotEmpty == true)
                  GestureDetector(
                    onTap: () => openLink(
                      section.buttonLink ?? section.collectionId,
                      onLinkTap,
                    ),
                    child: Text(
                      section.buttonText ?? 'View All',
                      style: TextStyle(
                        color: fg.withOpacity(0.65),
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Product grid / horizontal scroll ──────────────────────────────
          if (isHorizontal)
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: count,
                itemBuilder: (ctx, i) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: 150,
                    child: _ProductCard(
                      product: products.length > i ? products[i] : null,
                      fg: fg,
                      onTap: products.length > i
                          ? () => openLink(products[i].id, onLinkTap)
                          : null,
                    ),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.72,
                ),
                itemCount: count,
                itemBuilder: (ctx, i) => _ProductCard(
                  product: products.length > i ? products[i] : null,
                  fg: fg,
                  onTap: products.length > i
                      ? () => openLink(products[i].id, onLinkTap)
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductItem? product;
  final Color fg;
  final VoidCallback? onTap;

  const _ProductCard({this.product, required this.fg, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: product?.imageUrl != null
                    ? netImage(product!.imageUrl,
                        width: double.infinity, fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(Icons.shopping_bag_outlined,
                              color: Colors.grey[400], size: 36),
                        ),
                      ),
              ),
            ),
            // Product info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product?.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: fg,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  if (product?.formattedPrice.isNotEmpty == true) ...[
                    const SizedBox(height: 4),
                    Text(
                      product!.formattedPrice,
                      style: TextStyle(
                        color: fg.withOpacity(0.75),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
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
