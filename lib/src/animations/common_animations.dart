import 'package:double07/src/constants.dart';
import 'package:flutter/material.dart';

class CommonAnimations {
  static Animatable<Alignment> alignmentTween({
    required double begin,
    required double end,
    required List<Alignment> alignments,
    required Curve inCurve,
    required Curve outCurve,
    SequenceWeights weights = const SequenceWeights(),
  }) {
    if (alignments.length == 3) {
      final items = [
        TweenSequenceItem<Alignment>(
          tween: AlignmentTween(
            begin: alignments.first,
            end: alignments[1],
          ).chain(
            CurveTween(
              curve: inCurve,
            ),
          ),
          weight: weights.start,
        ),
        TweenSequenceItem<Alignment>(
          tween: ConstantTween<Alignment>(alignments[1]),
          weight: weights.hold,
        ),
        TweenSequenceItem<Alignment>(
          tween: AlignmentTween(
            begin: alignments[1],
            end: alignments[2],
          ).chain(
            CurveTween(
              curve: outCurve,
            ),
          ),
          weight: weights.end,
        ),
      ];

      return TweenSequence<Alignment>(
        items,
      ).chain(
        CurveTween(
          curve: Interval(
            begin,
            end,
          ),
        ),
      );
    } else {
      return AlignmentTween(
        begin: alignments.first,
        end: alignments[1],
      ).chain(
        CurveTween(
          curve: Interval(
            begin,
            end,
            curve: inCurve,
          ),
        ),
      );
    }
  }

  static Animation<Alignment> alignmentAnima({
    required double start,
    required double end,
    required List<Alignment> alignments,
    required Animation<double> parent,
    required Curve inCurve,
    required Curve outCurve,
    SequenceWeights weights = const SequenceWeights(),
  }) {
    if (alignments.length > 2) {
      // hard coding for 3 now, fix later
      final items = [
        TweenSequenceItem<Alignment>(
          tween: AlignmentTween(
            begin: alignments.first,
            end: alignments[1],
          ).chain(
            CurveTween(
              curve: inCurve,
            ),
          ),
          weight: weights.start,
        ),
        TweenSequenceItem<Alignment>(
          tween: ConstantTween<Alignment>(alignments[1]),
          weight: weights.hold,
        ),
        TweenSequenceItem<Alignment>(
          tween: AlignmentTween(
            begin: alignments[1],
            end: alignments[2],
          ).chain(
            CurveTween(
              curve: outCurve,
            ),
          ),
          weight: weights.end,
        ),
      ];

      return TweenSequence<Alignment>(items).animate(
        CurvedAnimation(
          parent: parent,
          curve: Interval(
            start,
            end,
          ),
        ),
      );
    } else {
      return AlignmentTween(
        begin: alignments.first,
        end: alignments[1],
      )
          .chain(
            CurveTween(
              curve: inCurve,
            ),
          )
          .animate(
            CurvedAnimation(
              parent: parent,
              curve: Interval(
                start,
                end,
              ),
            ),
          );
    }
  }

  static Animatable<double> inOutTween({
    required double begin,
    required double end,
    required double beginValue,
    required double endValue,
    required Curve inCurve,
    required Curve outCurve,
    SequenceWeights weights = const SequenceWeights(),
  }) {
    final sequence = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: beginValue, end: endValue).chain(
            CurveTween(curve: inCurve),
          ),
          weight: weights.start,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(endValue),
          weight: weights.hold,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: endValue, end: beginValue).chain(
            CurveTween(curve: outCurve),
          ),
          weight: weights.end,
        ),
      ],
    );

    return sequence.chain(
      CurveTween(
        curve: Interval(
          begin,
          end,
        ),
      ),
    );
  }

  static Animation<double> inOutAnima({
    required double start,
    required double end,
    required double beginValue,
    required double endValue,
    required Animation<double> parent,
    required Curve inCurve,
    required Curve outCurve,
    SequenceWeights weights = const SequenceWeights(),
  }) {
    final sequence = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: beginValue, end: endValue).chain(
            CurveTween(curve: inCurve),
          ),
          weight: weights.start,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(endValue),
          weight: weights.hold,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: endValue, end: beginValue).chain(
            CurveTween(curve: outCurve),
          ),
          weight: weights.end,
        ),
      ],
    );

    return sequence.animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(
          start,
          end,
        ),
      ),
    );
  }
}

// =============================================================

// Used for letters when you want to animate them in separately
// but then fade out together at the end of the animation
class AnimaTiming {
  AnimaTiming({
    required this.begin,
    required this.end,
    required this.numItems,
    required this.endDelay,
    this.inRatio = defRatio,
    this.outRatio = defRatio,
  });

  static const double defRatio = 1 / 3;
  final double begin;
  final double end;
  final int numItems;
  final double endDelay; // 0-1

  final double inRatio;
  final double outRatio;

  SequenceWeights weightsForIndex(int index) {
    final double startWeight = itemTime * inRatio;
    final double endWeight = itemTime * outRatio;
    final double holdWeight = itemTime - (startWeight + endWeight);

    final endOfItem = endForIndex(index);
    final extra = 1 - endOfItem;

    return SequenceWeights.custom(
      startWeight,
      holdWeight + extra,
      endWeight,
    );
  }

  double get animationTime {
    return 1 - endDelay;
  }

  double get itemTime {
    return animationTime / numItems;
  }

  double beginForIndex(int index) {
    return index * itemTime;
  }

  double endForIndex(int index) {
    return beginForIndex(index) + itemTime;
  }
}
