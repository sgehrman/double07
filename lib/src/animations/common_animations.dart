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

  static Animatable<double> simpleTween({
    required double begin,
    required double end,
    required double beginValue,
    required double endValue,
    required Curve curve,
  }) {
    return Tween<double>(begin: beginValue, end: endValue).chain(
      CurveTween(
        curve: Interval(
          begin,
          end,
          curve: curve,
        ),
      ),
    );
  }
}

// ===============================================================

class AnimaTimingInfo {
  AnimaTimingInfo({
    required this.begin,
    required this.end,
    required this.numItems,
  });

  final double begin;
  final double end;
  final int numItems;

  double get duration {
    return end - begin;
  }
}

// =============================================================

// Used for letters when you want to animate them in separately
// but then fade out together at the end of the animation
class AnimaTiming {
  AnimaTiming({
    required this.info,
  });

  final AnimaTimingInfo info;

  double get animationTime {
    return 1;
  }

  double get itemTime {
    return animationTime / info.numItems;
  }

  double beginForIndex(int index) {
    return index * itemTime;
  }

  double endForIndex(int index) {
    return beginForIndex(index) + itemTime;
  }
}
