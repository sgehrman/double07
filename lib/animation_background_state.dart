import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimationBackgroundState {
  AnimationBackgroundState({
    required this.imageAsset,
    required this.alignment,
  });

  final String imageAsset;
  final Alignment alignment;

  late final Animation<double> backgroundAnimation;
  late final ui.Image image;

  // =================================================

  Future<void> initialize(AnimationController controller) async {
    final ByteData byteData =
        await rootBundle.load('assets/images/henderson.png');

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
        curve: const Interval(
          0.12,
          0.9,
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
