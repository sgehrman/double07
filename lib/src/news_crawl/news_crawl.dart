import 'dart:ui' as ui;

import 'package:double07/src/animations/text/letter_painter.dart';
import 'package:double07/src/news_crawl/news_crawl_controller.dart';
import 'package:flutter/material.dart';

class NewsCrawl extends StatelessWidget {
  const NewsCrawl({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: 80,
      child: const _NewsCrawl(),
    );
  }
}

class _NewsCrawl extends StatefulWidget {
  const _NewsCrawl();

  @override
  State<_NewsCrawl> createState() => _NewsCrawlState();
}

class _NewsCrawlState extends State<_NewsCrawl> {
  late final NewsCrawlController _controller;

  @override
  void initState() {
    super.initState();

    _controller = NewsCrawlController(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    // free up cached images
    LetterPainterCache().clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isInitialized) {
      return MouseRegion(
        onEnter: (x) {
          _controller.pause();
        },
        onExit: (x) {
          _controller.pause();
        },
        child: SizedBox(
          width: double.infinity,
          height: 80,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                painter: _NewsCrawlSentence(
                  image: _controller.image!,
                  translateX: _controller.getTranslateX(constraints.maxWidth),
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
