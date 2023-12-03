import 'dart:ui' as ui;

import 'package:double07/src/animations/text/letter_painter.dart';
import 'package:double07/src/news_crawl/news_crawl_controller.dart';
import 'package:flutter/material.dart';

class NewsCrawl extends StatelessWidget {
  const NewsCrawl({
    required this.backColor,
    required this.textColor,
    required this.height,
    required this.fontSize,
  });

  final Color backColor;
  final Color textColor;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backColor,
      width: double.infinity,
      height: height,
      child: _NewsCrawl(
        backColor: backColor,
        textColor: textColor,
        fontSize: fontSize,
      ),
    );
  }
}

// =======================================================

class _NewsCrawl extends StatefulWidget {
  const _NewsCrawl({
    required this.backColor,
    required this.textColor,
    required this.fontSize,
  });

  final Color backColor;
  final Color textColor;
  final double fontSize;

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
      fontSize: widget.fontSize,
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

    children.add(_GradientWidget(widget.backColor));

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
      return SizedBox.expand(
        key: ValueKey(widget.controller.id),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomPaint(
              painter: _NewsCrawlTextPainter(
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

class _NewsCrawlTextPainter extends CustomPainter {
  const _NewsCrawlTextPainter({
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
  bool shouldRepaint(covariant _NewsCrawlTextPainter oldDelegate) {
    if (oldDelegate.translateX != translateX || oldDelegate.image != image) {
      return true;
    }

    return false;
  }
}

// ===========================================================

class _GradientWidget extends StatelessWidget {
  const _GradientWidget(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      key: const ValueKey('gradient'),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CustomPaint(
            painter: _GradientPainter(color),
          );
        },
      ),
    );
  }
}

// =======================================================

class _GradientPainter extends CustomPainter {
  const _GradientPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const double gradientWidth = 100;

    final leftRect = Rect.fromLTWH(
      rect.left,
      rect.top,
      gradientWidth,
      rect.height,
    );

    final leftGradient = Paint();
    leftGradient.shader = LinearGradient(
      colors: [color, color.withOpacity(0)],
    ).createShader(leftRect);

    canvas.drawRect(leftRect, leftGradient);

    final rightRect = Rect.fromLTWH(
      rect.right - gradientWidth,
      rect.top,
      gradientWidth,
      rect.height,
    );

    final rightGradient = Paint();
    rightGradient.shader = LinearGradient(
      colors: [color.withOpacity(0), color],
    ).createShader(rightRect);

    canvas.drawRect(rightRect, rightGradient);
  }

  // =================================================

  @override
  bool shouldRepaint(covariant _GradientPainter oldDelegate) {
    return false;
  }
}
