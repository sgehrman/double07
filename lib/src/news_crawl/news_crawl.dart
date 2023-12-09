import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/src/animations/text/letter_painter.dart';
import 'package:double07/src/news_crawl/news_crawl_controller.dart';
import 'package:flutter/material.dart';

class NewsCrawlParams {
  const NewsCrawlParams({
    required this.backColor,
    required this.textColor,
    required this.selectedTextColor,
    required this.height,
    required this.style,
    required this.onTap,
    required this.maxLength,
    required this.links,
    this.duration = const Duration(seconds: 20),
  });

  final Color backColor;
  final Color textColor;
  final Color selectedTextColor;
  final double height;
  final TextStyle style;
  final int maxLength;
  final Duration duration;
  final List<NewsCrawlLink> links;
  final void Function(NewsCrawlLink link) onTap;
}

// =============================================================

class NewsCrawl extends StatelessWidget {
  const NewsCrawl(this.params);

  final NewsCrawlParams params;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: params.backColor,
        ),
        width: double.infinity,
        height: params.height,
        child: _NewsCrawl(params),
      ),
    );
  }
}

// =======================================================

class _NewsCrawl extends StatefulWidget {
  const _NewsCrawl(this.params);

  final NewsCrawlParams params;

  @override
  State<_NewsCrawl> createState() => _NewsCrawlState();
}

class _NewsCrawlState extends State<_NewsCrawl> with TickerProviderStateMixin {
  NewsCrawlController? _controller;

  @override
  void initState() {
    super.initState();

    _updateController();
  }

  @override
  void dispose() {
    _controller?.dispose();

    // free up cached images
    LetterPainterCache().clear();

    super.dispose();
  }

  void _updateController() {
    _controller?.dispose();

    _controller = NewsCrawlController(
      params: widget.params,
      tickerProvider: this,
      callback: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void didUpdateWidget(covariant _NewsCrawl oldWidget) {
    super.didUpdateWidget(oldWidget);

    _updateController();
  }

  List<NewsCrawlWidgetController> get widgetControllers {
    return _controller?.widgetControllers ?? [];
  }

  void _pauseAnimations({required bool pause}) {
    for (final c in widgetControllers) {
      c.pause(pause: pause);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    for (final c in widgetControllers) {
      children.add(
        _NewsCrawlWidget(
          widgetController: c,
          textColor: widget.params.textColor,
          onTap: widget.params.onTap,
          selectedTextColor: widget.params.selectedTextColor,
        ),
      );
    }

    children.add(_GradientWidget(widget.params.backColor));

    return MouseRegion(
      onEnter: (x) {
        _pauseAnimations(pause: true);
      },
      onExit: (x) {
        _pauseAnimations(pause: false);
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
    required this.widgetController,
    required this.textColor,
    required this.selectedTextColor,
    required this.onTap,
  });

  final NewsCrawlWidgetController widgetController;
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

    widget.widgetController.addListener(_callback);
  }

  @override
  void dispose() {
    widget.widgetController.removeListener(_callback);

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _NewsCrawlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.widgetController.removeListener(_callback);
    widget.widgetController.addListener(_callback);
  }

  void _callback() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.widgetController.isInitialized) {
      return SizedBox.expand(
        key: ValueKey(widget.widgetController.id),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Transform.translate(
              offset: Offset(
                widget.widgetController.getTranslateX(constraints.maxWidth),
                0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: widget.widgetController.image!.width.toDouble(),
                  height: widget.widgetController.image!.height.toDouble(),
                  child: ToolTip(
                    message: widget.widgetController.link.title,
                    child: MouseRegion(
                      onEnter: (x) {
                        _mouseOver = true;
                        setState(() {});
                      },
                      onExit: (x) {
                        _mouseOver = false;
                        setState(() {});
                      },
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            widget.onTap(widget.widgetController.link);
                          },
                          child: CustomPaint(
                            size: Size(
                              widget.widgetController.image!.width.toDouble(),
                              widget.widgetController.image!.height.toDouble(),
                            ),
                            painter: _NewsCrawlTextPainter(
                              image: widget.widgetController.image!,
                              textColor: _mouseOver
                                  ? widget.selectedTextColor
                                  : widget.textColor,
                            ),
                          ),
                        ),
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

    if (destRect.overlaps(rect)) {
      paintImage(
        canvas: canvas,
        rect: destRect,
        image: image,
        colorFilter: ColorFilter.mode(textColor, BlendMode.srcATop),
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
    const double gradientWidth = 60;

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
