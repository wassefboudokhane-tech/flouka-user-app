import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flouka/core/config/app_color.dart';
import 'package:flutter/material.dart';

/// The logo's paper boat as a loader: it unfolds into a boat, then folds
/// back into a flat sheet, over a small moving wave.
class FloukaBoatLoader extends StatefulWidget {
  const FloukaBoatLoader({super.key, this.size = 96, this.color, this.seaColor});

  /// Width of the drawing; the height follows.
  final double size;
  final Color? color;
  final Color? seaColor;

  @override
  State<FloukaBoatLoader> createState() => _FloukaBoatLoaderState();
}

class _FloukaBoatLoaderState extends State<FloukaBoatLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Chargement',
      child: SizedBox(
        width: widget.size,
        height: widget.size * 0.72,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: BoatLoaderPainter(
              t: _controller.value,
              color: widget.color ?? AppColor.inkColor,
              seaColor: widget.seaColor ?? const Color(0xFF5FA8C2),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints one frame. [t] runs 0 → 1: unfold (0 → 0.4), hold, fold (0.6 → 1).
class BoatLoaderPainter extends CustomPainter {
  BoatLoaderPainter({required this.t, required this.color, required this.seaColor});

  final double t;
  final Color color;
  final Color seaColor;

  // Same drawing as the logo, in a 300 × 150 box: the open boat…
  static const _open = [
    Offset(0, 52), Offset(112, 74), Offset(168, 0), Offset(222, 74),
    Offset(300, 52), Offset(232, 138), Offset(72, 150),
  ];
  // …and the folded sheet it comes from: the sail lies down, the points tuck in.
  static const _closed = [
    Offset(70, 96), Offset(112, 96), Offset(168, 88), Offset(222, 96),
    Offset(230, 96), Offset(230, 126), Offset(70, 126),
  ];

  /// How open the boat is, 0 (folded) to 1 (boat).
  static double openness(double t) {
    double ease(double x) => Curves.easeInOutCubic.transform(x.clamp(0.0, 1.0));
    if (t < 0.4) return ease(t / 0.4);
    if (t < 0.6) return 1;
    return 1 - ease((t - 0.6) / 0.4);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / 300;
    final o = openness(t);
    Offset p(int i) => Offset.lerp(_closed[i], _open[i], o)! * k;
    final stroke = math.max(2.0, 17 * k);
    final ink = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    // Outline, with the curved keel of the logo.
    final keelControl = Offset(lerpDouble(150, 160, o)!, lerpDouble(126, 128, o)!) * k;
    final outline = Path()..moveTo(p(0).dx, p(0).dy);
    for (var i = 1; i <= 5; i++) {
      outline.lineTo(p(i).dx, p(i).dy);
    }
    outline
      ..quadraticBezierTo(keelControl.dx, keelControl.dy, p(6).dx, p(6).dy)
      ..close();
    canvas.drawPath(outline, ink);

    // The folds: across the hull, and down the middle of the sail.
    final foldControl = Offset(167, lerpDouble(100, 92, o)!) * k;
    final folds = Path()
      ..moveTo(p(1).dx, p(1).dy)
      ..quadraticBezierTo(foldControl.dx, foldControl.dy, p(3).dx, p(3).dy)
      ..moveTo(p(2).dx, p(2).dy)
      ..lineTo(lerpDouble(168, 166, o)! * k, lerpDouble(96, 84, o)! * k);
    canvas.drawPath(folds, ink);

    // The wave under it keeps moving.
    final sea = Paint()
      ..color = seaColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final wave = Path();
    const steps = 48;
    for (var i = 0; i <= steps; i++) {
      final x = 20 + 260 * i / steps;
      final y = 192 - 10 * math.sin((i / steps) * 3 * math.pi + t * 2 * math.pi);
      i == 0 ? wave.moveTo(x * k, y * k) : wave.lineTo(x * k, y * k);
    }
    canvas.drawPath(wave, sea);
  }

  @override
  bool shouldRepaint(BoatLoaderPainter old) => old.t != t || old.color != color;
}
