import 'package:double07/src/constants.dart';
import 'package:flutter/material.dart';

class CommonAnimations {
  static Animatable<Alignment> alignmentTween({
    required double begin,
    required double end,
    required AnimaAlignments alignments,
    required Curve inCurve,
    required Curve outCurve,
    SequenceWeights weights = const SequenceWeights(),
  }) {
    if (alignments.has3) {
      final items = [
        TweenSequenceItem<Alignment>(
          tween: AlignmentTween(
            begin: alignments.first,
            end: alignments.second,
          ).chain(
            CurveTween(
              curve: inCurve,
            ),
          ),
          weight: weights.start,
        ),
        TweenSequenceItem<Alignment>(
          tween: ConstantTween<Alignment>(alignments.second),
          weight: weights.hold,
        ),
        TweenSequenceItem<Alignment>(
          tween: AlignmentTween(
            begin: alignments.second,
            end: alignments.third,
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
        end: alignments.second,
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
    required AnimaAlignments alignments,
    required Animation<double> parent,
    required Curve inCurve,
    required Curve outCurve,
    SequenceWeights weights = const SequenceWeights(),
  }) {
    if (alignments.has3) {
      // hard coding for 3 now, fix later
      final items = [
        TweenSequenceItem<Alignment>(
          tween: AlignmentTween(
            begin: alignments.first,
            end: alignments.second,
          ).chain(
            CurveTween(
              curve: inCurve,
            ),
          ),
          weight: weights.start,
        ),
        TweenSequenceItem<Alignment>(
          tween: ConstantTween<Alignment>(alignments.second),
          weight: weights.hold,
        ),
        TweenSequenceItem<Alignment>(
          tween: AlignmentTween(
            begin: alignments.second,
            end: alignments.third,
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
        end: alignments.second,
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
    this.outMode = false,
  });

  final double begin;
  final double end;
  final int numItems;
  final bool outMode;

  double get duration {
    return end - begin;
  }
}

// =============================================================

// Used for letters when you want to animate them in separately
// but then fade out together at the end of the animation
class AnimaTiming {
  AnimaTiming({
    required this.numItems,
  });

  final int numItems;

  double get _itemTime {
    return 1 / numItems;
  }

  double beginForIndex(int index) {
    return index * _itemTime;
  }

  double endForIndex(int index) {
    return beginForIndex(index) + _itemTime;
  }
}

// =========================================================

class AnimaAlignments {
  AnimaAlignments(
    this.alignment, {
    this.from,
    this.to,
  });

  final Alignment alignment;
  final Alignment? from;
  final Alignment? to;

  AnimaAlignments reverse() {
    return AnimaAlignments(
      first,
      from: third,
    );
  }

  Alignment get first {
    if (from != null) {
      return from!;
    }

    return second;
  }

  Alignment get second {
    return alignment;
  }

  Alignment get third {
    if (to != null) {
      return to!;
    }

    return second;
  }

  bool get has3 {
    return from != null && to != null;
  }
}
