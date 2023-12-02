import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/src/animations/anima_image/anima_image_state.dart';
import 'package:double07/src/animations/anima_utils.dart';
import 'package:double07/src/animations/animation_specs/animation_spec.dart';
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

  Future<void> initialize(
    Animation<double> controller,
  ) async {
    final ByteData byteData = await rootBundle.load(state.imageAsset);

    _image = await ImageProcessor.bytesToImage(byteData.buffer.asUint8List());

    final parent = AnimationSpec.parentAnimation(
      parent: controller,
      begin: state.timeStart,
      end: state.timeEnd,
    );

    _animations = ImageAnimations(
      controllers: [parent],
      opacity: CommonAnimations.inOutAnima(
        begin: 0,
        end: 1,
        beginValue: 0,
        endValue: state.opacity,
        parent: parent,
        inCurve: state.opacityCurve,
        outCurve: state.opacityCurve,
        weights: const SequenceWeights.frontEnd(),
      ),
      scale: CommonAnimations.inOutAnima(
        begin: 0,
        end: 1,
        beginValue: 1,
        endValue: 1.4,
        parent: parent,
        inCurve: state.inCurve,
        outCurve: state.outCurve,
        weights: const SequenceWeights.frontEnd(),
      ),
      alignment: CommonAnimations.alignmentAnima(
        begin: 0,
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

      canvas.save();

      final scale = _animations.scale.value;

      final matrix = AnimaUtils.scaledRect(
        destRect,
        scale,
      );

      canvas.transform(matrix.storage);

      paintImage(
        canvas: canvas,
        rect: destRect,
        fit: BoxFit.scaleDown,
        image: _image,
        opacity: _animations.opacity.value,
      );

      canvas.restore();
    }
  }
}

// ==================================================================

class ImageAnimations extends AnimationSpec {
  ImageAnimations({
    required List<Animation<double>> controllers,
    required this.opacity,
    required this.alignment,
    required this.scale,
  }) : super(controllers: controllers);

  Animation<Alignment> alignment;
  Animation<double> opacity;
  Animation<double> scale;
}
