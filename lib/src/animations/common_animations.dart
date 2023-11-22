import 'package:double07/src/animations/anima_utils.dart';
import 'package:flutter/material.dart';

class CommonAnimations {
  static Animation<Alignment> alignmentAnima({
    required double start,
    required double end,
    required List<Alignment> alignments,
    required Animation<double> parent,
    required Curve curve,
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
              curve: curve,
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
              curve: curve,
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
      ).animate(
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
}
