import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

/// Store Locator section — scrollable list of store cards with address,
/// hours, phone, and a "Get Directions" button that opens the map link.
class StoreLocatorSection extends StatelessWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const StoreLocatorSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final stores = section.storeItems.where((s) => s.name.isNotEmpty).toList();
    if (stores.isEmpty) return const SizedBox.shrink();

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
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, color: fg, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    section.title!,
                    style: TextStyle(
                      color: fg,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: stores.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final store = stores[index];
              return _StoreCard(
                store: store,
                fg: fg,
                onLinkTap: onLinkTap,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final StoreItem store;
  final Color fg;
  final void Function(String)? onLinkTap;

  const _StoreCard({
    required this.store,
    required this.fg,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store name
          Text(
            store.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          // Address
          if (store.address?.isNotEmpty == true)
            _InfoRow(
              icon: Icons.location_on_outlined,
              text: store.address!,
              color: Colors.grey[700]!,
            ),

          // Hours
          if (store.hours?.isNotEmpty == true)
            _InfoRow(
              icon: Icons.access_time_outlined,
              text: store.hours!,
              color: Colors.grey[700]!,
            ),

          // Phone
          if (store.phone?.isNotEmpty == true)
            GestureDetector(
              onTap: () => openLink('tel:${store.phone}', onLinkTap),
              child: _InfoRow(
                icon: Icons.phone_outlined,
                text: store.phone!,
                color: Colors.blue,
              ),
            ),

          // Directions button
          if (store.mapLink?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.directions_outlined, size: 16),
                label: const Text('Get Directions'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue[700],
                  side: BorderSide(color: Colors.blue[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onPressed: () => openLink(store.mapLink, onLinkTap),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
