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
        _animationState.reset();
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
    ).animate(_controller);
  }

  // =================================================

  void _buildTextAnimations() {
    final len = _animationState.textString.length;

    for (int i = 0; i < len; i++) {
      _textAnimations.add(
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              0,
              0.5 + ((i / len) * 0.5),
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
