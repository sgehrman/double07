import 'package:double07/animation_state.dart';
import 'package:double07/deckr_animation_painter_ball.dart';
import 'package:double07/deckr_animation_painter_text.dart';
import 'package:flutter/material.dart';

class DeckrAnimationPainter extends CustomPainter {
  DeckrAnimationPainter(this.animationState);

  final AnimationState animationState;

  @override
  void paint(Canvas canvas, Size size) {
    paintBackground(canvas, size);

    DeckrAnimationPainterBall.paintBall(canvas, size, animationState);
    DeckrAnimationPainterText.paintText(
      canvas: canvas,
      size: size,
      textState: animationState.t1,
    );
    DeckrAnimationPainterText.paintText(
      canvas: canvas,
      size: size,
      textState: animationState.t2,
    );
  }

  // =================================================

  void paintBackground(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final backPaint = Paint()..color = Colors.black;
    final gradientPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..shader = const RadialGradient(
        colors: [Colors.transparent, Colors.black],
        center: Alignment(-0.25, -0.3),
      ).createShader(rect);

    canvas.drawRect(rect, backPaint);

    paintImage(
      canvas: canvas,
      rect: rect,
      fit: BoxFit.cover,
      image: animationState.hendersonImage,
      opacity: animationState.backgroundAnimation.value,
    );
    canvas.drawRect(rect, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
