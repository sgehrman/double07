import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/src/animations/anima_image/anima_image_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimaImageAnimations {
  AnimaImageAnimations(this.state);

  final AnimaImageState state;

  late final Animation<double> _animation;
  late final ui.Image _image;

  // =================================================

  Future<void> initialize(AnimationController controller) async {
    final sequence = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: state.opacity),
          weight: 33,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(state.opacity),
          weight: 33,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: state.opacity, end: 0),
          weight: 33,
        ),
      ],
    );

    final ByteData byteData = await rootBundle.load(state.imageAsset);

    _image = await ImageProcessor.bytesToImage(byteData.buffer.asUint8List());

    _animation = sequence.animate(
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

    final destRect = state.alignments.last.inscribe(state.size, rect);

    paintImage(
      canvas: canvas,
      rect: destRect,
      fit: BoxFit.scaleDown,
      image: _image,
      opacity: _animation.value,
    );
  }
}
