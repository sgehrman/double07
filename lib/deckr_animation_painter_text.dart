import 'package:double07/animated_text_info.dart';
import 'package:double07/animation_text_state.dart';
import 'package:flutter/material.dart';

class DeckrAnimationPainterText {
  static void paintText({
    required Canvas canvas,
    required Size size,
    required AnimationTextState textState,
  }) {
    for (int i = 0; i < textState.textImages.length; i++) {
      _paintText(
        canvas: canvas,
        size: size,
        textImage: textState.textImages[i],
        textAnima: textState.textAnimations[i],
        startAlignment: textState.startAlignment,
        endAlignment: textState.endAlignment,
      );
    }
  }

  static void _paintText({
    required Canvas canvas,
    required Size size,
    required AnimatedTextInfo textImage,
    required Animation<double> textAnima,
    required Alignment startAlignment,
    required Alignment endAlignment,
  }) {
    if (textAnima.value > 0) {
      final rect = Offset.zero & size;
      // const multiplier = math.max(1, (1 - animationState.textAnimValue) * 122);

      final tSize = textImage.painter.size;

      final alignment = Alignment.lerp(
            startAlignment,
            endAlignment,
            textAnima.value,
          ) ??
          Alignment.center;

      Rect destRect = alignment.inscribe(
        Size(
          textImage.wordSize.width,
          textImage.wordSize.height,
        ),
        rect,
      );

      destRect = textImage.alignment.inscribe(
        Size(
          tSize.width,
          tSize.height,
        ),
        destRect,
      );

      paintImage(
        canvas: canvas,
        rect: destRect,
        fit: BoxFit.fill,
        image: textImage.image,
        opacity: 0.1,
        isAntiAlias: true,
        filterQuality: FilterQuality.high,
      );
    }
  }
}
