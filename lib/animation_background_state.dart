import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimationBackgroundState {
  AnimationBackgroundState({
    required this.imageAsset,
    required this.alignment,
    required this.timeStart,
    required this.timeEnd,
  });

  final String imageAsset;
  final Alignment alignment;
  final double timeStart;
  final double timeEnd;

  late final Animation<double> backgroundAnimation;
  late final ui.Image image;

  // =================================================

  Future<void> initialize(AnimationController controller) async {
    final ByteData byteData = await rootBundle.load(imageAsset);

    image = await ImageProcessor.bytesToImage(byteData.buffer.asUint8List());

    backgroundAnimation = TweenSequence<double>(
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
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          timeStart,
          timeEnd,
        ),
      ),
    );
  }

  void paintBackground(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final backPaint = Paint()..color = Colors.black;
    final gradientPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: const [Colors.transparent, Colors.black],
        center: alignment,
      ).createShader(rect);

    canvas.drawRect(rect, backPaint);

    paintImage(
      canvas: canvas,
      rect: rect,
      fit: BoxFit.cover,
      image: image,
      opacity: backgroundAnimation.value,
    );
    canvas.drawRect(rect, gradientPaint);
  }
}
