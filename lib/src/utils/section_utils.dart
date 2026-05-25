import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

/// Converts a hex color string (#RRGGBB or #AARRGGBB) to a Flutter [Color].
Color hexColor(String? hex, {Color fallback = Colors.white}) {
  if (hex == null || hex.isEmpty) return fallback;
  try {
    final clean = hex.replaceAll('#', '');
    final padded = clean.length == 6 ? 'FF$clean' : clean;
    return Color(int.parse(padded, radix: 16));
  } catch (_) {
    return fallback;
  }
}

/// Opens [link] — calls [onLinkTap] if provided, otherwise uses url_launcher.
Future<void> openLink(String? link, void Function(String)? onLinkTap) async {
  if (link == null || link.trim().isEmpty) return;
  if (onLinkTap != null) {
    onLinkTap(link.trim());
    return;
  }
  final raw = link.trim();
  final full = raw.startsWith('http') ? raw : 'https://$raw';
  final uri = Uri.tryParse(full);
  if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Cached network image with built-in placeholder and error states.
Widget netImage(
  String? url, {
  BoxFit fit = BoxFit.cover,
  double? height,
  double? width,
  Color placeholderColor = const Color(0xFFEEEEEE),
}) {
  if (url == null || url.trim().isEmpty) {
    return _placeholder(height: height, width: width, color: placeholderColor);
  }
  return CachedNetworkImage(
    imageUrl: url.trim(),
    fit: fit,
    height: height,
    width: width,
    placeholder: (_, __) =>
        _placeholder(height: height, width: width, color: placeholderColor),
    errorWidget: (_, __, ___) => _placeholder(
      height: height,
      width: width,
      color: placeholderColor,
      icon: Icons.broken_image_outlined,
    ),
  );
}

Widget _placeholder({
  double? height,
  double? width,
  Color color = const Color(0xFFEEEEEE),
  IconData icon = Icons.image_outlined,
}) {
  return Container(
    height: height,
    width: width,
    color: color,
    child: Center(child: Icon(icon, color: Colors.grey[400])),
  );
}

/// A simple CTA button used across multiple section types.
class SectionButton extends StatelessWidget {
  final String? text;
  final String? link;
  final void Function(String)? onLinkTap;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const SectionButton({
    super.key,
    required this.text,
    required this.link,
    this.onLinkTap,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (text == null || text!.isEmpty) return const SizedBox.shrink();
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.black,
        foregroundColor: foregroundColor ?? Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
      onPressed: () => openLink(link, onLinkTap),
      child: Text(text!, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
