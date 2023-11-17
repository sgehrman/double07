import 'package:double07/animation_state.dart';
import 'package:flutter/material.dart';

class DeckrAnimationPainter extends CustomPainter {
  DeckrAnimationPainter(this.animationState);

  final AnimationState animationState;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final backPaint = Paint()..color = Colors.black;

    canvas.drawRect(rect, backPaint);

    paintBall(canvas, size);
    paintText(canvas, size);
  }

  // =================================================

  void paintBall(Canvas canvas, Size size) {
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

  // =================================================

  void paintText(Canvas canvas, Size size) {
    if (animationState.textAnimValue > 0) {
      canvas.translate(0, -size.height * animationState.textAnimValue);

      animationState.textPainter.paint(
        canvas,
        size.topCenter(
          -animationState.textPainter.size.topCenter(
            -Offset(
              0,
              size.height,
            ),
          ),
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
