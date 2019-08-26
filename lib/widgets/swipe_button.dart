import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

enum SwipePosition {
  SwipeLeft,
  SwipeRight,
}

class SwipeButton extends StatefulWidget {
  const SwipeButton({
    Key key,
    this.thumb,
    this.content,
    BorderRadius borderRadius,
    this.initialPosition = SwipePosition.SwipeLeft,
    @required this.onChanged,
    this.height = 56.0,
  })  : assert(initialPosition != null && onChanged != null && height != null),
        this.borderRadius = borderRadius ?? BorderRadius.zero,
        super(key: key);

  final Widget thumb;
  final Widget content;
  final BorderRadius borderRadius;
  final double height;
  final SwipePosition initialPosition;
  final ValueChanged<SwipePosition> onChanged;

  @override
  SwipeButtonState createState() => SwipeButtonState();
}

class SwipeButtonState extends State<SwipeButton>
    with SingleTickerProviderStateMixin {
  final GlobalKey _containerKey = GlobalKey();
  final GlobalKey _positionedKey = GlobalKey();

  AnimationController _controller;
  Animation<double> _contentAnimation;
  Offset _start = Offset.zero;

  RenderBox get _positioned => _positionedKey.currentContext.findRenderObject();

  RenderBox get _container => _containerKey.currentContext.findRenderObject();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);
    _contentAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    if (widget.initialPosition == SwipePosition.SwipeRight) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: Stack(
        key: _containerKey,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.primaryColorLight,
              borderRadius: widget.borderRadius,
            ),
            child: ClipRRect(
              clipper: _SwipeButtonClipper(
                animation: _controller,
                borderRadius: widget.borderRadius,
              ),
              borderRadius: widget.borderRadius,
              child: SizedBox.expand(
                child: Padding(
                  padding: EdgeInsets.only(left: widget.height),
                  child: FadeTransition(
                    opacity: _contentAnimation,
                    child: widget.content,
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return Align(
                alignment: Alignment((_controller.value * 2.0) - 1.0, 0.0),
                child: child,
              );
            },
            child: GestureDetector(
              onHorizontalDragStart: _onDragStart,
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              child: Container(
                key: _positionedKey,
                width: widget.height,
                height: widget.height,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: widget.borderRadius,
                ),
                child: widget.thumb,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    final pos = _positioned.globalToLocal(details.globalPosition);
    _start = Offset(pos.dx, 0.0);
    _controller.stop(canceled: true);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final pos = _container.globalToLocal(details.globalPosition) - _start;
    final extent = _container.size.width - _positioned.size.width;
    _controller.value = (pos.dx.clamp(0.0, extent) / extent);
  }

  void _onDragEnd(DragEndDetails details) {
    final extent = _container.size.width - _positioned.size.width;
    var fractionalVelocity = (details.primaryVelocity / extent).abs();
    if (fractionalVelocity < 0.5) {
      fractionalVelocity = 0.5;
    }
    SwipePosition result;
    double acceleration, velocity;
    if (_controller.value > 0.5) {
      acceleration = 0.5;
      velocity = fractionalVelocity;
      result = SwipePosition.SwipeRight;
    } else {
      acceleration = -0.5;
      velocity = -fractionalVelocity;
      result = SwipePosition.SwipeLeft;
    }
    final simulation = _SwipeSimulation(
      acceleration,
      _controller.value,
      1.0,
      velocity,
    );
    _controller.animateWith(simulation).then((_) {
      if (widget.onChanged != null) {
        widget.onChanged(result);
      }
    });
  }
}

class _SwipeSimulation extends GravitySimulation {
  _SwipeSimulation(
      double acceleration, double distance, double endDistance, double velocity)
      : super(acceleration, distance, endDistance, velocity);

  @override
  double x(double time) => super.x(time).clamp(0.0, 1.0);

  @override
  bool isDone(double time) {
    final _x = x(time).abs();
    return _x <= 0.0 || _x >= 1.0;
  }
}

class _SwipeButtonClipper extends CustomClipper<RRect> {
  const _SwipeButtonClipper({
    @required this.animation,
    @required this.borderRadius,
  })  : assert(animation != null && borderRadius != null),
        super(reclip: animation);

  final Animation<double> animation;
  final BorderRadius borderRadius;

  @override
  RRect getClip(Size size) {
    return borderRadius.toRRect(
      Rect.fromLTRB(
        size.width * animation.value,
        0.0,
        size.width,
        size.height,
      ),
    );
  }

  @override
  bool shouldReclip(_SwipeButtonClipper oldClipper) => true;
}
