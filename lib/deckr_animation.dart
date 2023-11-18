import 'package:double07/animation_state.dart';
import 'package:double07/deckr_animation_painter.dart';
import 'package:flutter/material.dart';

class DeckrAnimation extends StatefulWidget {
  const DeckrAnimation({super.key});

  @override
  State<DeckrAnimation> createState() => _DeckrAnimationState();
}

class _DeckrAnimationState extends State<DeckrAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _ballAnimation;
  final List<Animation<double>> _textAnimations = [];
  final AnimationState _animationState = AnimationState();

  // timing
  final double ballStart = 0;
  final double ballEnd = 1;

  final double textStart = 0.2;
  final double textEnd = 0.9;

  @override
  void initState() {
    super.initState();

    _setup();
  }

  Future<void> _setup() async {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _buildBallAnimation();
    _buildTextAnimations();

    await _animationState.initialize();

    if (mounted) {
      setState(() {});
    }
    await _controller.forward();
  }

  // =================================================

  void _buildBallAnimation() {
    _ballAnimation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1),
          weight: 50,
        ),
      ],
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          ballStart,
          ballEnd,
        ),
      ),
    );
  }

  // =================================================

  void _buildTextAnimations() {
    final len = _animationState.t1.text.length;

    final time = textEnd - textStart;
    double duration = time / len;
    const compress = 0.05;

    final spacer = duration * compress;
    duration = duration + (duration - spacer);

    for (int i = 0; i < len; i++) {
      final start = textStart + (i * spacer);
      final end = start + duration;

      _textAnimations.add(
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              start,
              end,
              curve: Curves.elasticInOut,
            ),
          ),
        ),
      );
    }
  }

  // =================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            if (_animationState.isInitialized) {
              _animationState.update(
                _ballAnimation.value,
                _textAnimations,
              );

              return ColoredBox(
                color: Colors.black87,
                child: FittedBox(
                  child: CustomPaint(
                    size: const Size(2048, 1024),
                    painter: DeckrAnimationPainter(_animationState),
                  ),
                ),
              );
            }

            return const ColoredBox(
              color: Colors.black87,
            );
          },
        ),
      ),
    );
  }
}
