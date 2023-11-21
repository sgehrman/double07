import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/animation_specs/letter_animations.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/animations/text/animated_letter.dart';
import 'package:flutter/material.dart';

class AnimaTextAnimations {
  AnimaTextAnimations(this.state);

  late final List<AnimatedLetter> _textLetters;
  late final List<LetterAnimations> _letterAnimations;

  final AnimaTextState state;

  late final TweenSequence<double> _scaleSequence;
  late final TweenSequence<double> _opacitySequence;

  Future<void> initialize({
    required AnimationController controller,
  }) async {
    _textLetters = await AnimatedLetter.createTextImages(
      state.text,
      _textStyle(),
      state.letterSpacing,
    );

    // expensve to create, do here
    _scaleSequence = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(1),
        weight: 1,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 15, end: 1).chain(
          CurveTween(
            curve: state.curve,
          ),
        ),
        weight: 1,
      ),
    ]);

    _opacitySequence = TweenSequence<double>(
      [
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: state.opacity).chain(
            CurveTween(
              curve: state.curve,
            ),
          ),
          weight: 1,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(state.opacity),
          weight: 3,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: state.opacity, end: 0).chain(
            CurveTween(
              curve: state.curve,
            ),
          ),
          weight: 1,
        ),
      ],
    );

    _letterAnimations = _buildAnimations(
      count: _textLetters.length,
      controller: controller,
    );
  }

  void paint({
    required Canvas canvas,
    required Size size,
  }) {
    AnimatedLetter.paintLetters(
      canvas: canvas,
      size: size,
      letters: _textLetters,
      letterAnimations: _letterAnimations,
    );
  }

  // ============================================================
  // private methods
  // ============================================================

  Animation<Alignment> _alignmentAnima(
    double start,
    double end,
    Animation<double> parent,
  ) {
    if (state.animationTypes.contains(TextAnimationType.alignment)) {
      if (state.alignments.length > 2) {
        // hard coding for 3 now, fix later
        final items = [
          TweenSequenceItem<Alignment>(
            tween: AlignmentTween(
              begin: state.alignments.first,
              end: state.alignments[1],
            ).chain(
              CurveTween(
                curve: state.curve,
              ),
            ),
            weight: 1,
          ),
          TweenSequenceItem<Alignment>(
            tween: ConstantTween<Alignment>(state.alignments[1]),
            weight: 3,
          ),
          TweenSequenceItem<Alignment>(
            tween: AlignmentTween(
              begin: state.alignments[1],
              end: state.alignments[2],
            ).chain(
              CurveTween(
                curve: state.curve,
              ),
            ),
            weight: 1,
          ),
        ];

        return TweenSequence<Alignment>(items).animate(
          CurvedAnimation(
            parent: parent,
            curve: Interval(
              start,
              1, // run til end of parent so it can do the third movement
              curve: state.curve,
            ),
          ),
        );
      } else {
        return AlignmentTween(
          begin: state.alignments.first,
          end: state.alignments[1],
        ).animate(
          CurvedAnimation(
            parent: parent,
            curve: Interval(
              start,
              end,
              curve: state.curve,
            ),
          ),
        );
      }
    }

    return ConstantTween<Alignment>(
      state.alignments.first,
    ).animate(parent);
  }

  Animation<double> _opacityAnima(
    double start,
    double end,
    Animation<double> parent,
  ) {
    if (state.animationTypes.contains(TextAnimationType.opacity)) {
      return _opacitySequence.animate(
        CurvedAnimation(
          parent: parent,
          curve: Interval(
            start,
            1,
          ),
        ),
      );
    } else if (state.animationTypes.contains(TextAnimationType.fadeInOut)) {
      return _opacitySequence.animate(
        CurvedAnimation(
          parent: parent,
          curve: Interval(
            start,
            0.9,
            curve: state.curve,
          ),
        ),
      );
    }

    return ConstantTween<double>(state.opacity).animate(parent);
  }

  Animation<double> _scaleAnima(
    double start,
    double end,
    Animation<double> parent,
  ) {
    return state.animationTypes.contains(TextAnimationType.scale)
        ? _scaleSequence.animate(
            CurvedAnimation(
              parent: parent,
              curve: Interval(
                start,
                end,
              ),
            ),
          )
        : ConstantTween<double>(1).animate(parent);
  }

  List<LetterAnimations> _buildAnimations({
    required int count,
    required AnimationController controller,
  }) {
    final List<LetterAnimations> result = [];
    final totalTime = state.timeEnd - state.timeStart;

    final masterParent = AnimationSpec.parentAnimation(
      controller,
      state.timeStart,
      state.timeEnd,
    );

    final double letterDuration = totalTime / count;
    const double overlap = 4;

    for (int i = 0; i < count; i++) {
      final start = i * (letterDuration / overlap);
      final end = start + (letterDuration * overlap);

      final parent = AnimationSpec.parentAnimation(masterParent, start, 1);

      result.add(
        LetterAnimations(
          master: masterParent,
          parent: parent,
          alignment: _alignmentAnima(start, end, parent),
          opacity: _opacityAnima(start, end, parent),
          scale: _scaleAnima(start, end, parent),
        ),
      );
    }

    return result;
  }

  TextStyle _textStyle() {
    return TextStyle(
      color: state.color,
      fontSize: state.fontSize,
      fontWeight: state.bold ? FontWeight.bold : FontWeight.normal,
      height: 1,
    );
  }
}
