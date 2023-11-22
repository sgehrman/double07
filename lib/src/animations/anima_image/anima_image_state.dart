import 'package:flutter/material.dart';

class AnimaImageState {
  AnimaImageState({
    required this.imageAsset,
    required this.opacity,
    required this.size,
    required this.alignments,
    required this.timeStart,
    required this.timeEnd,
  });

  final String imageAsset;
  final List<Alignment> alignments;
  final double opacity;
  final Size size;
  final double timeStart;
  final double timeEnd;
}
