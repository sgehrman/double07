import 'package:double07/animation_state.dart';
import 'package:double07/deckr_animation_painter_text.dart';
import 'package:flutter/material.dart';

class DeckrAnimationPainter extends CustomPainter {
  DeckrAnimationPainter(this.animationState);

  final AnimationState animationState;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final backPaint = Paint()..color = Colors.black;
    canvas.drawRect(rect, backPaint);

    animationState.backgroundState.paintBackground(canvas, size);
    animationState.backgroundState2.paintBackground(canvas, size);
    animationState.backgroundState3.paintBackground(canvas, size);

    animationState.ballState.paintBall(canvas, size);
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
