import 'dart:ui' as ui;

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

  void paintText(Canvas canvas, Size size) {
    if (animationState.textAnimValue > 0) {
      for (int i = 0; i < animationState.textPainters.length; i++) {
        _paintText(
          canvas,
          size,
          animationState.textPainters[i],
          animationState.textImages[i],
        );
      }
    }
  }

  void _paintText(
    Canvas canvas,
    Size size,
    TextPainter textPainter,
    ui.Image textImage,
  ) {
    if (animationState.textAnimValue > 0) {
      final rect = Offset.zero & size;

      final tSize = textPainter.size;

      final delta = (1 - animationState.textAnimValue) * 200;

      final destRect = Rect.fromCenter(
        center: rect.center,
        width: tSize.width * delta,
        height: tSize.height * delta,
      );

      paintImage(
        canvas: canvas,
        rect: destRect,
        fit: BoxFit.contain,
        image: textImage,
        opacity: 0.1,
        filterQuality: FilterQuality.high,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
