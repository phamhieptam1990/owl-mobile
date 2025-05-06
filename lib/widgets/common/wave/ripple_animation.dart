import 'package:flutter/material.dart';
import 'curve_wave.dart';
import 'circle_painter.dart';

class RipplesAnimation extends StatefulWidget {
  const RipplesAnimation({
    required Key key,
    this.size = 60.0,
    this.color = Colors.red,
    required this.onPressed,
    required this.child,
  }) : super(key: key);
  final double size;
  final Color color;
  final Widget child;
  final Function onPressed;
  @override
  _RipplesAnimationState createState() => _RipplesAnimationState();
}

class _RipplesAnimationState extends State<RipplesAnimation>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _button() {
    return InkWell(
        onTap: () {
          widget.onPressed.call();
                },
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.size),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: <Color>[
                    widget.color,
                    Color.lerp(widget.color, Colors.black, .05)!
                  ],
                ),
              ),
              child: ScaleTransition(
                  scale: Tween(begin: 0.8, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _controller!,
                      curve: const CurveWave(),
                    ),
                  ),
                  child: Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 40,
                  )),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CirclePainter(
        _controller!,
        color: widget.color,
      ),
      child: SizedBox(
        width: widget.size * 4.125,
        height: widget.size * 4.125,
        child: _button(),
      ),
    );
  }
}
