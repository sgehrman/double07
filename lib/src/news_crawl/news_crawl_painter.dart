import 'package:double07/src/news_crawl/news_crawl_sequence.dart';
import 'package:flutter/material.dart';

class NewsCrawlPainter extends CustomPainter {
  NewsCrawlPainter(this.animationState);

  final NewsCrawlSequence animationState;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.save();
    canvas.clipRect(rect);

    final backPaint = Paint()..color = Colors.black;
    canvas.drawRect(rect, backPaint);

    animationState.paint(canvas, size);
    canvas.restore();
  }

  // =================================================

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
