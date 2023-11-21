import 'package:double07/src/animation_state.dart';
import 'package:flutter/material.dart';

class DeckrAnimationPainter extends CustomPainter {
  DeckrAnimationPainter(this.animationState);

  final AnimationState animationState;

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
