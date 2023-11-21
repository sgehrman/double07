import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/src/animation_state.dart';
import 'package:double07/src/audio_player/background_audio_player.dart';
import 'package:double07/src/main_widget/deckr_animation_painter.dart';
import 'package:double07/src/timeline.dart';
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
      duration: Timeline.runDuration,
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
              color: Colors.black,
            );
          },
        ),
        BackgroundAudioPlayer(autoplay: widget.autoplay),
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: _AnimationSlider(_controller),
        ),
      ],
    );
  }
}

// ==========================================================

class _AnimationSlider extends StatefulWidget {
  const _AnimationSlider(this.controller);

  final AnimationController controller;

  @override
  State<_AnimationSlider> createState() => _AnimationSliderState();
}

class _AnimationSliderState extends State<_AnimationSlider> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);

    super.dispose();
  }

  void _listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DFIconButton(
              color: Colors.cyan,
              onPressed: () {
                if (!widget.controller.isAnimating) {
                  widget.controller.forward();
                } else {
                  widget.controller.stop();
                }

                setState(() {});
              },
              icon: Icon(
                widget.controller.isAnimating ? Icons.stop : Icons.play_arrow,
              ),
            ),
            Slider.adaptive(
              value: widget.controller.value,
              onChanged: (value) {
                final wasRunning = widget.controller.isAnimating;

                widget.controller.value = value;

                if (wasRunning) {
                  widget.controller.forward();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
