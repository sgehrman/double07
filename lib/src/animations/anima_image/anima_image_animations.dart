import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/src/animations/anima_image/anima_image_state.dart';
import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/animation_specs/image_animations.dart';
import 'package:double07/src/animations/common_animations.dart';
import 'package:double07/src/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimaImageAnimations {
  AnimaImageAnimations(this.state);

  final AnimaImageState state;

  late final ImageAnimations _animations;

  late final ui.Image _image;

  // =================================================

  Future<void> initialize(AnimationController controller) async {
    final ByteData byteData = await rootBundle.load(state.imageAsset);

    _image = await ImageProcessor.bytesToImage(byteData.buffer.asUint8List());

    final parent = AnimationSpec.parentAnimation(
      controller,
      state.timeStart,
      state.timeEnd,
    );

    _animations = ImageAnimations(
      master: controller,
      parent: parent,
      opacity: CommonAnimations.opacityAnima(
        start: 0,
        end: 1,
        opacity: state.opacity,
        parent: parent,
        curve: state.opacityCurve,
        weights: const SequenceWeights.frontEnd(),
      ),
      alignment: CommonAnimations.alignmentAnima(
        start: 0,
        end: 1,
        alignments: state.alignments,
        parent: parent,
        inCurve: state.inCurve,
        outCurve: state.outCurve,
        weights: const SequenceWeights.frontEnd(),
      ),
    );
  }

  void paint(Canvas canvas, Size size) {
    if (_animations.isRunning) {
      final rect = Offset.zero & size;

      final destRect = _animations.alignment.value.inscribe(state.size, rect);

      paintImage(
        canvas: canvas,
        rect: destRect,
        fit: BoxFit.scaleDown,
        image: _image,
        opacity: _animations.opacity.value,
      );
    }
  }
}
