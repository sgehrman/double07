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

  /// Return a scaled and translated [Matrix4] that maps [src] to [dst] for given [fit]
  /// aligned by [alignment] within [dst]
  ///
  /// For example, if you have a [CustomPainter] with size 300 x 200 logical pixels and
  /// you want to draw an expanded, centered image with size 80 x 100 you can do the following:
  ///
  /// ```dart
  ///  canvas.save();
  ///  var matrix = sizeToRect(imageSize, Offset.zero & customPainterSize);
  ///  canvas.transform(matrix.storage);
  ///  canvas.drawImage(image, Offset.zero, Paint());
  ///  canvas.restore();
  /// ```
  ///
  ///  and your image will be drawn inside a rect Rect.fromLTRB(70, 0, 230, 200)
  Matrix4 sizeToRect(
    Size src,
    Rect dst, {
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
  }) {
    final FittedSizes fs = applyBoxFit(fit, src, dst.size);
    final double scaleX = fs.destination.width / fs.source.width;
    final double scaleY = fs.destination.height / fs.source.height;
    final Size fittedSrc = Size(src.width * scaleX, src.height * scaleY);
    final Rect out = alignment.inscribe(fittedSrc, dst);

    return Matrix4.identity()
      ..translate(out.left, out.top)
      ..scale(scaleX, scaleY);
  }

  Matrix4 pointToPoint(
    double scale,
    Offset srcFocalPoint,
    Offset dstFocalPoint,
  ) {
    return Matrix4.identity()
      ..translate(dstFocalPoint.dx, dstFocalPoint.dy)
      ..scale(scale)
      ..translate(-srcFocalPoint.dx, -srcFocalPoint.dy);
  }

  /// Like [sizeToRect] but accepting a [Rect] as [src]
  Matrix4 rectToRect(
    Rect src,
    Rect dst, {
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
  }) {
    return sizeToRect(src.size, dst, fit: fit, alignment: alignment)
      ..translate(-src.left, -src.top);
  }

  Matrix4 rectToRect2(Rect src, Rect dst) {
    final scaleX = dst.width / src.width;
    final scaleY = dst.height / src.height;

    return Matrix4.identity()
      ..translate(dst.left, dst.top)
      ..scale(scaleX, scaleY)
      ..translate(-src.left, -src.top);
  }

  void paintText(Canvas canvas, Size size) {
    if (animationState.textAnimValue > 0) {
      // final rect = Offset.zero & size;

      final rect2 = Offset.zero & animationState.textPainter.size;

      final rect3 = const Offset(0, 222) & animationState.textPainter.size;

      // canvas.drawRect(rect2, Paint()..color = Colors.red);

      canvas.save();
      // final matrix = pointToPoint(1, rect2.center, rect.center);
      final matrix = sizeToRect(rect2.size, rect3);
      // final matrix = rectToRect(rect2, rect2);

      canvas.transform(matrix.storage);

      animationState.textPainter.paint(
        canvas,
        Offset.zero,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
