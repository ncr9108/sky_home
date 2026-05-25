import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

/// Flash Sale / Deal of the Day section.
/// Shows a product image, original vs sale price, discount badge, and a
/// live countdown to [section.countdownEnd].
class FlashSaleSection extends StatelessWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const FlashSaleSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final data = section.flashSaleData;
    final bg = hexColor(section.bgColor, fallback: const Color(0xFFFF3B30));
    final fg = hexColor(section.textColor, fallback: Colors.white);
    final hasLink = section.buttonLink?.isNotEmpty == true;

    final originalPrice = data['originalPrice'] ?? '';
    final salePrice = data['salePrice'] ?? '';
    final discountPercent = data['discountPercent'] ?? '';
    final badge = data['badge'] ?? '';

    return Container(
      color: bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                const Icon(Icons.flash_on, color: Colors.yellow, size: 22),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    section.title ?? 'Flash Sale',
                    style: TextStyle(
                      color: fg,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (badge.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.yellow[700],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Countdown ─────────────────────────────────────────────────────
          if (section.countdownEnd != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: _CountdownRow(
                end: section.countdownEnd!,
                labelColor: fg.withOpacity(0.8),
                digitColor: fg,
              ),
            ),

          // ── Product card ──────────────────────────────────────────────────
          GestureDetector(
            onTap: hasLink
                ? () => openLink(section.buttonLink, onLinkTap)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  if (section.imageUrl?.isNotEmpty == true)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: netImage(section.imageUrl),
                      ),
                    ),
                  const SizedBox(width: 14),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (section.subtitle?.isNotEmpty == true)
                          Text(
                            section.subtitle!,
                            style: TextStyle(
                              color: fg.withOpacity(0.85),
                              fontSize: 13,
                            ),
                          ),
                        const SizedBox(height: 6),
                        if (salePrice.isNotEmpty)
                          Text(
                            salePrice,
                            style: TextStyle(
                              color: fg,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (originalPrice.isNotEmpty)
                          Text(
                            originalPrice,
                            style: TextStyle(
                              color: fg.withOpacity(0.6),
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: fg.withOpacity(0.6),
                            ),
                          ),
                        if (discountPercent.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '$discountPercent% OFF',
                                style: TextStyle(
                                  color: fg,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        if (section.buttonText?.isNotEmpty == true)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: fg,
                                foregroundColor: bg,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: hasLink
                                  ? () => openLink(section.buttonLink, onLinkTap)
                                  : null,
                              child: Text(
                                section.buttonText!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A compact live countdown row used inside FlashSaleSection.
class _CountdownRow extends StatefulWidget {
  final DateTime end;
  final Color labelColor;
  final Color digitColor;

  const _CountdownRow({
    required this.end,
    required this.labelColor,
    required this.digitColor,
  });

  @override
  State<_CountdownRow> createState() => _CountdownRowState();
}

class _CountdownRowState extends State<_CountdownRow> {
  late Duration _remaining;
  late final Stream<Duration> _stream;

  @override
  void initState() {
    super.initState();
    _remaining = _calc();
    _stream = Stream.periodic(const Duration(seconds: 1), (_) => _calc());
  }

  Duration _calc() {
    final diff = widget.end.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: _stream,
      initialData: _remaining,
      builder: (context, snapshot) {
        final d = snapshot.data ?? Duration.zero;
        final h = d.inHours.toString().padLeft(2, '0');
        final m = (d.inMinutes % 60).toString().padLeft(2, '0');
        final s = (d.inSeconds % 60).toString().padLeft(2, '0');

        return Row(
          children: [
            Icon(Icons.timer_outlined, size: 14, color: widget.labelColor),
            const SizedBox(width: 6),
            Text(
              'Ends in: ',
              style: TextStyle(color: widget.labelColor, fontSize: 12),
            ),
            _Digit(value: h, color: widget.digitColor),
            _Sep(color: widget.digitColor),
            _Digit(value: m, color: widget.digitColor),
            _Sep(color: widget.digitColor),
            _Digit(value: s, color: widget.digitColor),
          ],
        );
      },
    );
  }
}

class _Digit extends StatelessWidget {
  final String value;
  final Color color;
  const _Digit({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

class _Sep extends StatelessWidget {
  final Color color;
  const _Sep({required this.color});

  @override
  Widget build(BuildContext context) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Text(':', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      );
}
