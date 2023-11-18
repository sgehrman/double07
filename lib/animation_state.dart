import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/animation_text_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimationState {
  AnimationState();

  bool isInitialized = false;

  // Deckr animation
  final t1 = AnimationTextState('Deckr');

  // ball animation
  double ballValue = 0;
  double fadeBallPosition = -1;
  double fadeBallOpacity = 0;
  double fadeBallPosition2 = -1;
  double fadeBallOpacity2 = 0;
  int lastV = -1;

  // background
  late ui.Image hendersonImage;

  // =================================================

  Future<void> initialize() async {
    if (!isInitialized) {
      final ByteData byteData =
          await rootBundle.load('assets/images/henderson.png');

      hendersonImage =
          await ImageProcessor.bytesToImage(byteData.buffer.asUint8List());

      await t1.initialize();

      isInitialized = true;
    }
  }

  // =================================================

  void update(double value, List<Animation<double>> textAnims) {
    ballValue = value;
    t1.textAnimations = textAnims;

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
