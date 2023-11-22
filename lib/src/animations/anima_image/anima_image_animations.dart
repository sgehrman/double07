import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/src/animations/anima_image/anima_image_state.dart';
import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/common_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimaImageAnimations {
  AnimaImageAnimations(this.state);

  final AnimaImageState state;

  late final Animation<double> _opacityAnimation;
  late final Animation<Alignment> _alignmentAnimation;

  late final ui.Image _image;

  // =================================================

  Future<void> initialize(AnimationController controller) async {
    final parent = AnimationSpec.parentAnimation(
      controller,
      state.timeStart,
      state.timeEnd,
    );

    _alignmentAnimation = CommonAnimations.alignmentAnima(
      start: 0,
      end: 1,
      alignments: state.alignments,
      parent: parent,
      curve: state.curve,
    );

    final ByteData byteData = await rootBundle.load(state.imageAsset);

    _image = await ImageProcessor.bytesToImage(byteData.buffer.asUint8List());

    _opacityAnimation = CommonAnimations.opacityAnima(
      start: 0,
      end: 1,
      opacity: state.opacity,
      parent: parent,
      curve: state.opacityCurve,
    );
  }

  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final destRect = _alignmentAnimation.value.inscribe(state.size, rect);

    paintImage(
      canvas: canvas,
      rect: destRect,
      fit: BoxFit.scaleDown,
      image: _image,
      opacity: _opacityAnimation.value,
    );
  }
}
