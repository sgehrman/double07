import 'package:double07/src/constants.dart';
import 'package:flutter/material.dart';

class CommonAnimations {
  static Animation<Alignment> alignmentAnima({
    required double start,
    required double end,
    required List<Alignment> alignments,
    required Animation<double> parent,
    required Curve inCurve,
    required Curve outCurve,
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
          weight: kStartWeight,
        ),
        TweenSequenceItem<Alignment>(
          tween: ConstantTween<Alignment>(alignments[1]),
          weight: kHoldWeight,
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
          weight: kEndWeight,
        ),
      ];

      return TweenSequence<Alignment>(items).animate(
        CurvedAnimation(
          parent: parent,
          curve: Interval(
            start,
            1, // 1 is end of parent animation
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

  static Animation<double> opacityAnima({
    required double start,
    required double end,
    required double opacity,
    required Animation<double> parent,
    required Curve curve,
  }) {
    final sequence = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: opacity),
          weight: kStartWeight,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(opacity),
          weight: kHoldWeight,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: opacity, end: 0),
          weight: kEndWeight,
        ),
      ],
    );

    return sequence.animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(
          start,
          end,
          curve: curve,
        ),
      ),
    );
  }
}
