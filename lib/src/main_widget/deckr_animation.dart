import 'dart:async';

import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/anima_utils.dart';
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
  final AnimationSequence _animationState = AnimationSequence();
  bool _showControls = false;
  Timer? _timer;

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
    _timer?.cancel();

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
    return MouseRegion(
      onHover: (x) {
        _showControls = true;
        setState(() {});

        _timer?.cancel();
        _timer = Timer(const Duration(seconds: 1), () {
          _showControls = false;

          if (mounted) {
            setState(() {});
          }
        });
      },
      child: ColoredBox(
        color: Colors.black,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (!_controller.isAnimating) {
                  _controller.forward();
                } else {
                  _controller.stop();
                }

                setState(() {});
              },
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  if (_animationState.isInitialized) {
                    return Center(
                      child: FittedBox(
                        child: CustomPaint(
                          size: const Size(2048, 1024),
                          painter: DeckrAnimationPainter(_animationState),
                        ),
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
            BackgroundAudioPlayer(autoplay: widget.autoplay),
            Positioned.fill(
              child: IgnorePointer(
                child: Visibility(
                  visible: AnimaUtils.isControllerPaused(_controller),
                  child: Container(
                    color: Colors.black54,
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.cyan,
                      size: 200,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _showControls ? 1 : 0,
                duration: const Duration(
                  milliseconds: 500,
                ),
                child: _AnimationSlider(_controller),
              ),
            ),
          ],
        ),
      ),
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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Slider.adaptive(
          value: widget.controller.value,
          onChanged: (value) {
            final wasRunning = widget.controller.isAnimating;

            widget.controller.value = value;

            if (wasRunning) {
              widget.controller.forward();
            }
          },
        ),
      ),
    );
  }
}
