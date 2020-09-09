import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Universal extends StatelessWidget {

  ///public
  final EdgeInsetsGeometry padding;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;
  final Duration animationDuration;
  final AlignmentGeometry alignment;
  final BorderRadius borderRadius;

  ///****** child ******///
  final Widget child;

  ///****** Flexible ******///
  final bool expanded;
  final int flex;
  final bool isFlexible;
  final FlexFit flexFit;

  ///****** Container ******///
  final Decoration foregroundDecoration;
  final Matrix4 transform;
  final BoxConstraints constraints;
  final Color color;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final Decoration decoration;

  ///****** children ******///
  final List<Widget> children;

  ///****** Card ******///
  final addCard;
  final bool semanticContainer;

  ///****** Flex ******///
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Axis direction;
  final TextBaseline textBaseline;
  final VerticalDirection verticalDirection;
  final TextDirection textDirection;
  final MainAxisSize mainAxisSize;

  ///****** Clip ******///
  final bool isClip;
  final CustomClipper<RRect> clipperRRect;
  final CustomClipper<Rect> clipperRect;
  final CustomClipper<Path> clipperPath;

  ///****** CircleAvatar ******///
  final bool isCircleAvatar;
  final ImageProvider backgroundImage;
  final ImageErrorListener onBackgroundImageError;
  final Color foregroundColor;
  final double minRadius;
  final double maxRadius;

  ///****** SingleChildScrollView ******///
  final bool isScroll;
  final ScrollPhysics physics;
  final ScrollController scrollController;
  final bool reverse;
  final bool primary;

  ///****** Visibility ******///
  final bool sizedBoxExpand;
  final Widget replacement;
  final bool visible;
  final bool maintainState;
  final bool maintainAnimation;
  final bool maintainSize;
  final bool maintainSemantics;
  final bool maintainInteractivity;
  final bool offstage;

  ///****** 点击事件相关 ******///
  final bool addInkWell;
  final bool enabled;

  ///点击
  final GestureTapCallback onTap;

  ///双击
  final GestureTapCallback onDoubleTap;

  ///长按
  final GestureLongPressCallback onLongPress;

  ///按下回调
  final GestureTapDownCallback onTapDown;

  ///点击取消
  final GestureTapCancelCallback onTapCancel;

  final bool excludeFromSemantics;

  ///****** GestureDetector ******///
  ///点击抬起
  final GestureTapUpCallback onTapUp;
  final GestureTapDownCallback onSecondaryTapDown;
  final GestureTapUpCallback onSecondaryTapUp;
  final GestureTapCancelCallback onSecondaryTapCancel;
  final GestureLongPressStartCallback onLongPressStart;
  final GestureLongPressMoveUpdateCallback onLongPressMoveUpdate;
  final GestureLongPressUpCallback onLongPressUp;
  final GestureLongPressEndCallback onLongPressEnd;
  final GestureDragDownCallback onVerticalDragDown;
  final GestureDragStartCallback onVerticalDragStart;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final GestureDragCancelCallback onVerticalDragCancel;
  final GestureDragDownCallback onHorizontalDragDown;
  final GestureDragStartCallback onHorizontalDragStart;
  final GestureDragUpdateCallback onHorizontalDragUpdate;
  final GestureDragEndCallback onHorizontalDragEnd;
  final GestureDragCancelCallback onHorizontalDragCancel;

  ///按下回调
  final GestureDragDownCallback onPanDown;

  ///拖动开始
  final GestureDragStartCallback onPanStart;

  ///拖动更新
  final GestureDragUpdateCallback onPanUpdate;

  ///拖动结束
  final GestureDragEndCallback onPanEnd;

  ///拖动取消
  final GestureDragCancelCallback onPanCancel;
  final GestureScaleStartCallback onScaleStart;
  final GestureScaleUpdateCallback onScaleUpdate;
  final GestureScaleEndCallback onScaleEnd;
  final GestureForcePressStartCallback onForcePressStart;
  final GestureForcePressPeakCallback onForcePressPeak;
  final GestureForcePressUpdateCallback onForcePressUpdate;
  final GestureForcePressEndCallback onForcePressEnd;

  ///HitTestBehavior.opaque 自己处理事件 
  ///HitTestBehavior.deferToChild child处理事件
  ///HitTestBehavior.translucent 自己和child都可以接收事件
  final HitTestBehavior behavior;

  ///****** Material ******///
  final MaterialType type;
  final double elevation;
  final Color shadowColor;
  final TextStyle textStyle;
  final ShapeBorder shape;
  final bool borderOnForeground;

  ///****** InkWell ******///
  ///高亮变化回调
  final ValueChanged<bool> onHighlightChanged;
  final ValueChanged<bool> onHover;
  final Color focusColor;
  final Color hoverColor;

  ///高亮颜色
  final Color highlightColor;

  ///水波纹颜色
  final Color splashColor;
  final InteractiveInkFeatureFactory splashFactory;

  ///水波半径
  final double radius;
  final ShapeBorder customBorder;
  final bool enableFeedback;
  final FocusNode focusNode;
  final bool canRequestFocus;
  final ValueChanged<bool> onFocusChange;
  final bool autoFocus;

  ///****** Hero ******///
  final String heroTag;
  final CreateRectTween createRectTween;
  final HeroFlightShuttleBuilder flightShuttleBuilder;
  final bool transitionOnUserGestures;
  final HeroPlaceholderBuilder placeholderBuilder;

  ///****** Stack ******///
  final bool isStack;
  final StackFit stackFit;
  final Overflow overflow;

  const Universal({
    Key key,
    bool isScroll,
    bool isStack,
    bool enabled,
    bool addInkWell,
    bool reverse,
    bool canRequestFocus,
    bool borderOnForeground,
    bool enableFeedback,
    bool excludeFromSemantics,
    bool autoFocus,
    bool sizedBoxExpand,
    bool visible,
    bool offstage,
    bool maintainState,
    bool maintainAnimation,
    bool maintainSize,
    bool maintainSemantics,
    bool maintainInteractivity,
    bool expanded,
    bool isFlexible,
    bool isCircleAvatar,
    bool isClip,
    bool addCard,
    bool transitionOnUserGestures,
    bool semanticContainer,
    MaterialType type,
    double elevation,
    Clip clipBehavior,
    DragStartBehavior dragStartBehavior,
    Duration animationDuration,
    Color shadowColor,
    Widget replacement,
    StackFit stackFit,
    Overflow overflow,
    MainAxisAlignment mainAxisAlignment,
    CrossAxisAlignment crossAxisAlignment,
    Axis direction,
    VerticalDirection verticalDirection,
    MainAxisSize mainAxisSize,
    HitTestBehavior behavior,
    BorderRadius borderRadius,
    Color color,
    int flex,
    FlexFit flexFit,
    this.child,
    this.children,
    this.padding,
    this.physics,
    this.scrollController,
    this.primary,
    this.foregroundDecoration,
    this.transform,
    this.constraints,
    this.width,
    this.height,
    this.margin,
    this.decoration,
    this.alignment,
    this.textBaseline,
    this.textDirection,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onDoubleTap,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressUp,
    this.onLongPressEnd,
    this.onVerticalDragDown,
    this.onVerticalDragStart,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.onVerticalDragCancel,
    this.onHorizontalDragDown,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onHorizontalDragCancel,
    this.onPanDown,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.onForcePressStart,
    this.onForcePressPeak,
    this.onForcePressUpdate,
    this.onForcePressEnd,
    this.textStyle,
    this.shape,
    this.onHighlightChanged,
    this.onHover,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.splashFactory,
    this.radius,
    this.customBorder,
    this.focusNode,
    this.onFocusChange,
    this.heroTag,
    this.createRectTween,
    this.flightShuttleBuilder,
    this.placeholderBuilder,
    this.backgroundImage,
    this.onBackgroundImageError,
    this.foregroundColor,
    this.minRadius,
    this.maxRadius,
    this.clipperRRect,
    this.clipperRect,
    this.clipperPath,
  })
      : this.isScroll = isScroll ?? false,
        this.addCard = addCard ?? false,
        this.semanticContainer = semanticContainer ?? true,
        this.maintainState = maintainState ?? false,
        this.transitionOnUserGestures = transitionOnUserGestures ?? false,
        this.expanded = expanded ?? false,
        this.isFlexible = isFlexible ?? false,
        this.isStack = isStack ?? false,
        this.isCircleAvatar = isCircleAvatar ?? false,
        this.isClip = isClip ?? false,
        this.maintainAnimation = maintainAnimation ?? false,
        this.maintainSize = maintainSize ?? false,
        this.maintainSemantics = maintainSemantics ?? false,
        this.maintainInteractivity = maintainInteractivity ?? false,
        this.enabled = enabled ?? false,
        this.addInkWell = addInkWell ?? false,
        this.reverse = reverse ?? false,
        this.autoFocus = autoFocus ?? false,
        this.sizedBoxExpand = sizedBoxExpand ?? false,
        this.excludeFromSemantics = excludeFromSemantics ?? false,
        this.borderOnForeground = borderOnForeground ?? true,
        this.enableFeedback = enableFeedback ?? true,
        this.canRequestFocus = canRequestFocus ?? true,
        this.visible = visible ?? true,
        this.offstage = offstage ?? false,
        this.dragStartBehavior = dragStartBehavior ?? DragStartBehavior.start,
        this.type = type ?? MaterialType.canvas,
        this.elevation = elevation ?? 0.0,
        this.flex = flex ?? 1,
        this.clipBehavior = clipBehavior ?? Clip.none,
        this.shadowColor = shadowColor ?? Colors.transparent,
        this.animationDuration = animationDuration ?? kThemeChangeDuration,
        this.replacement = replacement ?? const SizedBox.shrink(),
        this.stackFit = stackFit ?? StackFit.loose,
        this.overflow = overflow ?? Overflow.clip,
        this.mainAxisSize = mainAxisSize ?? MainAxisSize.max,
        this.mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.start,
        this.crossAxisAlignment =
            crossAxisAlignment ?? CrossAxisAlignment.center,
        this.verticalDirection = verticalDirection ?? VerticalDirection.down,
        this.direction = direction ?? Axis.vertical,
        this.behavior = behavior ?? HitTestBehavior.opaque,
        this.borderRadius = borderRadius ?? BorderRadius.zero,
        this.color = color ?? Colors.transparent,
        this.flexFit = flexFit ?? FlexFit.loose,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget = Container();
    if (child != null) widget = child;
    if (children != null && children.length > 0) {
      if (isStack) {
        widget = stackWidget(children: children);
      } else {
        widget = flexWidget(children: children);
      }
    }
    if (isScroll) widget = singleChildScrollViewWidget(widget: widget);
    if (padding != null ||
        margin != null ||
        height != null ||
        width != null ||
        color != null ||
        constraints != null ||
        alignment != null ||
        decoration != null) {
      widget = containerWidget(widget: widget);
    }

    if (enabled || onTap != null) {
      if (addInkWell)
        widget = inkWellWidget(widget: widget);
      else
        widget = gestureDetectorWidget(widget: widget);
    }
    if (sizedBoxExpand) widget = SizedBox.expand(child: widget);
    if (heroTag != null) widget = heroWidget(widget: widget);
    if (addCard) widget = cardWidget(widget: widget);
    if (isCircleAvatar) widget = circleAvatarWidget(widget: widget);
    if (isClip) widget = clipWidget(widget: widget);
    if (!visible) widget = visibilityWidget(widget: widget);
    if (offstage) widget = offstageWidget(widget: widget);
    if (isFlexible || expanded) widget = flexibleWidget(widget: widget);
    return widget;
  }

  Widget offstageWidget({Widget widget}) =>
      Offstage(
          child: widget,
          offstage: offstage
      );


  Widget cardWidget({Widget widget}) =>
      Card(
        child: widget,
        color: color,
        clipBehavior: clipBehavior,
        shadowColor: shadowColor,
        elevation: elevation,
        shape: shape,
        borderOnForeground: borderOnForeground ?? true,
        margin: margin,
        semanticContainer: semanticContainer ?? true,
      );


  Widget clipWidget({Widget widget}) {
    Clip behavior = clipBehavior;
    if (clipBehavior == Clip.none) behavior = null;
    if (clipperRect != null) {
      return ClipRect(
        child: widget,
        clipper: clipperRect,
        clipBehavior: behavior ?? Clip.hardEdge,
      );
    }
    if (clipperPath != null) {
      return ClipPath(
        child: widget,
        clipper: clipperPath,
        clipBehavior: behavior ?? Clip.antiAlias,
      );
    }
    return ClipRRect(
      child: widget,
      borderRadius: borderRadius,
      clipper: clipperRRect,
      clipBehavior: behavior ?? Clip.antiAlias,
    );
  }

  Widget circleAvatarWidget({Widget widget}) =>
      CircleAvatar(
        child: widget,
        backgroundColor: color,
        backgroundImage: backgroundImage,
        onBackgroundImageError: onBackgroundImageError,
        foregroundColor: foregroundColor,
        radius: radius,
        minRadius: minRadius,
        maxRadius: maxRadius,
      );


  Widget stackWidget({List<Widget> children}) =>
      Stack(
        alignment: alignment ?? AlignmentDirectional.topStart,
        textDirection: textDirection,
        fit: stackFit,
        overflow: overflow,
        children: children,
      );


  Widget heroWidget({Widget widget}) =>
      Hero(
          tag: heroTag,
          createRectTween: createRectTween,
          flightShuttleBuilder: flightShuttleBuilder,
          placeholderBuilder: placeholderBuilder,
          transitionOnUserGestures: transitionOnUserGestures,
          child: widget);


  Widget visibilityWidget({Widget widget}) =>
      Visibility(
        child: widget,
        replacement: replacement,
        visible: visible,
        maintainState: maintainState,
        maintainAnimation: maintainAnimation,
        maintainSize: maintainSize,
        maintainSemantics: maintainSemantics,
        maintainInteractivity: maintainInteractivity,
      );


  Widget flexibleWidget({Widget widget}) {
    if (isFlexible) {
      return Flexible(
        child: widget,
        flex: flex,
        fit: flexFit,
      );
    }
    if (expanded) {
      return Flexible(
        child: widget,
        flex: 1,
        fit: FlexFit.tight,
      );
    }
    return widget;
  }

  Widget inkWellWidget({Widget widget}) =>
      Material(
          color: color,
          type: type,
          elevation: elevation,
          shadowColor: shadowColor,
          textStyle: textStyle,
          borderRadius: borderRadius,
          shape: shape,
          borderOnForeground: borderOnForeground,
          clipBehavior: clipBehavior,
          animationDuration: animationDuration,
          child: Ink(
//            padding: padding,
//            color: color,
              decoration: decoration,
//            width: width,
//            height: height,
              child: InkWell(
                child: widget,
                onTap: onTap,
                onLongPress: onLongPress,
                onDoubleTap: onDoubleTap,
                onTapDown: onTapDown,
                onTapCancel: onTapCancel,
                onHighlightChanged: onHighlightChanged,
                onHover: onHover,
                focusColor: focusColor,
                hoverColor: hoverColor,
                highlightColor: highlightColor,
                splashColor: splashColor,
                splashFactory: splashFactory,
                radius: radius,
                borderRadius: borderRadius,
                customBorder: customBorder,
                enableFeedback: enableFeedback,
                excludeFromSemantics: excludeFromSemantics,
                focusNode: focusNode,
                canRequestFocus: canRequestFocus,
                onFocusChange: onFocusChange,
                autofocus: autoFocus,
              )));


  Widget singleChildScrollViewWidget({Widget widget}) =>
      SingleChildScrollView(
          physics: physics,
          reverse: reverse,
//       padding: padding,
          primary: primary,
          dragStartBehavior: dragStartBehavior,
          controller: scrollController,
          scrollDirection: direction,
          child: widget);


  Widget flexWidget({List<Widget> children}) =>
      Flex(
        children: children,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        direction: direction,
        textBaseline: textBaseline,
        verticalDirection: verticalDirection,
        textDirection: textDirection,
        mainAxisSize: mainAxisSize,
      );


  Widget containerWidget({Widget widget}) =>
      Container(
          foregroundDecoration: foregroundDecoration,
          clipBehavior: clipBehavior,
          transform: transform,
          constraints: constraints,
          alignment: alignment,
          color: decoration == null ? color : null,
          width: width,
          height: height,
          padding: padding,
          margin: margin,
          decoration: decoration,
          child: widget);


  Widget gestureDetectorWidget({Widget widget}) =>
      GestureDetector(
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTap: onTap,
        onTapCancel: onTapCancel,
        onSecondaryTapDown: onSecondaryTapDown,
        onSecondaryTapUp: onSecondaryTapUp,
        onSecondaryTapCancel: onSecondaryTapCancel,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        onLongPressStart: onLongPressStart,
        onLongPressMoveUpdate: onLongPressMoveUpdate,
        onLongPressUp: onLongPressUp,
        onLongPressEnd: onLongPressEnd,
        onVerticalDragDown: onVerticalDragDown,
        onVerticalDragStart: onVerticalDragStart,
        onVerticalDragUpdate: onVerticalDragUpdate,
        onVerticalDragEnd: onVerticalDragEnd,
        onVerticalDragCancel: onVerticalDragCancel,
        onHorizontalDragDown: onHorizontalDragDown,
        onHorizontalDragStart: onHorizontalDragStart,
        onHorizontalDragUpdate: onHorizontalDragUpdate,
        onHorizontalDragEnd: onHorizontalDragEnd,
        onHorizontalDragCancel: onHorizontalDragCancel,
        onForcePressStart: onForcePressStart,
        onForcePressPeak: onForcePressPeak,
        onForcePressUpdate: onForcePressUpdate,
        onForcePressEnd: onForcePressEnd,
        onPanDown: onPanDown,
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        onPanCancel: onPanCancel,
        onScaleStart: onScaleStart,
        onScaleUpdate: onScaleUpdate,
        onScaleEnd: onScaleEnd,
        behavior: behavior,
        excludeFromSemantics: excludeFromSemantics,
        dragStartBehavior: dragStartBehavior,
        child: widget,
      );

}

class SimpleButton extends StatelessWidget {
  final child;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;
  final double height;
  final double width;
  final Decoration decoration;
  final GestureTapCallback onTap;
  final AlignmentGeometry alignment;
  final int maxLines;
  final TextOverflow overflow;
  final String text;
  final bool addInkWell;
  final bool visible;
  final String heroTag;
  final BoxConstraints constraints;

  SimpleButton({
    Key key,
    String text,
    bool inkWell,
    this.textStyle,
    this.visible,
    this.constraints,
    this.onTap,
    this.heroTag,
    this.padding,
    this.margin,
    this.width,
    this.color,
    this.height,
    this.decoration,
    this.alignment,
    this.maxLines,
    this.child,
    TextOverflow overflow,
    this.addInkWell,
  })
      : this.text = text ?? 'Button',
        this.overflow = overflow ?? TextOverflow.ellipsis,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget = hero(Text(text,
        textAlign: TextAlign.start,
        style: textStyle,
        maxLines: maxLines,
        overflow: overflow));
    if (child != null) widget = child;
    return Universal(
      visible: visible,
      constraints: constraints,
      addInkWell: addInkWell,
      mainAxisSize: MainAxisSize.min,
      child: widget,
      width: width,
      height: height,
      onTap: onTap,
      margin: margin,
      decoration: decoration ?? BoxDecoration(color: color),
      padding: padding,
      alignment: alignment,
    );
  }

  Widget hero(Widget text) {
    if (heroTag != null) return Hero(tag: heroTag, child: text);
    return text;
  }
}
