import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/src/animations/anima_utils.dart';
import 'package:double07/src/animations/backgrounds/anima_background_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimaBackgroundAnimations {
  AnimaBackgroundAnimations(this.state);

  final AnimaBackgroundState state;

  late final Animation<double> _animation;
  late final ui.Image _image;

  // expensive to alloc, create once
  final _sequence = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 0.35),
        weight: 33,
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(0.35),
        weight: 33,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.35, end: 0),
        weight: 33,
      ),
    ],
  );

  // =================================================

  Future<void> initialize(AnimationController controller) async {
    final ByteData byteData = await rootBundle.load(state.imageAsset);

    _image = await ImageProcessor.bytesToImage(byteData.buffer.asUint8List());

    _animation = _sequence.animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          state.timeStart,
          state.timeEnd,
        ),
      ),
    );
  }

  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final opacity = _animation.value;

    if (state.mode == AnimaBackgroundMode.spotlight) {
      final double gradientOpacity = _animation.value > 0 ? 1 : 0;

      final gradientPaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..shader = RadialGradient(
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(
              gradientOpacity,
            ),
          ],
          center: state.gradientAlignment,
        ).createShader(rect);

      paintImage(
        canvas: canvas,
        rect: rect,
        fit: BoxFit.cover,
        image: _image,
        opacity: opacity,
      );

      canvas.drawRect(rect, gradientPaint);
    } else if (state.mode == AnimaBackgroundMode.colorShift) {
      final len = BlendMode.values.length;

      final index = (_animation.value * (len - 1)).floor();

      final blendMode = BlendMode.values[index];

      paintImage(
        canvas: canvas,
        rect: rect,
        fit: BoxFit.cover,
        invertColors: true,
        filterQuality: FilterQuality.high,
        blendMode: blendMode,
        colorFilter: const ColorFilter.linearToSrgbGamma(),
        image: _image,
        // opacity: 1,
      );
    } else if (state.mode == AnimaBackgroundMode.zoomIn) {
      final matrix = AnimaUtils.scaledRect(
        rect,
        1 + (_animation.value * 1.2),
      );

      canvas.save();

      canvas.transform(matrix.storage);
      paintImage(
        canvas: canvas,
        rect: rect,
        fit: BoxFit.cover,
        image: _image,
        // opacity: 1,
      );

      canvas.restore();

      canvas.drawRect(rect, Paint()..color = Colors.black26);
    }
  }
}
