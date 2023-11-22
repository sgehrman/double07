import 'package:flutter/material.dart';

enum TextAnimationType {
  alignment,
  scale,
  opacity,
  fadeInOut,
}

class AnimaTextState {
  AnimaTextState({
    required this.line,
    required this.alignments,
    required this.timeStart,
    required this.timeEnd,
  });

  final AnimaTextLine line;
  final List<Alignment> alignments;
  final double timeStart;
  final double timeEnd;

  String get text => line.text;
  double get fontSize => line.fontSize;
  double get opacity => line.opacity;
  double get letterSpacing => line.letterSpacing;
  bool get bold => line.bold;
  Color get color => line.color;
  Curve get curve => line.curve;
  Curve get opacityCurve => line.opacityCurve;
  Set<TextAnimationType> get animationTypes => line.animationTypes;
}

// ==============================================================

class AnimaTextLine {
  AnimaTextLine({
    required this.text,
    required this.fontSize,
    required this.color,
    this.curve = Curves.elasticInOut,
    this.opacityCurve = Curves.easeOut,
    this.bold = false,
    this.letterSpacing = 10,
    this.opacity = 0.3,
    this.animationTypes = const {
      TextAnimationType.alignment,
      TextAnimationType.scale,
      TextAnimationType.opacity,
    },
  });

  final String text;
  final double fontSize;
  final double opacity;
  final bool bold;
  final Color color;
  final Curve curve;
  final Curve opacityCurve;
  final double letterSpacing;
  final Set<TextAnimationType> animationTypes;
}
