import 'package:flutter/material.dart';

class AnimaImageState {
  AnimaImageState({
    required this.imageAsset,
    required this.size,
    required this.alignments,
    required this.timeStart,
    required this.timeEnd,
    this.opacity = 1,
    this.curve = Curves.easeInOut,
    this.opacityCurve = Curves.easeIn,
  });

  final String imageAsset;
  final List<Alignment> alignments;
  final double opacity;
  final Size size;
  final Curve curve;
  final Curve opacityCurve;
  final double timeStart;
  final double timeEnd;
}