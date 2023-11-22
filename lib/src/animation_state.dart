import 'package:double07/src/animations/animation_ball_state.dart';
import 'package:double07/src/animations/backgrounds/anima_background.dart';
import 'package:double07/src/animations/backgrounds/anima_background_state.dart';
import 'package:double07/src/animations/shapes/anima_blocks.dart';
import 'package:double07/src/animations/shapes/anima_blocks_state.dart';
import 'package:double07/src/animations/shapes/anima_blocks_utils.dart';
import 'package:double07/src/animations/text/anima_text.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/elements/anima_elements.dart';
import 'package:double07/src/timeline.dart';
import 'package:double07/src/utils.dart';
import 'package:flutter/material.dart';

abstract class RunableAnimation {
  void paint(Canvas canvas, Size size);
  Future<void> initialize(AnimationController controller);
}

// ========================================================

class AnimationState {
  AnimationState();

  bool isInitialized = false;

  final List<RunableAnimation> _runables = [
    // background
    // AnimaBackground(
    //   AnimaBackgroundState(
    //     imageAsset: '$kAssets/images/henderson.png',
    //     gradientAlignment: const Alignment(-0.25, -0.3),
    //     timeStart: 0,
    //     timeEnd: 1,
    //     mode: AnimaBackgroundMode.zoomIn,
    //   ),
    // ),

    AnimaBackground(
      AnimaBackgroundState(
        imageAsset: '$kAssets/images/henderson.png',
        gradientAlignment: const Alignment(-0.25, -0.3),
        timeStart: Timeline.hendersonStart,
        timeEnd: Timeline.hendersonEnd,
      ),
    ),

    AnimaBackground(
      AnimaBackgroundState(
        imageAsset: '$kAssets/images/largo.jpg',
        gradientAlignment: const Alignment(0.7, -0.1),
        timeStart: Timeline.largoStart,
        timeEnd: Timeline.largoEnd,
      ),
    ),

    AnimaBackground(
      AnimaBackgroundState(
        imageAsset: '$kAssets/images/domino.jpg',
        gradientAlignment: const Alignment(-0.1, -0.2),
        timeStart: Timeline.dominoStart,
        timeEnd: Timeline.dominoEnd,
      ),
    ),

    // Deckr animation
    AnimaText(
      AnimaTextState(
        line: AnimaTextLine(
          text: 'Deckr'.toUpperCase(),
          fontSize: 64,
          bold: true,
          color: Colors.white,
        ),
        alignments: [
          const Alignment(-0.8, -2),
          const Alignment(-0.8, -0.8),
        ],
        timeStart: Timeline.textStart,
        timeEnd: Timeline.textEnd,
      ),
    ),

    AnimaElements.hendersonQuote(),
    AnimaElements.largoQuote(),
    AnimaElements.dominoQuote(),
    AnimaElements.randomQuote(),
    AnimaElements.introTitles(),

    // ball animation
    AnimationBallState(),

    AnimaBlocks(
      AnimaBlocksState(
        timeStart: Timeline.blocksStart,
        timeEnd: Timeline.blocksEnd,
        blocksSequence: AnimaBlocksUtils.blocksSequenceFull,
        opacitySequence: AnimaBlocksUtils.opacitySequence,
        flipSequence: AnimaBlocksUtils.flipSequence,
        circles: true,
        colorSequence: AnimaBlocksUtils.colorSequence(Colors.cyan, Colors.pink),
        margin: 0,
      ),
    ),

    AnimaBlocks(
      AnimaBlocksState(
        timeStart: Timeline.blocks2Start,
        timeEnd: Timeline.blocks2End,
        reverse: true,
        downward: true,
        numColumns: 3,
        margin: 22,
        blocksSequence: AnimaBlocksUtils.blocksSequence,
        flipSequence: AnimaBlocksUtils.flipSequence,
      ),
    ),
  ];

  // =================================================

  Future<void> initialize(AnimationController controller) async {
    if (!isInitialized) {
      for (final item in _runables) {
        await item.initialize(controller);
      }

      isInitialized = true;
    }
  }

  void paint(Canvas canvas, Size size) {
    for (final item in _runables) {
      item.paint(canvas, size);
    }
  }
}
