import 'package:double07/animation_state.dart';
import 'package:flutter/material.dart';

class DeckrAnimationPainter extends CustomPainter {
  DeckrAnimationPainter(this.animationState);

  final AnimationState animationState;

  @override
  void paint(Canvas canvas, Size size) {
    const double ballRadius = 100;
    final rect = Offset.zero & size;
    const ballColor = Colors.white;
    final ballPaint = Paint()..color = ballColor;
    final backPaint = Paint()..color = Colors.black;

    canvas.drawRect(rect, backPaint);

    canvas.drawCircle(
      Offset(
        size.width * animationState.animationValue,
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
