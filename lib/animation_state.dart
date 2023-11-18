import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/animation_text_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimationState {
  AnimationState();

  bool isInitialized = false;

  // Deckr animation
  final t1 = AnimationTextState(
    text: 'Deckr'.toUpperCase(),
    fontSize: 64,
    color: Colors.white,
    startAlignment: const Alignment(-0.8, -5),
    endAlignment: const Alignment(-0.8, -0.8),
  );

  // Coder animation
  final t2 = AnimationTextState(
    text: 'Code: Mr. Henderson',
    fontSize: 44,
    color: Colors.cyan,
    startAlignment: const Alignment(0.8, 5),
    endAlignment: const Alignment(0.8, 0.8),
  );

  // ball animation
  double ballValue = 0;
  double fadeBallPosition = -1;
  double fadeBallOpacity = 0;
  double fadeBallPosition2 = -1;
  double fadeBallOpacity2 = 0;
  int lastV = -1;

  // background
  late ui.Image hendersonImage;
  late final Animation<double> backgroundAnimation;

  // =================================================

  Future<void> initialize(AnimationController controller) async {
    if (!isInitialized) {
      final ByteData byteData =
          await rootBundle.load('assets/images/henderson.png');

      hendersonImage =
          await ImageProcessor.bytesToImage(byteData.buffer.asUint8List());

      const double textStart = 0.2;
      const double textEnd = 0.9;

      const double textStart2 = 0.4;
      const double textEnd2 = 1;

      await t1.initialize(
        controller: controller,
        text: t1.text,
        tStart: textStart,
        tEnd: textEnd,
      );

      await t2.initialize(
        controller: controller,
        text: t2.text,
        tStart: textStart2,
        tEnd: textEnd2,
      );

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

      isInitialized = true;
    }
  }

  // =================================================

  void update(
    double value,
  ) {
    ballValue = value;

    updateBall();
  }

  void updateBall() {
    final int v = (ballValue * 100).round();

    if (v != lastV && (v % 15) == 0) {
      lastV = v;

      if (fadeBallPosition == -1) {
        fadeBallOpacity = 1;
        fadeBallPosition = ballValue;
      } else if (fadeBallPosition2 == -1) {
        fadeBallOpacity2 = 1;
        fadeBallPosition2 = ballValue;
      }
    }

    if (fadeBallPosition != -1) {
      fadeBallOpacity -= 0.015;

      if (fadeBallOpacity < 0) {
        fadeBallPosition = -1;
      }
    }

    if (fadeBallPosition2 != -1) {
      fadeBallOpacity2 -= 0.015;

      if (fadeBallOpacity2 < 0) {
        fadeBallPosition2 = -1;
      }
    }
  }
}
