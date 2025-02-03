import 'dart:math';
import 'package:flutter/material.dart';

class LoadingButtonStyle {
  final double borderRadius;
  final Color backgroundColor;
  final Color foregroundColor;
  final double width;
  final double height;
  final double fontSize;
  final double elevation;
  final bool isOutlined;
  final double outlineWidth;
  
  final EdgeInsetsGeometry padding;
  final FontWeight fontWeight;
  final String? fontFamily;
  final double loadingIconSize;
  final double doneIconSize;
  final Duration animationDuration;
  final double loadingStrokeWidth;
  final double doneStrokeWidth;

  const LoadingButtonStyle({
    this.borderRadius = 24.0,
    this.backgroundColor = Colors.black,
    this.foregroundColor = Colors.white,
    this.width = 120.0,
    this.height = 48.0,
    this.fontSize = 16.0,
    this.elevation = 4.0,
    this.isOutlined = false,
    this.outlineWidth = 2.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.fontWeight = FontWeight.w500,
    this.fontFamily,
    this.loadingIconSize = 24.0,
    this.doneIconSize = 24.0,
    this.animationDuration = const Duration(milliseconds: 500),
    this.loadingStrokeWidth = 2.5,
    this.doneStrokeWidth = 2.0,
  });
}

class LoadingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isLoading;
  final bool isDone;
  final LoadingButtonStyle style;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.isDone = false,
    this.style = const LoadingButtonStyle(),
  });

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Create a bouncy rotation animation that completes full circle
    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.65)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.6, end: 0.95)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30.0,
      ),
    ]).animate(_controller);
    
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 0.95)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30.0,
      ),
    ]).animate(_controller);

    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(LoadingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) {
      if (widget.isLoading) {
        _controller.repeat();
      } else {
        _controller.forward(from: 0.0);
      }
    } else if (!oldWidget.isDone && widget.isDone) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isDone || widget.isLoading ? _bounceAnimation.value : 1.0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedContainer(
                  duration: widget.style.animationDuration,
                  width: widget.isLoading ? widget.style.height : constraints.maxWidth,
                  height: widget.style.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.style.borderRadius),
                    color: widget.style.isOutlined ? Colors.transparent : widget.style.backgroundColor,
                    border: widget.style.isOutlined
                        ? Border.all(
                            color: widget.style.backgroundColor,
                            width: widget.style.outlineWidth,
                          )
                        : null,
                  ),
                  child: Center(
                    child: widget.isLoading
                        ? SizedBox(
                            width: widget.style.loadingIconSize,
                            height: widget.style.loadingIconSize,
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return CustomPaint(
                                  painter: LoadingPainter(
                                    progress: _rotationAnimation.value,
                                    color: widget.style.foregroundColor,
                                    bounceScale: _bounceAnimation.value,
                                    style: widget.style,
                                  ),
                                );
                              },
                            ),
                          )
                        : widget.isDone
                            ? CustomPaint(
                                size: Size(widget.style.doneIconSize, widget.style.doneIconSize),
                                painter: DonePainter(
                                  color: widget.style.foregroundColor,
                                  strokeWidth: widget.style.doneStrokeWidth,
                                ),
                              )
                            : Padding(
                                padding: widget.style.padding,
                                child: Text(
                                  widget.label,
                                  style: TextStyle(
                                    color: widget.style.foregroundColor,
                                    fontSize: widget.style.fontSize,
                                    fontWeight: widget.style.fontWeight,
                                    fontFamily: widget.style.fontFamily,
                                  ),
                                ),
                              ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class LoadingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double bounceScale;
  final LoadingButtonStyle style;

  LoadingPainter({
    required this.progress,
    required this.color,
    required this.bounceScale,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = style.loadingStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) / 2 - paint.strokeWidth / 2) * bounceScale;

    // Draw the background circle with varying opacity
    paint.color = color.withValues(alpha: 0.5);
    canvas.drawCircle(center, radius, paint);

    // Draw the progress arc with a bouncy effect
    paint.color = color;
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;
    
    // Add a more pronounced elastic effect to the arc
    final elasticRadius = radius * (1 + sin(progress * pi * 2) * 0.05);
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: elasticRadius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    // Add leading dot at the end of the arc
    final dotAngle = startAngle + sweepAngle;
    final dotX = center.dx + cos(dotAngle) * elasticRadius;
    final dotY = center.dy + sin(dotAngle) * elasticRadius;
    
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(dotX, dotY), paint.strokeWidth / 2, paint);
  }

  @override
  bool shouldRepaint(LoadingPainter oldDelegate) =>
      progress != oldDelegate.progress || 
      color != oldDelegate.color ||
      bounceScale != oldDelegate.bounceScale ||
      style != oldDelegate.style;
}

class DonePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  DonePainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Path path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.45, size.height * 0.75);
    path.lineTo(size.width * 0.8, size.height * 0.25);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(DonePainter oldDelegate) => color != oldDelegate.color || strokeWidth != oldDelegate.strokeWidth;
}
