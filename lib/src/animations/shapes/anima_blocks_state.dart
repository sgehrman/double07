import 'package:double07/src/animations/shapes/anima_blocks_utils.dart';
import 'package:flutter/material.dart';

class AnimaBlocksState {
  AnimaBlocksState({
    required this.timeStart,
    required this.timeEnd,
    this.reverse = false,
    this.downward = false,
    this.circles = false,
    this.numColumns = 6,
    this.margin = 10,
    TweenSequence<double>? blocksSequence,
    TweenSequence<double>? opacitySequence,
    TweenSequence<double>? flipSequence,
    TweenSequence<Color?>? colorSequence,
  })  : blocksSequence = blocksSequence ?? AnimaBlocksUtils.zeroSequence,
        flipSequence = flipSequence ?? AnimaBlocksUtils.zeroSequence,
        colorSequence = colorSequence ?? AnimaBlocksUtils.transparentSequence,
        opacitySequence = opacitySequence ?? AnimaBlocksUtils.oneSequence;

  final double timeStart;
  final double timeEnd;
  final double margin;
  final bool reverse;
  final bool circles;
  final bool downward;
  final int numColumns;
  final TweenSequence<double> blocksSequence;
  final TweenSequence<double> opacitySequence;
  final TweenSequence<double> flipSequence;
  final TweenSequence<Color?> colorSequence;
}
