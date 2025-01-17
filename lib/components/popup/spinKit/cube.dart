part of 'spin_kit.dart';

class SpinKitCubeGrid extends StatefulWidget {
  const SpinKitCubeGrid({
    super.key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  }) : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color');

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<SpinKitCubeGrid> createState() => _SpinKitCubeGridState();
}

class _SpinKitCubeGridState extends State<SpinKitCubeGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim1, _anim2, _anim3, _anim4, _anim5;

  @override
  void initState() {
    super.initState();
    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..repeat(reverse: true);
    _anim1 = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.6, curve: Curves.easeIn)));
    _anim2 = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeIn)));
    _anim3 = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn)));
    _anim4 = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.9, curve: Curves.easeIn)));
    _anim5 = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
        size: Size.square(widget.size),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _square(_anim3, 0),
                    _square(_anim4, 1),
                    _square(_anim5, 2),
                  ]),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _square(_anim2, 3),
                    _square(_anim3, 4),
                    _square(_anim4, 5),
                  ]),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _square(_anim1, 6),
                    _square(_anim2, 7),
                    _square(_anim3, 8),
                  ]),
            ]));
  }

  Widget _square(Animation<double> animation, int index) => ScaleTransition(
      scale: animation,
      child: SizedBox.fromSize(
          size: Size.square(widget.size / 3), child: _itemBuilder(index)));

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(decoration: BoxDecoration(color: widget.color));
}

class SpinKitFoldingCube extends StatefulWidget {
  const SpinKitFoldingCube({
    super.key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 2400),
    this.controller,
  }) : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color');

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<SpinKitFoldingCube> createState() => _SpinKitFoldingCubeState();
}

class _SpinKitFoldingCubeState extends State<SpinKitFoldingCube>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotate1, _rotate2, _rotate3, _rotate4;

  @override
  void initState() {
    super.initState();
    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat(reverse: true);
    _rotate1 = Tween<double>(begin: 0.0, end: 180.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn)));
    _rotate2 = Tween<double>(begin: 0.0, end: 180.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.5, curve: Curves.easeIn)));
    _rotate3 = Tween<double>(begin: 0.0, end: 180.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.75, curve: Curves.easeIn)));
    _rotate4 = Tween<double>(begin: 0.0, end: 180.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Universal(
            size: Size.square(widget.size),
            child: Transform.rotate(
                angle: -45.0 * 0.0174533,
                child: Stack(children: <Widget>[
                  _cube(1, animation: _rotate2),
                  _cube(2, animation: _rotate3),
                  _cube(3, animation: _rotate4),
                  _cube(4, animation: _rotate1),
                ]))));
  }

  Widget _cube(int i, {required Animation<double> animation}) {
    final double size = widget.size * 0.5, position = widget.size * .5;
    final Matrix4 tRotate = Matrix4.identity()
      ..rotateY(animation.value * 0.0174533);
    return Positioned.fill(
      top: position,
      left: position,
      child: Transform(
          transform: Matrix4.rotationZ(90.0 * (i - 1) * 0.0174533),
          child: Align(
              alignment: Alignment.center,
              child: Transform(
                  transform: tRotate,
                  alignment: Alignment.centerLeft,
                  child: Opacity(
                      opacity: 1.0 - (animation.value / 180.0),
                      child: SizedBox.fromSize(
                        size: Size.square(size),
                        child: _itemBuilder(i - 1),
                      ))))),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(decoration: BoxDecoration(color: widget.color));
}
