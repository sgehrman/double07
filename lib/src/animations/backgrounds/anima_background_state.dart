import 'package:flutter/material.dart';

enum AnimaBackgroundMode {
  spotlight,
  zoomIn,
}

class AnimaBackgroundState {
  AnimaBackgroundState({
    required this.imageAsset,
    required this.gradientAlignment,
    required this.timeStart,
    required this.timeEnd,
    this.mode = AnimaBackgroundMode.spotlight,
  });

  final String imageAsset;
  final Alignment gradientAlignment;
  final AnimaBackgroundMode mode;
  final double timeStart;
  final double timeEnd;
}
