import 'dart:async';
import 'dart:ui' as ui;

import 'package:double07/src/animations/text/animated_letter.dart';
import 'package:double07/src/animations/text/letter_painter.dart';
import 'package:flutter/material.dart';

class NewsCrawl extends StatefulWidget {
  const NewsCrawl();

  @override
  State<NewsCrawl> createState() => _NewsCrawlState();
}

class _NewsCrawlState extends State<NewsCrawl>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  ui.Image? _image;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _animation = ReverseAnimation(
      _controller,
    );

    _setup();
  }

  @override
  void dispose() {
    _controller.dispose();

    // free up cached images
    LetterPainterCache().clear();

    super.dispose();
  }

  Future<void> _setup() async {
    _image = await AnimatedLetter.textImage(
      text: 'Test text image',
      style: const TextStyle(
        fontSize: 30,
      ),
      letterSpacing: 1,
    );

    if (mounted) {
      setState(() {});
    }

    await _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return MouseRegion(
        onEnter: (x) {
          _controller.stop();
        },
        onExit: (x) {
          _controller.forward();
        },
        child: SizedBox(
          width: double.infinity,
          height: 80,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final imageWidth = _image!.width;
              final width = constraints.maxWidth + imageWidth;
              final x = _animation.value * width;

              return CustomPaint(
                painter: _NewsCrawlSentence(
                  image: _image!,
                  translateX: x - imageWidth,
                ),
              );
            },
          ),
        ),
      );
    }

    return const SizedBox();
  }
}

// =======================================================

class _NewsCrawlSentence extends CustomPainter {
  const _NewsCrawlSentence({
    required this.translateX,
    required this.image,
  });

  final double translateX;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.drawRect(rect, Paint()..color = Colors.black);

    final destRect = Rect.fromLTWH(
      translateX,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );

    paintImage(
      canvas: canvas,
      rect: destRect,
      image: image,
      fit: BoxFit.scaleDown,
      isAntiAlias: true,
      filterQuality: FilterQuality.high,
    );
  }

  // =================================================

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
