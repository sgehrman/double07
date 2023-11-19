import 'package:flutter/material.dart';

class AnimaUtils {
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
    Rect src,
    Rect dst, {
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
  }) {
    return sizeToRect(src.size, dst, fit: fit, alignment: alignment)
      ..translate(-src.left, -src.top);
  }

  // ====================================================

  static Matrix4 rectToRect2(Rect src, Rect dst) {
    final scaleX = dst.width / src.width;
    final scaleY = dst.height / src.height;

    return Matrix4.identity()
      ..translate(dst.left, dst.top)
      ..scale(scaleX, scaleY)
      ..translate(-src.left, -src.top);
  }
}
