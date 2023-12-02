import 'package:double07/src/animation_sequence/runnable_animation.dart';
import 'package:double07/src/animations/anima_double07.dart';
import 'package:double07/src/animations/anima_image/anima_image.dart';
import 'package:double07/src/animations/anima_image/anima_image_state.dart';
import 'package:double07/src/animations/backgrounds/anima_background.dart';
import 'package:double07/src/animations/backgrounds/anima_background_state.dart';
import 'package:double07/src/animations/common_animations.dart';
import 'package:double07/src/animations/shapes/anima_blocks.dart';
import 'package:double07/src/animations/shapes/anima_blocks_state.dart';
import 'package:double07/src/animations/shapes/anima_blocks_utils.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/animations/text/paragraph/anima_paragraph.dart';
import 'package:double07/src/animations/text/titles/anima_titles.dart';
import 'package:double07/src/constants.dart';
import 'package:double07/src/timeline.dart';
import 'package:flutter/material.dart';

class AnimaElements {
  static RunableAnimation dominoQuote() {
    return AnimaParagraph(
      alignment: const Alignment(-0.12, 0.6),
      timeStart: Timeline.dominoTextStart,
      timeEnd: Timeline.dominoTextEnd,
      animateDown: false,
      lines: [
        AnimaTextLine(
          text: 'My darlings,',
          fontSize: AnimaTextLine.kSmallFontSize,
        ),
        AnimaTextLine(
          text: 'I adore using Deckr after',
          fontSize: AnimaTextLine.kSmallFontSize,
        ),
        AnimaTextLine(
          text: 'diving in the Bahamas.',
          fontSize: AnimaTextLine.kSmallFontSize,
        ),
        AnimaTextLine.blank(),
        AnimaTextLine(
          text: '- Domino',
          fontSize: AnimaTextLine.kLargeFontSize,
          color: Colors.cyan,
        ),
      ],
    );
  }

  static RunableAnimation largoQuote() {
    return AnimaParagraph(
      alignment: const Alignment(0.7, 0.75),
      timeStart: Timeline.largoTextStart,
      timeEnd: Timeline.largoTextEnd,
      animateDown: false,
      lines: [
        AnimaTextLine(
          text: 'All members of SPECTER',
          fontSize: AnimaTextLine.kSmallFontSize,
        ),
        AnimaTextLine(
          text: 'are required to use Deckr.',
          fontSize: AnimaTextLine.kSmallFontSize,
        ),
        AnimaTextLine.blank(),
        AnimaTextLine(
          text: '- Emilio Largo',
          fontSize: AnimaTextLine.kLargeFontSize,
          color: Colors.cyan,
        ),
      ],
    );
  }

  static RunableAnimation hendersonQuote() {
    return AnimaParagraph(
      alignment: const Alignment(-0.35, 0.6),
      timeStart: Timeline.hendersonTextStart,
      timeEnd: Timeline.hendersonTextEnd,
      animateDown: false,
      lines: [
        AnimaTextLine(
          text: 'A friend of mine at the Russian Embassy',
          fontSize: AnimaTextLine.kSmallFontSize,
        ),
        AnimaTextLine(
          text: 'recommended I use Deckr, among other things.',
          fontSize: AnimaTextLine.kSmallFontSize,
        ),
        AnimaTextLine.blank(),
        AnimaTextLine(
          text: '- Mr. Henderson',
          fontSize: AnimaTextLine.kLargeFontSize,
          color: Colors.cyan,
        ),
      ],
    );
  }

  static RunableAnimation reviewsTitle() {
    return AnimaParagraph(
      alignment: Alignment.center,
      timeStart: Timeline.reviewsStart,
      timeEnd: Timeline.reviewsEnd,
      animateDown: false,
      lines: [
        AnimaTextLine(
          text: 'Deckr Reviews',
          fontSize: AnimaTextLine.kLargeFontSize,
          color: Colors.cyan,
          bold: true,
        ),
        AnimaTextLine(
          text: 'Here\'s some words',
          fontSize: AnimaTextLine.kLargeFontSize,
        ),
        AnimaTextLine(
          text: 'From our customers',
          fontSize: AnimaTextLine.kLargeFontSize,
        ),
      ],
    );
  }

  static RunableAnimation randomQuote() {
    return AnimaParagraph(
      alignment: const Alignment(-0.9, 0.9),
      timeStart: Timeline.quoteStart,
      timeEnd: Timeline.quoteEnd,
      animateDown: false,
      lines: [
        AnimaTextLine(
          text: 'Make one dream come true',
          fontSize: AnimaTextLine.kSmallFontSize,
          animationTypes: {
            TextAnimationType.opacity,
          },
          opacity: 0.4,
        ),
        AnimaTextLine(
          text: 'You only live twice',
          fontSize: AnimaTextLine.kSmallFontSize,
          color: Colors.cyan,
          opacity: 0.4,
        ),
      ],
    );
  }

  static RunableAnimation introTitles() {
    final animationTypes = {
      TextAnimationType.alignment,
      TextAnimationType.opacity,
    };

    const opacity = 0.4;

    return AnimaTitles(
      alignment: const Alignment(0, -0.6),
      timeStart: Timeline.mainTitlesStart,
      timeEnd: Timeline.mainTitlesEnd,
      lines: [
        AnimaTextLine(
          text: 'Welcome to DECKR',
          fontSize: AnimaTextLine.kTitleFontSize,
          animationTypes: animationTypes,
          color: Colors.cyan,
        ),
        AnimaTextLine(
          text: 'Secret Experimental Zone',
          fontSize: AnimaTextLine.kTitleFontSize,
          animationTypes: animationTypes,
          opacity: opacity,
        ),
        AnimaTextLine(
          text: 'We\'re working on new Modern UI designs',
          fontSize: AnimaTextLine.kTitleFontSize,
          animationTypes: animationTypes,
          opacity: opacity,
        ),
        AnimaTextLine(
          text: 'This is a fun zone to test different techniques',
          fontSize: AnimaTextLine.kTitleFontSize,
          animationTypes: animationTypes,
          opacity: opacity,
        ),
      ],
    );
  }

  static List<RunableAnimation> blocks() {
    return [
      AnimaBlocks(
        AnimaBlocksState(
          timeStart: Timeline.blocksStart,
          timeEnd: Timeline.blocksEnd,
          blocksSequence: AnimaBlocksUtils.blocksSequenceFull,
          opacitySequence: AnimaBlocksUtils.opacitySequence,
          flipSequence: AnimaBlocksUtils.flipSequence,
          circles: true,
          colorSequence:
              AnimaBlocksUtils.colorSequence(Colors.cyan, Colors.pink),
          margin: 0,
        ),
      ),
      AnimaBlocks(
        AnimaBlocksState(
          timeStart: Timeline.blocks2Start,
          timeEnd: Timeline.blocks2End,
          reverse: true,
          downward: true,
          numColumns: 5,
          margin: 22,
          blocksSequence: AnimaBlocksUtils.blocksSequence,
          flipSequence: AnimaBlocksUtils.flipSequence,
        ),
      ),
    ];
  }

  static List<RunableAnimation> backgrounds() {
    return [
      AnimaBackground(
        AnimaBackgroundState(
          imageAsset: '$kAssets/images/oddjob.jpg',
          gradientAlignment: Alignment.center,
          timeStart: Timeline.scaledImageStart,
          timeEnd: Timeline.scaledImageEnd,
          mode: AnimaBackgroundMode.zoomIn,
        ),
      ),
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
    ];
  }

  static RunableAnimation deckrLogo() {
    return AnimaParagraph(
      alignment: const Alignment(0.95, 0.95),
      timeStart: Timeline.deckrLogoStart,
      timeEnd: Timeline.deckrLogoEnd,
      lines: [
        AnimaTextLine(
          text: 'Deckr'.toUpperCase(),
          bold: true,
          fontSize: AnimaTextLine.kTitleFontSize,
          opacity: 0.4,
        ),
      ],
    );
  }

  static RunableAnimation theEnd() {
    return AnimaParagraph(
      alignment: Alignment.center,
      timeStart: Timeline.creditsStart,
      timeEnd: Timeline.creditsEnd,
      lines: [
        AnimaTextLine(
          text: 'The End',
          bold: true,
          fontSize: AnimaTextLine.kHeaderFontSize,
        ),
      ],
    );
  }

  static RunableAnimation binoculars() {
    return AnimaBackground(
      AnimaBackgroundState(
        imageAsset: '$kAssets/images/henderson.png',
        gradientAlignment: Alignment.center,
        timeStart: Timeline.binocularsStart,
        timeEnd: Timeline.binocularsEnd,
        mode: AnimaBackgroundMode.binoculars,
      ),
    );
  }

  static List<RunableAnimation> easterEggs() {
    const int millis = 80;
    final result = [
      AnimaElements.easterEgg(
        0.9,
        Timeline.easterEggStart,
        Timeline.easterEggEnd,
        Alignment.topCenter,
      ),
    ];

    final alignments = [
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.topCenter,
      Alignment.bottomLeft,
      Alignment.bottomRight,
      Alignment.bottomCenter,
    ];

    int aIndex = 0;

    for (int i = 0; i < 10; i++) {
      final from = alignments[aIndex];

      aIndex++;
      if (aIndex >= alignments.length) {
        aIndex = 0;
      }

      result.add(
        AnimaElements.easterEgg(
          0.5,
          Timeline.easterEggStart + Timeline.durMillis(millis * i),
          Timeline.easterEggEnd,
          from,
        ),
      );
    }

    return result;
  }

  static RunableAnimation easterEgg(
    double opacity,
    double start,
    double end,
    Alignment from,
  ) {
    return AnimaImage(
      AnimaImageState(
        imageAsset: '$kAssets/images/egg.png',
        size: const Size(200, 200),
        timeStart: start,
        opacity: opacity,
        timeEnd: end,
        alignments: AnimaAlignments(
          const Alignment(0, 0.7),
          from: from,
          to: Alignment.topCenter,
        ),
      ),
    );
  }

  static RunableAnimation double07Ball() {
    return AnimaDouble07();
  }
}
