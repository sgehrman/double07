import 'dart:ui' as ui;

import 'package:double07/src/animations/text/letter_painter.dart';
import 'package:double07/src/news_crawl/news_crawl_controller.dart';
import 'package:flutter/material.dart';

class NewsCrawl extends StatelessWidget {
  const NewsCrawl({
    required this.backColor,
    required this.textColor,
    required this.selectedTextColor,
    required this.height,
    required this.fontSize,
    required this.onTap,
    required this.links,
    this.duration = const Duration(seconds: 20),
  });

  final Color backColor;
  final Color textColor;
  final Color selectedTextColor;
  final double height;
  final double fontSize;
  final Duration duration;
  final List<NewsCrawlLink> links;
  final void Function(NewsCrawlLink link) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: backColor,
      ),
      width: double.infinity,
      height: height,
      child: _NewsCrawl(
        backColor: backColor,
        textColor: textColor,
        fontSize: fontSize,
        duration: duration,
        onTap: onTap,
        selectedTextColor: selectedTextColor,
        links: links,
      ),
    );
  }
}

// =======================================================

class _NewsCrawl extends StatefulWidget {
  const _NewsCrawl({
    required this.backColor,
    required this.textColor,
    required this.selectedTextColor,
    required this.fontSize,
    required this.duration,
    required this.onTap,
    required this.links,
  });

  final Color backColor;
  final Color textColor;
  final Color selectedTextColor;
  final double fontSize;
  final Duration duration;
  final void Function(NewsCrawlLink link) onTap;
  final List<NewsCrawlLink> links;

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
      links: widget.links,
      callback: () {
        if (mounted) {
          setState(() {});
        }
      },
      fontSize: widget.fontSize,
      duration: widget.duration,
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
      children.add(
        _NewsCrawlWidget(
          controller: c,
          textColor: widget.textColor,
          onTap: widget.onTap,
          selectedTextColor: widget.selectedTextColor,
        ),
      );
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
  const _NewsCrawlWidget({
    required this.controller,
    required this.textColor,
    required this.selectedTextColor,
    required this.onTap,
  });

  final NewsCrawlWidgetController controller;
  final Color textColor;
  final Color selectedTextColor;
  final void Function(NewsCrawlLink link) onTap;

  @override
  State<_NewsCrawlWidget> createState() => _NewsCrawlWidgetState();
}

class _NewsCrawlWidgetState extends State<_NewsCrawlWidget> {
  bool _mouseOver = false;

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
            return Transform.translate(
              offset: Offset(
                widget.controller.getTranslateX(constraints.maxWidth),
                0,
              ),
              child: SizedBox(
                width: widget.controller.image!.width.toDouble(),
                height: widget.controller.image!.height.toDouble(),
                child: MouseRegion(
                  onEnter: (x) {
                    _mouseOver = true;

                    setState(() {});
                  },
                  onExit: (x) {
                    _mouseOver = false;

                    setState(() {});
                  },
                  child: InkWell(
                    onTap: () {
                      widget.onTap(widget.controller.link);
                    },
                    child: CustomPaint(
                      size: Size(
                        widget.controller.image!.width.toDouble(),
                        widget.controller.image!.height.toDouble(),
                      ),
                      painter: _NewsCrawlTextPainter(
                        image: widget.controller.image!,
                        textColor: _mouseOver
                            ? widget.selectedTextColor
                            : widget.textColor,
                      ),
                    ),
                  ),
                ),
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
    required this.image,
    required this.textColor,
  });

  final ui.Image image;
  final Color textColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final destRect = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );

    final ColorFilter? colorFilter = textColor != Colors.white
        ? ColorFilter.mode(textColor, BlendMode.srcATop)
        : null;

    if (destRect.overlaps(rect)) {
      paintImage(
        canvas: canvas,
        rect: destRect,
        image: image,
        colorFilter: colorFilter,
        fit: BoxFit.scaleDown,
        isAntiAlias: true,
        filterQuality: FilterQuality.high,
      );
    }
  }

  // =================================================

  @override
  bool shouldRepaint(covariant _NewsCrawlTextPainter oldDelegate) {
    if (oldDelegate.image != image) {
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
    return IgnorePointer(
      key: const ValueKey('gradient'),
      child: SizedBox.expand(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomPaint(
              painter: _GradientPainter(color),
            );
          },
        ),
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

// ===========================================================

class NewsCrawlLink {
  NewsCrawlLink({
    required this.title,
    required this.url,
  });

  String title;
  String url;
}
