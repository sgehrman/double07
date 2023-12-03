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

class _NewsCrawlState extends State<_NewsCrawl>
    with SingleTickerProviderStateMixin {
  late final NewsCrawlController _controller;

  @override
  void initState() {
    super.initState();

    _controller = NewsCrawlController(
      links: [
        NewsCrawlLink(
          title: 'BBC news: Dog dies of herpes.',
          url: 'http://www.douche.com',
        ),
        NewsCrawlLink(
          title: 'Tom Jones is dead.',
          url: 'http://www.douche.com',
        ),
        NewsCrawlLink(
          title: 'Hairy armpits are sexy',
          url: 'http://www.douche.com',
        ),
        NewsCrawlLink(
          title: 'Sadat is king of Syria.',
          url: 'http://www.douche.com',
        ),
        NewsCrawlLink(
          title: 'Austrailia is super lame and gay.',
          url: 'http://www.douche.com',
        ),
        NewsCrawlLink(
          title: 'Kat Kennedy is a bozo.',
          url: 'http://www.douche.com',
        ),
      ],
      callback: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
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

    return MouseRegion(
      onEnter: (x) {
        for (final c in _controller.widgetControllers) {
          c.pause();
        }
      },
      onExit: (x) {
        for (final c in _controller.widgetControllers) {
          c.pause();
        }
      },
      child: Stack(
        children: children,
      ),
    );
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

    widget.controller.addListener(_callback);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_callback);

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _NewsCrawlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.controller.removeListener(_callback);
    widget.controller.addListener(_callback);
  }

  void _callback() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.isInitialized) {
      return SizedBox(
        key: ValueKey(widget.controller.id),
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

    final destRect = Rect.fromLTWH(
      translateX,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );

    if (destRect.overlaps(rect)) {
      paintImage(
        canvas: canvas,
        rect: destRect,
        image: image,
        fit: BoxFit.scaleDown,
        isAntiAlias: true,
        filterQuality: FilterQuality.high,
      );
    }
  }

  // =================================================

  @override
  bool shouldRepaint(covariant _NewsCrawlSentence oldDelegate) {
    if (oldDelegate.translateX != translateX || oldDelegate.image != image) {
      return true;
    }

    return false;
  }
}
