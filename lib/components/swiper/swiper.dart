import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef FlSwiperOnTap = void Function(int index);

/// Default auto play transition duration
const Duration kDefaultAutoPlayTransitionDuration = Duration(milliseconds: 400);

/// default auto play Duration
const Duration kDefaultAutoPlayDelay = Duration(seconds: 3);

enum FlSwiperLayout { stack, tinder }

class FlSwiper extends StatefulWidget {
  const FlSwiper.builder({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.autoPlay = true,
    this.layout = FlSwiperLayout.stack,
    this.duration = kDefaultAutoPlayDelay,
    this.transitionDuration = kDefaultAutoPlayTransitionDuration,
    this.pagination = const <FlSwiperPlugin>[],
    this.onChanged,
    this.index,
    this.onTap,
    this.loop = true,
    this.curve = Curves.ease,
    this.scrollDirection = Axis.horizontal,
    this.controller,
    required this.itemHeight,
    required this.itemWidth,
  });

  /// Inner item height, this property is valid if layout=stack or layout=tinder,
  final double itemHeight;

  /// Inner item width, this property is valid if layout=stack or layout=tinder,
  final double itemWidth;

  /// Build item on index
  final IndexedWidgetBuilder itemBuilder;

  /// count of the display items
  final int itemCount;

  /// 当用户手动拖拽或者自动播放引起下标改变的时候调用
  final ValueChanged<int>? onChanged;

  /// auto play config
  /// 自动播放开关.
  final bool autoPlay;

  /// Animation duration
  final Duration duration;

  /// play transition duration
  final Duration transitionDuration;

  /// horizontal/vertical
  final Axis scrollDirection;

  /// transition curve
  final Curve curve;

  /// Set to false to disable continuous loop mode.
  /// 无限轮播模式开关
  final bool loop;

  /// Index number of initial slide.
  /// If not set , the `FlSwiper` is 'uncontrolled', which means manage index by itself
  /// If set , the `FlSwiper` is 'controlled', which means the index is fully managed by parent widget.
  /// 初始的时候下标位置
  final int? index;

  /// Called when tap
  /// 当用户点击某个轮播的时候调用
  final FlSwiperOnTap? onTap;

  /// other plugins, you can custom your own plugin
  final List<FlSwiperPlugin> pagination;

  /// 控制器
  final FlSwiperController? controller;

  /// Build in layouts
  final FlSwiperLayout layout;

  @override
  State<StatefulWidget> createState() => _FlSwiperState();
}

abstract class _FlSwiperTimerMixin extends State<FlSwiper> {
  Timer? _timer;

  late FlSwiperController _controller;

  @override
  void initState() {
    _controller = widget.controller ?? FlSwiperController();
    _controller.addListener(_onController);
    _handleAutoPlay();
    super.initState();
  }

  void _onController() {
    switch (_controller.event) {
      case FlSwiperEvent.start:
        if (_timer == null) _startAutoPlay();
        break;
      case FlSwiperEvent.stop:
        if (_timer != null) _stopAutoPlay();
        break;
      case FlSwiperEvent.next:
        break;
      case FlSwiperEvent.previous:
        break;
    }
  }

  void _handleAutoPlay() {
    if (_autoPlayEnabled() && _timer != null) return;
    _stopAutoPlay();
    if (_autoPlayEnabled()) _startAutoPlay();
  }

  @override
  void didUpdateWidget(FlSwiper oldWidget) {
    if (_controller != oldWidget.controller && oldWidget.controller != null) {
      oldWidget.controller!.removeListener(_onController);
      _controller = oldWidget.controller!;
      _controller.addListener(_onController);
    }
    _handleAutoPlay();
    super.didUpdateWidget(oldWidget);
  }

  bool _autoPlayEnabled() => _controller.autoPlay || widget.autoPlay;

  void _startAutoPlay() {
    _timer = widget.duration
        .timerPeriodic((Timer timer) => _controller.next(animation: true));
  }

  void _stopAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _controller.dispose();
    super.dispose();
  }
}

class _FlSwiperState extends _FlSwiperTimerMixin {
  late int _activeIndex;

  @override
  void initState() {
    _activeIndex = widget.index ?? 0;
    super.initState();
  }

  @override
  void didUpdateWidget(FlSwiper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != null && widget.index != _activeIndex) {
      _activeIndex = widget.index!;
    }
  }

  Widget get buildFlSwiper {
    final IndexedWidgetBuilder itemBuilder = widget.onTap == null
        ? widget.itemBuilder
        : (BuildContext context, int index) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => widget.onTap!(index),
            child: widget.itemBuilder(context, index));
    return _SubFlSwiper(
        loop: widget.loop,
        layout: widget.layout,
        itemWidth: widget.itemWidth,
        itemHeight: widget.itemHeight,
        itemCount: widget.itemCount,
        itemBuilder: itemBuilder,
        index: _activeIndex,
        curve: widget.curve,
        duration: widget.transitionDuration,
        onChanged: (int index) {
          _activeIndex = index;
          setState(() {});
          widget.onChanged?.call(index);
        },
        controller: _controller,
        scrollDirection: widget.scrollDirection);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pagination.isEmpty) return buildFlSwiper;
    final List<Widget> children = [buildFlSwiper];
    widget.pagination.builder((FlSwiperPlugin plugin) {
      children.add(plugin.build(
          context,
          FlSwiperPluginConfig(
              itemCount: widget.itemCount,
              activeIndex: _activeIndex,
              scrollDirection: widget.scrollDirection,
              controller: _controller,
              loop: widget.loop)));
    });
    return Stack(children: children);
  }
}

class _SubFlSwiper extends StatefulWidget {
  const _SubFlSwiper(
      {this.loop = false,
      required this.itemHeight,
      required this.itemWidth,
      this.duration = const Duration(seconds: 3),
      this.curve,
      this.itemBuilder,
      this.controller,
      this.index = 0,
      this.itemCount = 0,
      this.scrollDirection = Axis.horizontal,
      this.onChanged,
      this.layout = FlSwiperLayout.tinder});

  final IndexedWidgetBuilder? itemBuilder;
  final int itemCount;
  final int index;
  final ValueChanged<int>? onChanged;
  final FlSwiperController? controller;
  final Duration duration;
  final Curve? curve;
  final double itemWidth;
  final double itemHeight;
  final bool loop;
  final Axis scrollDirection;
  final FlSwiperLayout layout;

  @override
  State<StatefulWidget> createState() =>
      layout == FlSwiperLayout.tinder ? _TinderState() : _StackState();

  int getCorrectIndex(int indexNeedsFix) {
    if (itemCount == 0) return 0;
    int value = indexNeedsFix % itemCount;
    if (value < 0) value += itemCount;
    return value;
  }
}

class _TinderState extends _LayoutState<_SubFlSwiper> {
  late List<double> scales;
  late List<double> offsetsX;
  late List<double> offsetsY;
  late List<double> opacity;
  late List<double> rotates;

  double getOffsetY(double scale) =>
      widget.itemHeight - widget.itemHeight * scale;

  @override
  void didUpdateWidget(_SubFlSwiper oldWidget) {
    _updateValues();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void afterRender() {
    super.afterRender();
    _startIndex = -3;
    _animationCount = 5;
    opacity = <double>[0.0, 0.9, 0.9, 1.0, 0.0, 0.0];
    scales = <double>[0.80, 0.80, 0.85, 0.90, 1.0, 1.0, 1.0];
    rotates = <double>[0.0, 0.0, 0.0, 0.0, 20.0, 25.0];
    _updateValues();
  }

  void _updateValues() {
    if (widget.scrollDirection == Axis.horizontal) {
      offsetsX = <double>[0.0, 0.0, 0.0, 0.0, _swiperWidth, _swiperWidth];
      offsetsY = <double>[0.0, 0.0, -5.0, -10.0, -15.0, -20.0];
    } else {
      offsetsX = <double>[0.0, 0.0, 5.0, 10.0, 15.0, 20.0];
      offsetsY = <double>[0.0, 0.0, 0.0, 0.0, _swiperHeight, _swiperHeight];
    }
  }

  @override
  Widget _buildItem(int i, int realIndex, double animationValue) {
    final double s = _getValue(scales, animationValue, i);
    final double f = _getValue(offsetsX, animationValue, i);
    final double fy = _getValue(offsetsY, animationValue, i);
    final double o = _getValue(opacity, animationValue, i);
    final double a = _getValue(rotates, animationValue, i);
    final Alignment alignment = widget.scrollDirection == Axis.horizontal
        ? Alignment.bottomCenter
        : Alignment.centerLeft;
    return Opacity(
        opacity: o,
        child: Transform.rotate(
            angle: a / 180.0,
            child: Transform.translate(
              key: ValueKey<int>(_currentIndex + i),
              offset: Offset(f, fy),
              child: Transform.scale(
                  scale: s,
                  alignment: alignment,
                  child: SizedBox(
                    width: widget.itemWidth,
                    height: widget.itemHeight,
                    child: widget.itemBuilder == null
                        ? null
                        : widget.itemBuilder!(context, realIndex),
                  )),
            )));
  }
}

double _getValue(List<double> values, double animationValue, int index) {
  double s = values[index];
  if (animationValue >= 0.5 && index < values.length - 1) {
    s = s + (values[index + 1] - s) * (animationValue - 0.5) * 2.0;
  } else if (index != 0) {
    s = s - (s - values[index - 1]) * (0.5 - animationValue) * 2.0;
  }
  return s;
}

class _StackState extends _LayoutState<_SubFlSwiper> {
  late List<double> scales;
  late List<double> offsets;
  late List<double> opacity;

  void _updateValues() {
    if (widget.scrollDirection == Axis.horizontal) {
      final double space = (_swiperWidth - widget.itemWidth) / 2;
      offsets = <double>[-space, -space / 3 * 2, -space / 3, 0.0, _swiperWidth];
    } else {
      final double space = (_swiperHeight - widget.itemHeight) / 2;
      offsets = <double>[
        -space,
        -space / 3 * 2,
        -space / 3,
        0.0,
        _swiperHeight
      ];
    }
  }

  @override
  void didUpdateWidget(_SubFlSwiper oldWidget) {
    _updateValues();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void afterRender() {
    super.afterRender();
    _animationCount = 5;
    _startIndex = -3;
    scales = <double>[0.7, 0.8, 0.9, 1.0, 1.0];
    opacity = <double>[0.0, 0.5, 1.0, 1.0, 1.0];
    _updateValues();
  }

  @override
  Widget _buildItem(int i, int realIndex, double animationValue) {
    final double s = _getValue(scales, animationValue, i);
    final double f = _getValue(offsets, animationValue, i);
    final double o = _getValue(opacity, animationValue, i);
    final Offset offset = widget.scrollDirection == Axis.horizontal
        ? Offset(f, 0.0)
        : Offset(0.0, f);
    final Alignment alignment = widget.scrollDirection == Axis.horizontal
        ? Alignment.centerLeft
        : Alignment.topCenter;
    return Opacity(
        opacity: o,
        child: Transform.translate(
          key: ValueKey<int>(_currentIndex + i),
          offset: offset,
          child: Transform.scale(
              scale: s,
              alignment: alignment,
              child: SizedBox(
                width: widget.itemWidth,
                height: widget.itemHeight,
                child: widget.itemBuilder == null
                    ? null
                    : widget.itemBuilder!(context, realIndex),
              )),
        ));
  }
}

/// _LayoutState
abstract class _LayoutState<T extends _SubFlSwiper> extends State<T>
    with SingleTickerProviderStateMixin {
  late double _swiperWidth;
  late double _swiperHeight;
  late Animation<double> _animation;
  late AnimationController _animationController;
  late int _startIndex;
  int? _animationCount;
  late int _currentIndex = 0;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, value: 0.5);
    final Tween<double> tween = Tween<double>(begin: 0.0, end: 1.0);
    _animation = tween.animate(_animationController);
    widget.controller!.addListener(_onController);
    _startIndex = 0;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    addPostFrameCallback((Duration duration) => afterRender());
    super.didChangeDependencies();
  }

  @mustCallSuper
  void afterRender() {
    final RenderObject renderObject = context.findRenderObject()!;
    final Size size = renderObject.paintBounds.size;
    _swiperWidth = size.width;
    _swiperHeight = size.height;
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(T oldWidget) {
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller!.removeListener(_onController);
      widget.controller!.addListener(_onController);
    }
    if (widget.loop != oldWidget.loop && !widget.loop) {
      _currentIndex = _ensureIndex(_currentIndex);
    }
    super.didUpdateWidget(oldWidget);
  }

  int _ensureIndex(int index) {
    index = index % widget.itemCount;
    if (index < 0) index += widget.itemCount;
    return index;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildItem(int i, int realIndex, double animationValue);

  Widget _buildContainer(List<Widget> list) => Stack(children: list);

  @override
  Widget build(BuildContext context) {
    if (_animationCount == null) return Container();
    return AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? w) {
          final List<Widget> list = <Widget>[];
          final double animationValue = _animation.value;
          for (int i = 0; i < _animationCount!; ++i) {
            int realIndex = _currentIndex + i + _startIndex;
            realIndex = realIndex % widget.itemCount;
            if (realIndex < 0) realIndex += widget.itemCount;
            list.add(_buildItem(i, realIndex, animationValue));
          }
          return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: _onPanStart,
              onPanEnd: _onPanEnd,
              onPanUpdate: _onPanUpdate,
              child: ClipRect(child: Center(child: _buildContainer(list))));
        });
  }

  late double _currentValue;
  late double _currentPos;
  bool _lockScroll = false;

  Future<void> _move(double position, {int? nextIndex}) async {
    if (_lockScroll) return;
    try {
      _lockScroll = true;
      await _animationController.animateTo(position,
          duration: widget.duration, curve: widget.curve!);
      if (nextIndex != null && widget.onChanged != null) {
        widget.onChanged!(widget.getCorrectIndex(nextIndex));
      }
    } catch (e) {
      log(e);
    } finally {
      if (nextIndex != null) {
        try {
          _animationController.value = 0.5;
        } catch (e) {
          log(e);
        }
        _currentIndex = nextIndex;
      }
      _lockScroll = false;
    }
  }

  int _nextIndex() {
    final int index = _currentIndex + 1;
    if (!widget.loop && index >= widget.itemCount - 1) {
      return widget.itemCount - 1;
    }
    return index;
  }

  int _prevIndex() {
    final int index = _currentIndex - 1;
    if (!widget.loop && index < 0) return 0;
    return index;
  }

  void _onController() {
    switch (widget.controller!.event) {
      case FlSwiperEvent.previous:
        final int prevIndex = _prevIndex();
        if (prevIndex == _currentIndex) return;
        _move(1.0, nextIndex: prevIndex);
        break;
      case FlSwiperEvent.next:
        final int nextIndex = _nextIndex();
        if (nextIndex == _currentIndex) return;
        _move(0.0, nextIndex: nextIndex);
        break;
      case FlSwiperEvent.start:
      case FlSwiperEvent.stop:
        break;
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_lockScroll) return;
    final double velocity = widget.scrollDirection == Axis.horizontal
        ? details.velocity.pixelsPerSecond.dx
        : details.velocity.pixelsPerSecond.dy;
    if (_animationController.value >= 0.75 || velocity > 500.0) {
      if (_currentIndex <= 0 && !widget.loop) return;
      _move(1.0, nextIndex: _currentIndex - 1);
    } else if (_animationController.value < 0.25 || velocity < -500.0) {
      if (_currentIndex >= widget.itemCount - 1 && !widget.loop) return;
      _move(0.0, nextIndex: _currentIndex + 1);
    } else {
      _move(0.5);
    }
  }

  void _onPanStart(DragStartDetails details) {
    if (_lockScroll) return;
    _currentValue = _animationController.value;
    _currentPos = widget.scrollDirection == Axis.horizontal
        ? details.globalPosition.dx
        : details.globalPosition.dy;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_lockScroll) return;
    double value = _currentValue +
        ((widget.scrollDirection == Axis.horizontal
                    ? details.globalPosition.dx
                    : details.globalPosition.dy) -
                _currentPos) /
            _swiperWidth /
            2;
    if (!widget.loop) {
      if (_currentIndex >= widget.itemCount - 1) {
        if (value < 0.5) value = 0.5;
      } else if (_currentIndex <= 0) {
        if (value > 0.5) value = 0.5;
      }
    }
    _animationController.value = value;
  }
}
