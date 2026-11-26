import 'package:flutter/material.dart';
import 'package:flouka/core/tokens.dart';

enum FkIconKind {
  home,
  heart,
  gift,
  search,
  back,
  share,
  plus,
  menu,
  drag,
  eye,
  chart,
  user,
  shop,
  copy,
  close,
  chev,
  check,
  link,
  ig,
  tt,
  yt,
}

class FkIcon extends StatelessWidget {
  const FkIcon(this.kind, {super.key, this.color = FkTokens.ink, this.size = 20});

  final FkIconKind kind;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _FkIconPainter(kind, color),
    );
  }
}

class _FkIconPainter extends CustomPainter {
  _FkIconPainter(this.kind, this.color);
  final FkIconKind kind;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final s = size.width / 24;
    canvas.scale(s, s);
    final path = Path();
    switch (kind) {
      case FkIconKind.home:
        path.moveTo(4, 11);
        path.lineTo(12, 4);
        path.lineTo(20, 11);
        path.lineTo(20, 20);
        path.lineTo(4, 20);
        path.close();
      case FkIconKind.heart:
        path.moveTo(12, 20);
        path.lineTo(4.5, 12.6);
        path.cubicTo(2, 9.5, 5.5, 5.2, 12, 6.8);
        path.cubicTo(18.5, 5.2, 22, 9.5, 19.5, 12.6);
        path.close();
      case FkIconKind.gift:
        path.addRect(const Rect.fromLTWH(4, 9, 16, 11));
        path.moveTo(3, 9);
        path.lineTo(21, 9);
        path.moveTo(12, 9);
        path.lineTo(12, 20);
        path.moveTo(12, 9);
        path.cubicTo(10, 5, 6, 6, 8, 9);
        path.moveTo(12, 9);
        path.cubicTo(14, 5, 18, 6, 16, 9);
      case FkIconKind.search:
        path.addOval(Rect.fromCircle(center: const Offset(11, 11), radius: 6));
        path.moveTo(16, 16);
        path.lineTo(20, 20);
      case FkIconKind.back:
        path.moveTo(15, 5);
        path.lineTo(8, 12);
        path.lineTo(15, 19);
      case FkIconKind.share:
        path.moveTo(12, 15);
        path.lineTo(12, 4);
        path.moveTo(8, 8);
        path.lineTo(12, 4);
        path.lineTo(16, 8);
        path.moveTo(5, 13);
        path.lineTo(5, 20);
        path.lineTo(19, 20);
        path.lineTo(19, 13);
      case FkIconKind.plus:
        path.moveTo(12, 5);
        path.lineTo(12, 19);
        path.moveTo(5, 12);
        path.lineTo(19, 12);
      case FkIconKind.menu:
        path.moveTo(4, 7);
        path.lineTo(20, 7);
        path.moveTo(4, 12);
        path.lineTo(20, 12);
        path.moveTo(4, 17);
        path.lineTo(14, 17);
      case FkIconKind.drag:
        p.strokeWidth = 2.6;
        for (final y in [6.0, 12.0, 18.0]) {
          canvas.drawCircle(Offset(9, y), 0.6, p);
          canvas.drawCircle(Offset(15, y), 0.6, p);
        }
        return;
      case FkIconKind.eye:
        path.moveTo(2, 12);
        path.cubicTo(5, 6, 19, 6, 22, 12);
        path.cubicTo(19, 18, 5, 18, 2, 12);
        path.addOval(Rect.fromCircle(center: const Offset(12, 12), radius: 2.5));
      case FkIconKind.chart:
        path.moveTo(5, 20);
        path.lineTo(5, 12);
        path.moveTo(10, 20);
        path.lineTo(10, 6);
        path.moveTo(15, 20);
        path.lineTo(15, 10);
        path.moveTo(20, 20);
        path.lineTo(20, 4);
      case FkIconKind.user:
        path.addOval(Rect.fromCircle(center: const Offset(12, 8), radius: 4));
        path.moveTo(4, 21);
        path.cubicTo(5, 15, 19, 15, 20, 21);
      case FkIconKind.shop:
        path.moveTo(4, 9);
        path.lineTo(5.5, 4);
        path.lineTo(18.5, 4);
        path.lineTo(20, 9);
        path.addRect(const Rect.fromLTWH(4, 9, 16, 11));
        path.moveTo(9, 20);
        path.lineTo(9, 14);
        path.lineTo(15, 14);
        path.lineTo(15, 20);
      case FkIconKind.copy:
        path.addRect(const Rect.fromLTWH(8, 8, 11, 11));
        path.moveTo(5, 16);
        path.lineTo(5, 5);
        path.lineTo(16, 5);
      case FkIconKind.close:
        path.moveTo(6, 6);
        path.lineTo(18, 18);
        path.moveTo(18, 6);
        path.lineTo(6, 18);
      case FkIconKind.chev:
        path.moveTo(9, 5);
        path.lineTo(16, 12);
        path.lineTo(9, 19);
      case FkIconKind.check:
        path.moveTo(5, 12);
        path.lineTo(10, 17);
        path.lineTo(19, 7);
      case FkIconKind.link:
        path.moveTo(10, 14);
        path.lineTo(14, 10);
        path.moveTo(8.5, 11.5);
        path.lineTo(6.5, 13.5);
        path.moveTo(11.5, 8.5);
        path.lineTo(13.5, 6.5);
      case FkIconKind.ig:
        path.addRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(3.5, 3.5, 17, 17), const Radius.circular(4.5)));
        path.addOval(Rect.fromCircle(center: const Offset(12, 12), radius: 3.5));
        canvas.drawCircle(const Offset(17, 7), 0.4, p);
      case FkIconKind.tt:
        path.moveTo(14, 3.5);
        path.lineTo(14, 15);
        path.moveTo(14, 3.5);
        path.cubicTo(14.3, 6.3, 16.4, 8.2, 19.5, 8.4);
      case FkIconKind.yt:
        path.addRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(2.5, 6, 19, 12), const Radius.circular(4)));
        path.moveTo(10, 9.3);
        path.lineTo(15, 12);
        path.lineTo(10, 14.7);
        path.close();
    }
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant _FkIconPainter old) => old.kind != kind || old.color != color;
}
