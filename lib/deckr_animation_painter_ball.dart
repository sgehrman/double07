import 'package:double07/animation_state.dart';
import 'package:flutter/material.dart';

class DeckrAnimationPainterBall {
  static void paintBall(
    Canvas canvas,
    Size size,
    AnimationState animationState,
  ) {
    const double ballRadius = 100;
    const ballColor = Colors.white;
    final ballPaint = Paint()..color = ballColor;

    canvas.drawCircle(
      Offset(
        size.width * animationState.ballValue,
        size.height / 2,
      ),
      ballRadius,
      ballPaint,
    );

    // fade ball
    if (animationState.fadeBallPosition != -1) {
      final ballFadePaint = Paint()
        ..color = ballColor.withOpacity(animationState.fadeBallOpacity);

      canvas.drawCircle(
        Offset(
          size.width * animationState.fadeBallPosition,
          size.height / 2,
        ),
        ballRadius,
        ballFadePaint,
      );
    }

    if (animationState.fadeBallPosition2 != -1) {
      final ballFadePaint = Paint()
        ..color = ballColor.withOpacity(animationState.fadeBallOpacity2);

      canvas.drawCircle(
        Offset(
          size.width * animationState.fadeBallPosition2,
          size.height / 2,
        ),
        ballRadius,
        ballFadePaint,
      );
    }
  }
}
