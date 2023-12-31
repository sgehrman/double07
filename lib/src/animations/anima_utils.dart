import 'dart:math' as math;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

class AnimaUtils {
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

  // ====================================================

  static bool isControllerPaused(AnimationController controller) {
    if (isRunning(controller)) {
      return !controller.isAnimating;
    }

    return false;
  }

  // ====================================================

  // for use with Animation.inscribe when drawing
  static Alignment makeAlignment(double x, double y, Size size, Rect rect) {
    final double halfWidthDelta = (rect.width - size.width) / 2.0;
    final double halfHeightDelta = (rect.height - size.height) / 2.0;

    // avoid divide by zero
    final newX = halfWidthDelta != 0 ? x / halfWidthDelta : 0;
    final newY = halfHeightDelta != 0 ? y / halfHeightDelta : 0;

    return Alignment(newX - 1, newY - 1);
  }

  // ====================================================

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
        .scale(
          scale,
          origin: srcRect.center,
        )
        .matrix4;
  }

  static Matrix4 translate({
    required double x,
    required double y,
  }) {
    return Matrix4Transform()
        .translate(
          x: x,
          y: y,
        )
        .matrix4;
  }

  // ====================================================

  static Matrix4 rotateRect({
    required Rect srcRect,
    required int degreesX,
    required int degreesY,
  }) {
    final origin = srcRect.center;

    //  rotateY(math.pi / 2 * (1 - animationController.value)),

    return Matrix4.identity()
      // ..setEntry(3, 2, 0.001)
      ..setEntry(3, 2, 0.0005)
      ..translate(origin.dx, origin.dy)
      ..rotateY(degreesY.inRadians)
      ..rotateX(degreesX.inRadians)
      ..translate(-origin.dx, -origin.dy);
  }

  static double degToRad(num deg) => deg * (math.pi / 180.0);
}
