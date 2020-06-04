import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';

class CustomFlex extends StatelessWidget {
  final bool inkWell;
  final GestureTapCallback onTap;
  final GestureTapCallback onDoubleTap;
  final GestureLongPressCallback onLongPress;
  final Color focusColor;
  final Color hoverColor;
  final Color highlightColor;
  final Color splashColor;
  final double radius;
  final BorderRadius borderRadius;
  final ShapeBorder customBorder;
  final FocusNode focusNode;

  ///横竖 布局 List<Widget>   children
  final List<Widget> children;
  final MainAxisSize mainAxisSize;
  final TextDirection textDirection;
  final TextBaseline textBaseline;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Axis direction;

  ///布局横竖
  final VerticalDirection verticalDirection;

  ///容器 布局
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double height;
  final double width;
  final Color color;
  final AlignmentGeometry alignment;
  final Decoration decoration;
  final BoxConstraints constraints;
  final Matrix4 transform;
  final bool enabled;
  final bool isScroll;
  final ScrollPhysics physics;

  ///hero 动画标记
  final String heroTag;

  ///  HitTestBehavior.opaque 自己处理事件 
  ///  HitTestBehavior.deferToChild child处理事件
  ///  HitTestBehavior.translucent 自己和child都可以接收事件
  final HitTestBehavior behavior;

  CustomFlex({
    Key key,
    bool enabled,
    HitTestBehavior behavior,
    MainAxisAlignment mainAxisAlignment,
    CrossAxisAlignment crossAxisAlignment,
    VerticalDirection verticalDirection,
    Axis direction,
    bool inkWell,
    bool isScroll,
    MainAxisSize mainAxisSize,
    GestureTapCallback onTap,
    GestureTapCallback onDoubleTap,
    GestureLongPressCallback onLongPress,
    this.children,
    this.textDirection,
    this.textBaseline,
    this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.alignment,
    this.decoration,
    this.constraints,
    this.transform,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.radius,
    this.borderRadius,
    this.customBorder,
    this.focusNode, this.heroTag, this.physics,
  })
      : this.enabled = enabled ?? true,
        this.isScroll = isScroll ?? false,
        this.mainAxisSize = mainAxisSize ?? MainAxisSize.max,
        this.mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.start,
        this.crossAxisAlignment = crossAxisAlignment ??
            CrossAxisAlignment.center,
        this.verticalDirection = verticalDirection ?? VerticalDirection.down,
        this.direction = direction ?? Axis.vertical,
        this.inkWell = inkWell ?? false,
        this.onTap = (enabled == null ? true : enabled) ? onTap : null,
        this.onLongPress = (enabled == null ? true : enabled)
            ? onLongPress
            : null,
        this.onDoubleTap = (enabled == null ? true : enabled)
            ? onDoubleTap
            : null,
        this.behavior = behavior ?? HitTestBehavior.opaque,
        super(key: key);


  @override
  Widget build(BuildContext context) {
    Widget child = childBody();
    if (onTap != null || onLongPress != null) {
      child = inkWell ? inkWellWidget(child) : gestureDetector(child);
    }
    if (heroTag != null) {
      child = Hero(tag: heroTag, child: child);
    }
    return child;
  }

  Widget gestureDetector(Widget child) {
    return GestureDetector(
      behavior: behavior,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: child,
    );
  }

  Widget inkWellWidget(Widget child) {
    return Material(
        color: getColors(transparent),
        child: Ink(
            child: InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              onDoubleTap: onDoubleTap,
              child: child,
              focusNode: focusNode,
              focusColor: focusColor,
              hoverColor: hoverColor,
              highlightColor: highlightColor,
              splashColor: splashColor,
              radius: radius,
              borderRadius: borderRadius,
              customBorder: customBorder,
            )));
  }

  Widget childBody() {
    if (children != null && children.length > 0) {
      return padding != null ||
          margin != null ||
          height != null ||
          width != null ||
          color != null ||
          decoration != null
          ? containerWidget(singleChildScrollView())
          : singleChildScrollView();
    } else {
      return containerWidget(child);
    }
  }

  Widget containerWidget(Widget child) {
    return Container(
        transform: transform,
        constraints: constraints,
        alignment: alignment,
        color: color,
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: decoration,
        child: child);
  }

  Widget singleChildScrollView() {
    return isScroll
        ? SingleChildScrollView(
      physics: physics,
      scrollDirection: direction,
      child: flex(),
    ) : flex();
  }

  Widget flex() {
    return Flex(
      children: children,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      direction: direction,
      textBaseline: textBaseline,
      verticalDirection: verticalDirection,
      textDirection: textDirection,
      mainAxisSize: mainAxisSize,
    );
  }
}
