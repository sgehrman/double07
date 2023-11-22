import 'package:flutter/material.dart';

class AnimaImageState {
  AnimaImageState({
    required this.imageAsset,
    required this.size,
    required this.alignments,
    required this.timeStart,
    required this.timeEnd,
    this.opacity = 1,
    this.inCurve = Curves.elasticOut,
    this.outCurve = Curves.elasticIn,
    this.opacityCurve = Curves.linear,
  });

  final String imageAsset;
  final List<Alignment> alignments;
  final double opacity;
  final Size size;
  final Curve inCurve;
  final Curve outCurve;
  final Curve opacityCurve;
  final double timeStart;
  final double timeEnd;
}
