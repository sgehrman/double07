import 'package:double07/src/animations/common_animations.dart';
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
    required this.timingInfo,
  });

  final AnimaTextLine line;
  final List<Alignment> alignments;
  final AnimaTimingInfo timingInfo;

  // foreward to line
  String get text => line.text;
  double get fontSize => line.fontSize;
  double get opacity => line.opacity;
  double get letterSpacing => line.letterSpacing;
  bool get bold => line.bold;
  Color get color => line.color;
  Curve get inCurve => line.inCurve;
  Curve get outCurve => line.outCurve;
  Curve get opacityCurve => line.opacityCurve;
  Set<TextAnimationType> get animationTypes => line.animationTypes;
}

// ==============================================================

class AnimaTextLine {
  AnimaTextLine({
    required this.text,
    required this.fontSize,
    this.color = Colors.white,
    this.inCurve = Curves.elasticOut,
    this.outCurve = Curves.easeIn,
    this.opacityCurve = Curves.linear,
    this.bold = false,
    this.letterSpacing = 1,
    this.opacity = 1,
    this.animationTypes = const {
      TextAnimationType.alignment,
      TextAnimationType.opacity,
      TextAnimationType.scale,
    },
  });

  AnimaTextLine.blank()
      : text = '',
        fontSize = 12,
        bold = false,
        letterSpacing = 1,
        opacity = 1,
        color = Colors.white,
        opacityCurve = Curves.linear,
        inCurve = Curves.linear,
        outCurve = Curves.linear,
        animationTypes = {};

  final String text;
  final double fontSize;
  final double opacity;
  final bool bold;
  final Color color;
  final Curve inCurve;
  final Curve outCurve;
  final Curve opacityCurve;
  final double letterSpacing;
  final Set<TextAnimationType> animationTypes;

  bool get isBlank => text.isEmpty;

  // don't use text.length, we don't want spaces in calculations
  int get textLengh {
    return text.replaceAll(' ', '').length;
  }
}
