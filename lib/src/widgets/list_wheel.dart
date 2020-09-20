import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ListWheel extends StatefulWidget {
  /// 每个Item的高度,固定的
  final double itemExtent;

  /// 条目构造器
  final IndexedWidgetBuilder itemBuilder;

  /// 条目数量
  final int itemCount;

  /// 半径大小,越大则越平面,越小则间距越大
  final double diameterRatio;

  /// 选中item偏移
  final double offAxisFraction;

  ///表示车轮水平偏离中心的程度  范围[0,0.01]
  final double perspective;

  /// 初始选中的Item
  final int initialIndex;

  /// 回调监听
  final ValueChanged<int> onChanged;

  /// ///放大倍率
  final double magnification;

  ///是否启用放大镜
  final bool useMagnifier;

  ///1或者2
  final double squeeze;

  ///
  final ScrollPhysics physics;

  final ListWheelChildDelegateType childDelegateType;
  final FixedExtentScrollController controller;
  final List<Widget> children;

  ListWheel({
    Key key,
    double itemExtent,
    double diameterRatio,
    double offAxisFraction,
    double perspective,
    int initialIndex,
    double magnification,
    bool useMagnifier,
    double squeeze,
    ScrollPhysics physics,
    this.itemBuilder,
    this.itemCount,
    this.childDelegateType,
    this.controller,
    this.onChanged,
    this.children,
  })  : this.diameterRatio = diameterRatio ?? 1,
        this.offAxisFraction = offAxisFraction ?? 0,
        this.initialIndex = initialIndex ?? 0,
        this.perspective = perspective ?? 0.01,
        this.magnification = magnification ?? 1.5,
        this.useMagnifier = useMagnifier ?? true,
        this.squeeze = squeeze ?? 1,
        this.itemExtent = itemExtent ?? ScreenFit.getHeight(12),
        this.physics = physics ?? FixedExtentScrollPhysics(),
        super(key: key) {
    if ((childDelegateType == ListWheelChildDelegateType.list ||
        childDelegateType == ListWheelChildDelegateType.looping)) assert(children != null);
    if ((childDelegateType == null || childDelegateType == ListWheelChildDelegateType.builder))
      assert(itemCount != null && itemBuilder != null);
  }

  @override
  _ListWheelState createState() => _ListWheelState();
}

class _ListWheelState extends State<ListWheel> {
  FixedExtentScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? FixedExtentScrollController(initialItem: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    ListWheelChildDelegate childDelegate =
        ListWheelChildBuilderDelegate(builder: widget.itemBuilder, childCount: widget.itemCount);
    if (widget?.childDelegateType == ListWheelChildDelegateType.looping)
      childDelegate = ListWheelChildLoopingListDelegate(children: widget.children);
    if (widget?.childDelegateType == ListWheelChildDelegateType.list)
      childDelegate = ListWheelChildListDelegate(children: widget.children);
    return ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: widget.itemExtent,
        physics: widget.physics,
        diameterRatio: widget.diameterRatio,
        onSelectedItemChanged: (int index) {
          if (widget?.onChanged != null) widget.onChanged(index);
        },
        offAxisFraction: widget.offAxisFraction,
        perspective: widget.perspective,
        useMagnifier: widget.useMagnifier,
        squeeze: widget.squeeze,
        magnification: widget.magnification,
        childDelegate: childDelegate);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AutoScrollEntry extends StatefulWidget {
  final int initialIndex;
  final List<Widget> children;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Duration duration;
  final Duration animateDuration;
  final int maxItemCount;

  /// 回调监听
  final ValueChanged<int> onChanged;

  ///以下为滚轮属性
  ///高度
  final double itemHeight;
  final double itemWidth;

  const AutoScrollEntry(
      {Key key,
      int initialIndex,
      this.itemHeight,
      this.maxItemCount,
      this.itemWidth,
      @required this.children,
      this.onChanged,
      this.margin,
      this.padding,
      this.duration,
      this.animateDuration})
      : this.initialIndex = initialIndex ?? 0,
        super(key: key);

  @override
  _AutoScrollEntryState createState() => _AutoScrollEntryState();
}

class _AutoScrollEntryState extends State<AutoScrollEntry> {
  FixedExtentScrollController controller;
  Timer timer;
  int index = 0;
  int maxItemCount = 10;
  double itemHeight = ScreenFit.getHeight(30);

  @override
  void initState() {
    super.initState();
    if (widget.initialIndex != null && widget.initialIndex < widget.children.length) index = widget.initialIndex;
    if (widget.itemHeight != null) itemHeight = widget.itemHeight;
    controller = FixedExtentScrollController(initialItem: widget.initialIndex);
    if (widget.maxItemCount == null) {
      if (widget.children.length > maxItemCount) maxItemCount = widget.children.length;
    } else {
      maxItemCount = widget.maxItemCount;
    }
    Tools.addPostFrameCallback((duration) {
      timer = Tools.timerPeriodic(widget.duration ?? Duration(seconds: 3), (callback) {
        index += 1;
        if (index >= maxItemCount) {
          index = 0;
          controller.jumpToItem(index);
        }
        controller?.animateToItem(index,
            duration: widget.animateDuration ?? Duration(milliseconds: 500), curve: Curves.linear);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children == null || widget.children.length < 1) return Container();
    return Universal(
        margin: widget.margin,
        padding: widget.padding,
        width: widget.itemWidth,
        height: itemHeight,
        child: ListWheel(
            controller: controller,
            initialIndex: widget.initialIndex,
            itemExtent: itemHeight,
            magnification: 1,
            useMagnifier: false,
            squeeze: 2,
            perspective: 0.00001,
            childDelegateType: ListWheelChildDelegateType.looping,
            children: widget.children,
            physics: NeverScrollableScrollPhysics(),
            onChanged: widget.onChanged ?? (int index) {}));
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }
}