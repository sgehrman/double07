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

// =======================================================

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
    final List<Widget> children = [];

    for (final c in _controller.widgetControllers) {
      children.add(_NewsCrawlWidget(c));
    }

    if (_controller.isInitialized) {
      return Stack(
        children: children,
      );
    }

    return const SizedBox();
  }
}

// =======================================================

class _NewsCrawlWidget extends StatefulWidget {
  const _NewsCrawlWidget(this.controller);
  final NewsCrawlWidgetController controller;

  @override
  State<_NewsCrawlWidget> createState() => _NewsCrawlWidgetState();
}

class _NewsCrawlWidgetState extends State<_NewsCrawlWidget> {
  @override
  void initState() {
    super.initState();

    widget.controller.callback = () {
      if (mounted) {
        setState(() {});
      }
    };
  }

  @override
  void dispose() {
    widget.controller.callback = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.isInitialized) {
      return MouseRegion(
        onEnter: (x) {
          widget.controller.pause();
        },
        onExit: (x) {
          widget.controller.pause();
        },
        child: SizedBox(
          width: double.infinity,
          height: 80,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                painter: _NewsCrawlSentence(
                  image: widget.controller.image!,
                  translateX:
                      widget.controller.getTranslateX(constraints.maxWidth),
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
