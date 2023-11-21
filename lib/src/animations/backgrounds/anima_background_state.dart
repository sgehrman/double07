import 'package:flutter/material.dart';

class AnimaBackgroundState {
  AnimaBackgroundState({
    required this.imageAsset,
    required this.alignment,
    required this.timeStart,
    required this.timeEnd,
  });

  final String imageAsset;
  final Alignment alignment;
  final double timeStart;
  final double timeEnd;
}
