import 'package:double07/animation_state.dart';
import 'package:double07/deckr_animation_painter_ball.dart';
import 'package:double07/deckr_animation_painter_text.dart';
import 'package:flutter/material.dart';

class DeckrAnimationPainter extends CustomPainter {
  DeckrAnimationPainter(this.animationState);

  final AnimationState animationState;

  @override
  void paint(Canvas canvas, Size size) {
    animationState.backgroundState.paintBackground(canvas, size);

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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
