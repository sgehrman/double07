import 'dart:math' as math;
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

  Future<void> initialize(Animation<double> controller) async {
    final ByteData byteData = await rootBundle.load(state.imageAsset);

    _image = await ImageProcessor.bytesToImage(byteData.buffer.asUint8List());

    final parent = AnimationSpec.parentAnimation(
      parent: controller,
      begin: state.timeStart,
      end: state.timeEnd,
    );

    _animations = BackgroundAnimations(
      controllers: [controller],
      opacity: CommonAnimations.inOutAnima(
        parent: parent,
        beginValue: 0,
        endValue: state.mode == AnimaBackgroundMode.zoomIn ? 0.8 : 0.35,
        inCurve: Curves.easeOut,
        outCurve: Curves.easeIn,
        begin: 0,
        end: 1,
      ),
      scale: CommonAnimations.inOutAnima(
        parent: parent,
        beginValue: 1,
        endValue: state.mode == AnimaBackgroundMode.zoomIn ? 1.2 : 1,
        inCurve: Curves.easeOut,
        outCurve: Curves.easeIn,
        begin: 0,
        end: 1,
        weights: const SequenceWeights.noHold(),
      ),
      blur: CommonAnimations.inOutAnima(
        parent: parent,
        beginValue: 1,
        endValue: 0,
        inCurve: Curves.elasticInOut,
        outCurve: Curves.elasticInOut,
        begin: 0,
        end: 1,
        weights: const SequenceWeights.noHold(),
      ),
    );
  }

  double degToRad(num deg) => deg * (math.pi / 180.0);

  Path _binocularPath(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final ovalSize = Size(size.height / 1.5, size.height / 1.5);

    final ovalRect = Rect.fromCenter(
      center: rect.center,
      width: ovalSize.width * 2,
      height: ovalSize.height,
    );

    const spaceBetween = 45;

    final leftEye = Rect.fromLTWH(
      ovalRect.left + spaceBetween,
      ovalRect.top,
      ovalSize.width,
      ovalSize.height,
    );

    final rightEye = Rect.fromLTWH(
      ovalRect.left + ovalSize.width - spaceBetween,
      ovalRect.top,
      ovalSize.width,
      ovalSize.height,
    );

    final Path path = Path();
    path.addArc(
      leftEye,
      degToRad(30),
      degToRad(300),
    );

    final Path path2 = Path();

    path2.addArc(
      rightEye,
      degToRad(210),
      degToRad(300),
    );

    // canvas.drawPath(
    //   path,
    //   Paint()
    //     ..color = Colors.red
    //     ..style = PaintingStyle.stroke,
    // );

    // canvas.drawPath(
    //   path2,
    //   Paint()
    //     ..color = Colors.red
    //     ..style = PaintingStyle.stroke,
    // );

    path.extendWithPath(path2, Offset.zero);

    path.close();

    return path;
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
      } else if (state.mode == AnimaBackgroundMode.binoculars) {
        canvas.clipPath(_binocularPath(canvas, size));

        final imageRect = Rect.fromLTWH(
          0,
          0,
          _image.width.toDouble(),
          _image.height.toDouble(),
        );

        final FittedSizes fittedSizes =
            applyBoxFit(BoxFit.cover, imageRect.size, rect.size);

        final Rect destRect = Offset.zero & fittedSizes.destination;

        final sig = _animations.blur.value.abs() * 40;

        canvas.drawImageRect(
          _image,
          imageRect,
          destRect,
          Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: sig, sigmaY: sig),
        );

        // _binocularPath(canvas, size);
      }
    }
  }
}
