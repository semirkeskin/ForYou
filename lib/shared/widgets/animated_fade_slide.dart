import 'package:flutter/material.dart';

class AnimatedFadeSlide extends StatefulWidget {
  const AnimatedFadeSlide({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.offset = 16,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offset;

  @override
  State<AnimatedFadeSlide> createState() => _AnimatedFadeSlideState();
}

class _AnimatedFadeSlideState extends State<AnimatedFadeSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _fade =
      CurvedAnimation(parent: _controller, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _fade.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * widget.offset),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
