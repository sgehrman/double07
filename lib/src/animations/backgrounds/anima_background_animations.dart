import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/src/animations/anima_utils.dart';
import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/animation_specs/background_animations.dart';
import 'package:double07/src/animations/backgrounds/anima_background_state.dart';
import 'package:double07/src/animations/common_animations.dart';
import 'package:double07/src/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimaBackgroundAnimations {
  AnimaBackgroundAnimations(this.state);

  final AnimaBackgroundState state;

  late final BackgroundAnimations _animations;
  late final ui.Image _image;

  // =================================================

  Future<void> initialize(AnimationController controller) async {
    final ByteData byteData = await rootBundle.load(state.imageAsset);

    _image = await ImageProcessor.bytesToImage(byteData.buffer.asUint8List());

    final parent = AnimationSpec.parentAnimation(
      controller: controller,
      begin: state.timeStart,
      end: state.timeEnd,
    );

    _animations = BackgroundAnimations(
      master: controller,
      parent: parent,
      opacity: CommonAnimations.inOutAnima(
        parent: parent,
        beginValue: 0,
        endValue: state.mode == AnimaBackgroundMode.zoomIn ? 0.8 : 0.35,
        inCurve: Curves.easeOut,
        outCurve: Curves.easeIn,
        start: 0,
        end: 1,
      ),
      scale: CommonAnimations.inOutAnima(
        parent: parent,
        beginValue: 1,
        endValue: state.mode == AnimaBackgroundMode.zoomIn ? 1.2 : 1,
        inCurve: Curves.easeOut,
        outCurve: Curves.easeIn,
        start: 0,
        end: 1,
        weights: const SequenceWeights.noHold(),
      ),
    );
  }

  void paint(Canvas canvas, Size size) {
    if (_animations.isRunning) {
      final rect = Offset.zero & size;

      final opacity = _animations.opacity.value;

      if (state.mode == AnimaBackgroundMode.spotlight) {
        final double gradientOpacity = opacity > 0 ? 1 : 0;

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
      } else if (state.mode == AnimaBackgroundMode.zoomIn) {
        final matrix = AnimaUtils.scaledRect(
          rect,
          _animations.scale.value,
        );

        canvas.save();

        canvas.transform(matrix.storage);
        paintImage(
          canvas: canvas,
          rect: rect,
          fit: BoxFit.cover,
          image: _image,
          opacity: opacity,
        );

        canvas.restore();

        canvas.drawRect(rect, Paint()..color = Colors.black87);
      }
    }
  }
}
