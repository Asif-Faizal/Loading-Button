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

  const LoadingButtonStyle({
    this.borderRadius = 24.0,
    this.backgroundColor = Colors.blue,
    this.foregroundColor = Colors.white,
    this.width = 120.0,
    this.height = 48.0,
    this.fontSize = 16.0,
    this.elevation = 4.0,
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 70.0,
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutBack,
              width: widget.isLoading ? widget.style.height : widget.style.width,
              height: widget.style.height,
              decoration: BoxDecoration(
                color: widget.style.backgroundColor,
                borderRadius: BorderRadius.circular(widget.style.borderRadius),
                boxShadow: widget.style.elevation > 0
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: widget.style.elevation * 2,
                          offset: Offset(0, widget.style.elevation),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: LoadingPainter(
                                progress: _controller.value,
                                color: widget.style.foregroundColor,
                              ),
                            );
                          },
                        ),
                      )
                    : widget.isDone
                        ? CustomPaint(
                            size: const Size(24, 24),
                            painter: DonePainter(
                              color: widget.style.foregroundColor,
                            ),
                          )
                        : Text(
                            widget.label,
                            style: TextStyle(
                              color: widget.style.foregroundColor,
                              fontSize: widget.style.fontSize,
                            ),
                          ),
              ),
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

  LoadingPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - paint.strokeWidth / 2;

    // Draw the background circle
    paint.color = color.withOpacity(0.2);
    canvas.drawCircle(center, radius, paint);

    // Draw the progress arc
    paint.color = color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(LoadingPainter oldDelegate) =>
      progress != oldDelegate.progress || color != oldDelegate.color;
}

class DonePainter extends CustomPainter {
  final Color color;

  DonePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Path path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.45, size.height * 0.75);
    path.lineTo(size.width * 0.8, size.height * 0.25);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(DonePainter oldDelegate) => color != oldDelegate.color;
}
