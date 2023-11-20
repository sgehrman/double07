import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

class AnimaUtils {
  // base animation which child animations are based on
  // so begin and end affect children
  static Animation<double> baseAnimation(
    AnimationController controller,
    double start,
    double end,
  ) {
    return Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          start,
          end,
        ),
      ),
    );
  }

  static bool isRunning(Animation<dynamic> animation) {
    switch (animation.status) {
      case AnimationStatus.completed:
      case AnimationStatus.dismissed:
        return false;
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        return true;
    }
  }

  // for use with Animation.inscribe when drawing
  static Alignment makeAlignment(double x, double y, Size size, Rect rect) {
    final double halfWidthDelta = (rect.width - size.width) / 2.0;
    final double halfHeightDelta = (rect.height - size.height) / 2.0;

    // avoid divide by zero
    final newX = halfWidthDelta != 0 ? x / halfWidthDelta : 0;
    final newY = halfHeightDelta != 0 ? y / halfHeightDelta : 0;

    return Alignment(newX - 1, newY - 1);
  }

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
  static Matrix4 sizeToRect(
    Size srcSize,
    Rect destRect, {
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
  }) {
    final FittedSizes fs = applyBoxFit(fit, srcSize, destRect.size);
    final double scaleX = fs.destination.width / fs.source.width;
    final double scaleY = fs.destination.height / fs.source.height;
    final Size fittedSrc =
        Size(srcSize.width * scaleX, srcSize.height * scaleY);
    final Rect out = alignment.inscribe(fittedSrc, destRect);

    return Matrix4.identity()
      ..translate(out.left, out.top)
      ..scale(scaleX, scaleY);
  }

  // ====================================================

  static Matrix4 pointToPoint(
    double scale,
    Offset srcFocalPoint,
    Offset dstFocalPoint,
  ) {
    return Matrix4.identity()
      ..translate(dstFocalPoint.dx, dstFocalPoint.dy)
      ..scale(scale)
      ..translate(-srcFocalPoint.dx, -srcFocalPoint.dy);
  }

  // ====================================================

  /// Like [sizeToRect] but accepting a [Rect] as [src]
  static Matrix4 rectToRect(
    Rect srcRect,
    Rect destRect, {
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
  }) {
    return sizeToRect(srcRect.size, destRect, fit: fit, alignment: alignment)
      ..translate(-srcRect.left, -srcRect.top);
  }

  // ====================================================

  static Matrix4 rectToRect2(Rect srcRect, Rect destRect) {
    final scaleX = destRect.width / srcRect.width;
    final scaleY = destRect.height / srcRect.height;

    return Matrix4.identity()
      ..translate(destRect.left, destRect.top)
      ..scale(scaleX, scaleY)
      ..translate(-srcRect.left, -srcRect.top);
  }

  // ====================================================

  static Matrix4 scaledRect(Rect srcRect, double scale) {
    return Matrix4Transform()
        .scaleBy(
          x: scale,
          y: scale,
          origin: Offset(srcRect.width / 2, srcRect.height / 2),
        )
        .matrix4;
  }
}
