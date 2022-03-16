import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class AnchorScrollController extends ScrollController {
  List<GlobalKey> _keyList = [];
  GlobalKey? _lastKey;
  GlobalKey? _scrollKey;
  int _lastIndex = 0;
  RenderObject? _ancestor;
  bool _reverse = false;
  Axis _scrollDirection = Axis.vertical;

  void _setConfig(
      int count, GlobalKey scrollKey, bool reverse, Axis scrollDirection) {
    _scrollKey = scrollKey;
    _reverse = reverse;
    _scrollDirection = scrollDirection;
    _keyList = count.generate((index) => GlobalKey());
  }

  /// 跳转至指定 index
  Future<void> jumpToIndex(int index,
      {Duration duration = const Duration(milliseconds: 10)}) async {
    if (_keyList.length >= index) {
      _ancestor ??= _scrollKey!.currentContext!.findRenderObject();
      final targetKey = _keyList[index];
      if (targetKey.currentContext == null) {
        if (index < _lastIndex) {
          _lastKey =
              _keyList.where((element) => element.currentContext != null).first;
        } else {
          _lastKey =
              _keyList.where((element) => element.currentContext != null).last;
        }
        _lastIndex = _keyList.indexOf(_lastKey!);
        _jumpTo(_lastKey!.currentContext!);
        await duration.delayed(() => jumpToIndex(index));
      } else {
        _lastIndex = index;
        _lastKey = targetKey;
        _jumpTo(targetKey.currentContext!);
      }
    }
  }

  void _jumpTo(BuildContext context) {
    final rect = context.getWidgetRectLocalToGlobal(ancestor: _ancestor);
    if (rect != null) {
      double dy = offset + _rectToOffset(rect);
      if (dy > position.maxScrollExtent) dy = position.maxScrollExtent;
      if (dy < 0) dy = 0;
      if (dy == offset) return;
      jumpTo(dy);
    }
  }

  /// 跳转至指定 index
  Future<void> animateToIndex(int index,
      {Duration duration = const Duration(milliseconds: 50),
      Curve curve = Curves.linear}) async {
    if (_keyList.length >= index) {
      _ancestor ??= _scrollKey!.currentContext!.findRenderObject();
      final targetKey = _keyList[index];
      if (targetKey.currentContext == null) {
        if (index < _lastIndex) {
          _lastKey =
              _keyList.where((element) => element.currentContext != null).first;
        } else {
          _lastKey =
              _keyList.where((element) => element.currentContext != null).last;
        }
        _lastIndex = _keyList.indexOf(_lastKey!);
        await _animateTo(_lastKey!.currentContext!,
            duration: duration, curve: curve);
        await animateToIndex(index);
      } else {
        _lastIndex = index;
        _lastKey = targetKey;
        await _animateTo(_lastKey!.currentContext!,
            duration: duration, curve: curve);
      }
    }
  }

  Future<void> _animateTo(BuildContext context,
      {required Duration duration, required Curve curve}) async {
    final rect = context.getWidgetRectLocalToGlobal(ancestor: _ancestor);
    if (rect != null) {
      double dy = offset + _rectToOffset(rect);
      if (dy > position.maxScrollExtent) dy = position.maxScrollExtent;
      if (dy < 0) dy = 0;
      if (dy == offset) return;
      await animateTo(dy, duration: duration, curve: curve);
    }
  }

  double _rectToOffset(Rect rect) {
    switch (_scrollDirection) {
      case Axis.horizontal:
        final left = rect.left;
        return _reverse ? -left : left;
      case Axis.vertical:
        final top = rect.top;
        return _reverse ? -top : top;
    }
  }
}

typedef AnchorBuilder = ScrollView Function(
    BuildContext context,

    /// 务必把 [scrollKey] 赋值给 滚动组件[key]
    GlobalKey scrollKey,

    /// 务必把 [scrollController] 回传给 builder 里的滚动组件
    ScrollController scrollController,

    /// 务必把 [reverse] 回传给 builder 里的滚动组件
    bool reverse,

    /// 务必把 [scrollDirection]] 回传给 builder 里的滚动组件
    Axis scrollDirection,

    /// 务必将 entryKey[index] 赋值给 子元素[key]
    List<GlobalKey> entryKey);

/// 滚动至指定index子元素
class AnchorScrollBuilder extends StatefulWidget {
  const AnchorScrollBuilder({
    Key? key,
    required this.controller,
    required this.count,
    required this.builder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.disposeController = true,
  }) : super(key: key);

  /// 必须把 [controller] 回传给 builder 里的滚动组件
  final AnchorScrollController controller;

  /// 必须把 [scrollDirection]] 回传给 builder 里的滚动组件
  final Axis scrollDirection;

  /// 必须把 [reverse] 回传给 builder 里的滚动组件
  final bool reverse;

  /// 子组件数量
  final int count;

  /// 默认为[true] 组件 dispose 时 自动调用 controller.dispose()
  final bool disposeController;

  /// 滚动组件构造器
  final AnchorBuilder builder;

  @override
  State<AnchorScrollBuilder> createState() => _AnchorScrollBuilderState();
}

class _AnchorScrollBuilderState extends State<AnchorScrollBuilder> {
  GlobalKey scrollKey = GlobalKey();
  late AnchorScrollController controller;

  @override
  void initState() {
    controller = widget.controller;
    controller._setConfig(
        widget.count, scrollKey, widget.reverse, widget.scrollDirection);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AnchorScrollBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (controller != widget.controller) {
      controller.dispose();
      controller = widget.controller;
    }
    if (oldWidget.count != widget.count ||
        oldWidget.reverse != widget.reverse ||
        oldWidget.scrollDirection != widget.scrollDirection) {
      controller._setConfig(
          widget.count, scrollKey, widget.reverse, widget.scrollDirection);
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, scrollKey,
      controller, widget.reverse, widget.scrollDirection, controller._keyList);

  @override
  void dispose() {
    super.dispose();
    if (widget.disposeController) controller.dispose();
  }
}
