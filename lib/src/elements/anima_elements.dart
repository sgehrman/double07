import 'package:double07/src/animation_state.dart';
import 'package:double07/src/animations/text/anima_paragraph.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/timeline.dart';
import 'package:flutter/material.dart';

class AnimaElements {
  static RunableAnimation dominoQuote() {
    return AnimaParagraph(
      alignment: const Alignment(-0.12, 0.7),
      timeStart: Timeline.dominoTextStart,
      timeEnd: Timeline.dominoTextEnd,
      animateFrom: 0,
      lines: [
        AnimaTextLine(
          text: 'My darlings,',
          fontSize: 32,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: 'I adore using Deckr after',
          fontSize: 32,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: 'diving in the Bahamas.',
          fontSize: 32,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: '- Domino',
          fontSize: 44,
          color: Colors.cyan,
        ),
      ],
    );
  }

  static RunableAnimation largoQuote() {
    return AnimaParagraph(
      alignment: const Alignment(0.6, 0.8),
      timeStart: Timeline.largoTextStart,
      timeEnd: Timeline.largoTextEnd,
      animateFrom: 0,
      lines: [
        AnimaTextLine(
          text: 'All members of SPECTER',
          fontSize: 32,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: 'Are required to use Deckr.',
          fontSize: 32,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: '- Emilio Largo',
          fontSize: 44,
          color: Colors.cyan,
        ),
      ],
    );
  }

  static RunableAnimation hendersonQuote() {
    return AnimaParagraph(
      alignment: const Alignment(-0.2, 0.6),
      timeStart: Timeline.hendersonTextStart,
      timeEnd: Timeline.hendersonTextEnd,
      animateFrom: 0,
      lines: [
        AnimaTextLine(
          text: 'A friend of mine at the Russian Embassy',
          fontSize: 32,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: 'Recommended I use Deckr among other things.',
          fontSize: 32,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: '- Mr. Henderson',
          fontSize: 44,
          color: Colors.cyan,
        ),
      ],
    );
  }
}
