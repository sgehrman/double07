import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/src/animations/anima_utils.dart';
import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/backgrounds/anima_background_state.dart';
import 'package:double07/src/animations/common_animations.dart';
import 'package:double07/src/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BinocularAnimations extends AnimationSpec {
  BinocularAnimations({
    required List<Animation<double>> controllers,
    required this.opacity,
    required this.scale,
    required this.translate,
    required this.blur,
    required this.blood,
  }) : super(controllers: controllers);

  Animation<double> opacity;
  Animation<double> scale;
  Animation<double> blur;
  Animation<double> translate;
  Animation<double> blood;
}

// =====================================================

class AnimaBackgroundBinoculars {
  AnimaBackgroundBinoculars(this.state);

  final AnimaBackgroundState state;

  late final BinocularAnimations _animations;
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

    _animations = BinocularAnimations(
      controllers: [parent],
      opacity: CommonAnimations.inOutAnima(
        parent: parent,
        beginValue: 0,
        endValue: 1,
        inCurve: Curves.easeOut,
        outCurve: Curves.easeIn,
        begin: 0,
        end: 1,
        weights: const SequenceWeights.frontEnd(),
      ),
      scale: CommonAnimations.basicAnima(
        parent: parent,
        beginValue: 1,
        endValue: 1.8,
        curve: Curves.easeOut,
        begin: 0,
        end: 0.7,
      ),
      translate: CommonAnimations.basicAnima(
        parent: parent,
        beginValue: 0,
        endValue: 1,
        curve: Curves.easeIn,
        begin: 0.5,
        end: 0.7,
      ),
      blood: CommonAnimations.basicAnima(
        parent: parent,
        beginValue: 0,
        endValue: 1,
        curve: Curves.easeIn,
        begin: 0.8,
        end: 1,
      ),
      blur: blurAnima(
        parent: parent,
        inCurve: Curves.easeOut,
        outCurve: Curves.easeIn,
        begin: 0.3,
        end: 1,
      ),
    );
  }

  Animation<double> blurAnima({
    required double begin,
    required double end,
    required Animation<double> parent,
    required Curve inCurve,
    required Curve outCurve,
  }) {
    final sequence = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1).chain(
            CurveTween(curve: inCurve),
          ),
          weight: 2,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1, end: 0.8).chain(
            CurveTween(curve: outCurve),
          ),
          weight: 1,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.8, end: 1).chain(
            CurveTween(curve: outCurve),
          ),
          weight: 1,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(1),
          weight: 4,
        ),
      ],
    );

    return sequence.animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(
          begin,
          end,
        ),
      ),
    );
  }

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
      AnimaUtils.degToRad(30),
      AnimaUtils.degToRad(300),
    );

    final Path path2 = Path();

    path2.addArc(
      rightEye,
      AnimaUtils.degToRad(210),
      AnimaUtils.degToRad(300),
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

      final imageRect = Rect.fromLTWH(
        0,
        0,
        _image.width.toDouble(),
        _image.height.toDouble(),
      );

      final FittedSizes fittedSizes =
          applyBoxFit(BoxFit.cover, imageRect.size, rect.size);

      final Rect destRect = Offset.zero & fittedSizes.destination;

      final sig = ((1 - _animations.blur.value) * 40).abs();

      final imagePaint = Paint();
      imagePaint.color = Color.fromRGBO(
        0,
        0,
        0,
        ui.clampDouble(_animations.opacity.value, 0, 1),
      );
      imagePaint.imageFilter = ui.ImageFilter.blur(sigmaX: sig, sigmaY: sig);
      imagePaint.blendMode = ui.BlendMode.srcOver;

      final scale = AnimaUtils.scaledRect(
        rect,
        _animations.scale.value,
      );

      final translate = AnimaUtils.translate(
        x: 600 * _animations.translate.value,
        y: 200 * _animations.translate.value,
      );

      final matrix = translate + scale;

      canvas.save();

      canvas.clipPath(_binocularPath(canvas, size));

      canvas.transform(matrix.storage);

      canvas.drawImageRect(
        _image,
        imageRect,
        destRect,
        imagePaint,
      );

      final bloodPaint = Paint();
      bloodPaint.color = Color.fromRGBO(
        255,
        0,
        0,
        math.min(
          _animations.opacity.value,
          ui.clampDouble(_animations.blood.value, 0, 1),
        ),
      );

      canvas.drawRect(rect, bloodPaint);

      canvas.restore();
    }
  }
}
