import 'package:flutter/material.dart';

class AnimaBlocksUtils {
  static final zeroSequence = TweenSequence<double>([
    TweenSequenceItem<double>(
      tween: ConstantTween<double>(0),
      weight: 1,
    ),
  ]);

  static final oneSequence = TweenSequence<double>([
    TweenSequenceItem<double>(
      tween: ConstantTween<double>(1),
      weight: 1,
    ),
  ]);

  static final transparentSequence = TweenSequence<Color?>([
    TweenSequenceItem<Color?>(
      tween: ConstantTween<Color>(Colors.transparent),
      weight: 1,
    ),
  ]);

  static final opacitySequence = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 0.35),
        weight: 33,
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(0.35),
        weight: 33,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.35, end: 0),
        weight: 33,
      ),
    ],
  );

  static final blocksSequence = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 0.35),
        weight: 10,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.35, end: 0.1),
        weight: 10,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.1, end: 0.8),
        weight: 4,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.8, end: 0),
        weight: 10,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 1),
        weight: 10,
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(1),
        weight: 20,
      ),
    ],
  );

  static final blocksSequenceFull = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 1),
        weight: 10,
      ),
    ],
  );

  static final flipSequence = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(0),
        weight: 44,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 0.4),
        weight: 10,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.4, end: 0),
        weight: 10,
      ),
    ],
  );

  static TweenSequence<Color?> colorSequence(
    Color colorOne,
    Color colorTwo,
  ) {
    return TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(
          begin: colorOne,
          end: colorTwo,
        ),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: colorTwo,
          end: colorOne,
        ),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: colorOne,
          end: colorTwo,
        ),
        weight: 10,
      ),
    ]);
  }
}
