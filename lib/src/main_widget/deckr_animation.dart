import 'package:double07/src/animation_state.dart';
import 'package:double07/src/audio_player/background_audio_player.dart';
import 'package:double07/src/main_widget/deckr_animation_painter.dart';
import 'package:flutter/material.dart';

class DeckrAnimation extends StatefulWidget {
  const DeckrAnimation({
    required this.autoplay,
  });

  final bool autoplay;

  @override
  State<DeckrAnimation> createState() => _DeckrAnimationState();
}

class _DeckrAnimationState extends State<DeckrAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final AnimationState _animationState = AnimationState();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    _setup();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Future<void> _setup() async {
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    await _animationState.initialize(_controller);

    if (mounted) {
      setState(() {});
    }
    await _controller.forward();
  }

  // =================================================

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            if (_animationState.isInitialized) {
              return ColoredBox(
                color: Colors.black,
                child: Center(
                  child: FittedBox(
                    child: CustomPaint(
                      size: const Size(2048, 1024),
                      painter: DeckrAnimationPainter(_animationState),
                    ),
                  ),
                ),
              );
            }

            return const ColoredBox(
              color: Colors.black87,
            );
          },
        ),
        BackgroundAudioPlayer(autoplay: widget.autoplay),
      ],
    );
  }
}
