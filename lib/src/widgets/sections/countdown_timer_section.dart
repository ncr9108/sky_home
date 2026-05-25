import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

class CountdownTimerSection extends StatefulWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const CountdownTimerSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  State<CountdownTimerSection> createState() => _CountdownTimerSectionState();
}

class _CountdownTimerSectionState extends State<CountdownTimerSection> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _update();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _update());
  }

  void _update() {
    final end = widget.section.countdownEnd;
    if (end == null) return;
    final diff = end.difference(DateTime.now());
    if (mounted) setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = hexColor(widget.section.bgColor, fallback: const Color(0xFF1A1A2E));
    final fg = hexColor(widget.section.textColor, fallback: Colors.white);
    final expired = _remaining == Duration.zero;

    final days = _remaining.inDays;
    final hours = _remaining.inHours.remainder(24);
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);

    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      child: Column(
        children: [
          // Title
          if (widget.section.title?.isNotEmpty == true)
            Text(
              widget.section.title!,
              style: TextStyle(
                color: fg,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          if (widget.section.countdownLabel?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(
              widget.section.countdownLabel!,
              style: TextStyle(color: fg.withOpacity(0.7), fontSize: 14),
            ),
          ],
          const SizedBox(height: 20),

          // Timer blocks
          if (!expired)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _block(days, 'DAYS', fg),
                _colon(fg),
                _block(hours, 'HRS', fg),
                _colon(fg),
                _block(minutes, 'MIN', fg),
                _colon(fg),
                _block(seconds, 'SEC', fg),
              ],
            )
          else
            Text(
              'Sale has ended',
              style: TextStyle(
                color: fg.withOpacity(0.6),
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),

          if (widget.section.subtitle?.isNotEmpty == true) ...[
            const SizedBox(height: 16),
            Text(
              widget.section.subtitle!,
              style: TextStyle(color: fg.withOpacity(0.8), fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],

          if (widget.section.buttonText?.isNotEmpty == true && !expired) ...[
            const SizedBox(height: 20),
            SectionButton(
              text: widget.section.buttonText,
              link: widget.section.buttonLink,
              onLinkTap: widget.onLinkTap,
              backgroundColor: fg,
              foregroundColor: bg,
            ),
          ],
        ],
      ),
    );
  }

  Widget _block(int value, String label, Color fg) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: fg.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              value.toString().padLeft(2, '0'),
              style: TextStyle(
                color: fg,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: fg.withOpacity(0.6), fontSize: 11)),
      ],
    );
  }

  Widget _colon(Color fg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 6, right: 6),
      child: Text(
        ':',
        style: TextStyle(
          color: fg,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
