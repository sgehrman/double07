import 'package:double07/animation_state.dart';
import 'package:flutter/material.dart';

class DeckrAnimationPainter extends CustomPainter {
  DeckrAnimationPainter(this.animationState);

  final AnimationState animationState;

  @override
  void paint(Canvas canvas, Size size) {
    paintBackground(canvas, size);
    paintBall(canvas, size);
    paintText(canvas, size);
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
      opacity: 0.35,
    );
    canvas.drawRect(rect, gradientPaint);
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
      for (int i = 0; i < animationState.textImages.length; i++) {
        _paintText(
          canvas: canvas,
          size: size,
          textImage: animationState.textImages[i],
          index: i,
        );
      }
    }
  }

  void _paintText({
    required Canvas canvas,
    required Size size,
    required TextImageInfo textImage,
    required int index,
  }) {
    if (animationState.textAnimValue > 0) {
      final rect = Offset.zero & size;
      // const multiplier = math.max(1, (1 - animationState.textAnimValue) * 122);

      final tSize = textImage.painter.size;

      const startAlignment = Alignment(-0.5, -5);
      const endAlignment = Alignment(-0.5, -0.5);

      final alignment = Alignment.lerp(
            startAlignment,
            endAlignment,
            animationState.textAnimValue,
          ) ??
          Alignment.center;

      Rect destRect = alignment.inscribe(
        Size(
          tSize.width,
          tSize.height,
        ),
        rect,
      );

      destRect = destRect.translate(index * destRect.width, 0);

      paintImage(
        canvas: canvas,
        rect: destRect,
        fit: BoxFit.fill,
        image: textImage.image,
        opacity: 0.1,
        isAntiAlias: true,
        filterQuality: FilterQuality.high,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
