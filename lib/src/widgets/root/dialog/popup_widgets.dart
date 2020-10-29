import 'dart:async';import 'dart:ui';import 'package:flutter/material.dart';import 'package:flutter_waya/flutter_waya.dart';import 'package:flutter_waya/src/constant/way.dart';typedef ValueCallback<int> = void Function(int titleIndex, int valueIndex);class PopupBase extends StatefulWidget {  const PopupBase(      {Key key,      this.child,      this.onTap,      double fuzzyDegree,      bool gaussian,      bool ignoring,      bool animationOpacity,      this.color,      bool addMaterial,      bool handleTouch,      bool animation,      PopupMode popupMode,      double left,      double top,      double right,      double bottom,      AlignmentGeometry alignment,      this.behavior})      : top = top ?? 0,        left = left ?? 0,        right = right ?? 0,        bottom = bottom ?? 0,        alignment = alignment ?? Alignment.topLeft,        gaussian = gaussian ?? false,        addMaterial = addMaterial ?? false,        handleTouch = handleTouch ?? true,        popupMode = popupMode ?? PopupMode.center,        animation = animation ?? true,        ignoring = ignoring ?? false,        animationOpacity = animationOpacity ?? false,        fuzzyDegree = fuzzyDegree ?? 2,        super(key: key);  final Widget child;  final GestureTapCallback onTap;  final HitTestBehavior behavior;  final Color color;  final bool handleTouch;  final bool addMaterial;  ///是否开启动画  final bool animation;  final bool animationOpacity;  final PopupMode popupMode;  ///是否开始背景模糊  final bool gaussian;  ///模糊程度  final double fuzzyDegree;  final double left;  final double top;  final double right;  final double bottom;  final AlignmentGeometry alignment;  ///是否可以操作背景  final bool ignoring;  @override  _PopupBaseState createState() => _PopupBaseState();}class _PopupBaseState extends State<PopupBase> {  Color backgroundColor = getColors(transparent);  double opacity = 0;  double popupDistance = -getHeight(0);  double fuzzyDegree = 0;  PopupMode popupMode;  bool animation;  @override  void initState() {    super.initState();    animation = widget.animation;    if (animation) {      popupMode = widget.popupMode;      switch (popupMode) {        case PopupMode.left:          popupDistance = -getWidth(0);          break;        case PopupMode.top:          popupDistance = -getHeight(0);          //头部弹出          break;        case PopupMode.right:          popupDistance = -getWidth(0);          //右边弹出          break;        case PopupMode.bottom:          popupDistance = -getHeight(0);          //底部弹出          break;        default: //PopupMode.center          popupDistance = 0;          //中间渐变          break;      }    }    WidgetsBinding.instance.addPostFrameCallback((Duration callback) {      if (animation) {        opacity = 1;        popupDistance = 0;        if (widget.gaussian) fuzzyDegree = widget.fuzzyDegree;        setState(() {});      }    });  }  @override  Widget build(BuildContext context) {    Widget child = childWidget();    if (widget.gaussian) child = backdropFilter(child);    if (animation) {      if (popupMode == PopupMode.center) {        if (widget.animationOpacity) child = animationOpacity(child);      } else {        child = animationOpacity(child);      }    }    if (widget.addMaterial)      child = Material(          color: getColors(transparent),          child: MediaQuery(              data: MediaQueryData.fromWindow(window), child: child));    if (!widget.handleTouch)      child = IgnorePointer(ignoring: widget.handleTouch, child: child);    if (widget.ignoring) child = IgnorePointer(child: child);    return child;  }  Widget animationOpacity(Widget child) => AnimatedPositioned(      left: popupMode == PopupMode.left ? popupDistance : 0,      top: popupMode == PopupMode.top ? popupDistance : 0,      right: popupMode == PopupMode.right ? popupDistance : 0,      bottom: popupMode == PopupMode.bottom ? popupDistance : 0,      curve: Curves.easeIn,      duration: const Duration(milliseconds: 200),      child: child);  Widget backdropFilter(Widget child) => BackdropFilter(      filter: ImageFilter.blur(sigmaX: fuzzyDegree, sigmaY: fuzzyDegree),      child: child);  Widget animatedOpacity(Widget child) => AnimatedOpacity(      opacity: opacity,      curve: Curves.slowMiddle,      duration: const Duration(milliseconds: 200),      child: child);  Widget childWidget() => Universal(      color: widget.color,      onTap: widget.onTap,      behavior: widget.behavior,      alignment: widget.alignment,      padding: EdgeInsets.fromLTRB(          widget.left, widget.top, widget.right, widget.bottom),      child: widget.child);}class DropdownMenu extends StatefulWidget {  const DropdownMenu({    Key key,    Color itemBackground,    Color titleBackground,    @required this.title,    @required this.value,    this.titleTap,    this.valueTap,    this.titleStyle,    this.valueStyle,    this.width,    this.alertMargin,    this.iconColor,    this.itemPadding,    this.decoration,    this.itemDecoration,    this.background,  })  : itemBackground = itemBackground ?? Colors.white,        titleBackground = titleBackground ?? Colors.white,        super(key: key);  ///头部数组  final List<String> title;  ///每个头部弹出菜单数组， 必须和title长度一样  final List<List<String>> value;  ///点击头部item回调  final ValueChanged<int> titleTap;  ///点击菜单的回调  final ValueCallback<int> valueTap;  final Color iconColor;  final Color itemBackground;  final Color background;  final Color titleBackground;  final TextStyle titleStyle;  final TextStyle valueStyle;  final double width;  final EdgeInsetsGeometry alertMargin;  final EdgeInsetsGeometry itemPadding;  final Decoration decoration;  final Decoration itemDecoration;  @override  _DropdownMenuState createState() => _DropdownMenuState();}class _DropdownMenuState extends State<DropdownMenu> {  List<String> title = <String>[];  List<List<String>> value = <List<String>>[];  List<bool> titleState = <bool>[];  GlobalKey titleKey = GlobalKey();  void changeState(int index) => setState(() {        titleState[index] = !titleState[index];      });  void popupWidget(int index) {    final RenderBox title =        titleKey.currentContext.findRenderObject() as RenderBox;    final Offset local = title.localToGlobal(Offset.zero);    final double titleHeight = context.size.height;    final ListBuilder listBuilder = ListBuilder(        itemCount: value[index].length,        itemBuilder: (_, int i) => SimpleButton(              text: value[index][i],              width: double.infinity,              textStyle: widget.valueStyle ?? WayStyles.textStyleBlack70(),              onTap: () {                if (widget.valueTap != null) widget.valueTap(index, i);                changeState(index);              },              alignment: Alignment.center,              decoration: widget.itemDecoration ??                  BoxDecoration(                      color: widget.itemBackground,                      border: Border(top: BorderSide(color: getColors(line)))),              padding: widget.itemPadding,              height: titleHeight,            ));    final Widget popup = PopupBase(      top: local.dy + titleHeight,      onTap: () {        changeState(index);        pop();      },      child: Universal(          width: widget.width ?? double.infinity,          margin: widget.alertMargin,          height: double.infinity,          color: widget.background ?? getColors(black70).withOpacity(0.2),          child: listBuilder),    );    showDialogPopup<dynamic>(widget: popup);  }  @override  Widget build(BuildContext context) {    title = widget.title;    value = widget.value;    if (title.isEmpty) return Container();    if (title.length != value.length) return Container();    return Universal(        key: titleKey,        width: widget.width,        padding: const EdgeInsets.symmetric(vertical: 10),        mainAxisAlignment: MainAxisAlignment.spaceAround,        direction: Axis.horizontal,        color: widget.titleBackground ?? getColors(white),        decoration: widget.decoration,        children: titleChildren());  }  List<Widget> titleChildren() {    if (title == null || title.isEmpty) return <Widget>[];    // ignore: always_specify_types    return List.generate(title.length, (int index) {      titleState.add(false);      return IconBox(          onTap: () => onTap(index),          titleStyle: widget.titleStyle,          titleText: title[index],          reversal: true,          color: widget.iconColor ?? getColors(black70),          size: 20,          icon: titleState[index]              ? Icons.keyboard_arrow_up              : Icons.keyboard_arrow_down);    });  }  void onTap(int index) {    if (widget.titleTap != null) widget.titleTap(index);    final double keyboardHeight = getViewInsets.bottom;    if (keyboardHeight > 0) {      Tools.closeKeyboard(context);      Timer timer;      timer = Timer(const Duration(milliseconds: 300), () {        changeState(index);        popupWidget(index);        if (timer != null) timer.cancel();      });    } else {      changeState(index);      popupWidget(index);    }  }}class PopupSureCancel extends StatelessWidget {  PopupSureCancel({    Key key,    String cancelText,    String sureText,    Color backgroundColor,    Color barrierColor,    TextStyle cancelTextStyle,    TextStyle sureTextStyle,    this.width,    this.height,    this.children,    this.sureTap,    this.padding,    this.margin,    this.cancelTap,    this.sure,    this.cancel,    this.backsideTap,    this.alignment,    this.decoration,    this.animatedOpacity,    this.gaussian,    this.addMaterial,    this.popupMode,  })  : cancelText = cancelText ?? 'cancel',        sureText = sureText ?? 'sure',        backgroundColor = backgroundColor ?? getColors(white),        barrierColor = barrierColor ?? getColors(black50),        sureTextStyle = sureTextStyle ?? WayStyles.textStyleBlack30(),        cancelTextStyle = cancelTextStyle ?? WayStyles.textStyleBlack30(),        super(key: key);  final List<Widget> children;  final GestureTapCallback sureTap;  final GestureTapCallback cancelTap;  final String cancelText;  final String sureText;  final Color backgroundColor;  final Color barrierColor;  final TextStyle cancelTextStyle;  final TextStyle sureTextStyle;  final EdgeInsetsGeometry padding;  final EdgeInsetsGeometry margin;  final Widget sure;  final Widget cancel;  final GestureTapCallback backsideTap;  final double width;  final double height;  final Decoration decoration;  final AlignmentGeometry alignment;  final bool animatedOpacity;  final bool gaussian;  final bool addMaterial;  final PopupMode popupMode;  @override  Widget build(BuildContext context) {    final List<Widget> widgets = <Widget>[];    widgets.addAll(children);    widgets.add(sureCancel());    return PopupBase(        popupMode: popupMode,        addMaterial: addMaterial,        gaussian: gaussian,        onTap: backsideTap,        color: barrierColor,        alignment: alignment ?? Alignment.center,        child: Universal(          onTap: () {},          width: width,          height: height,          decoration: decoration ?? BoxDecoration(color: backgroundColor),          padding: padding,          margin: margin ?? const EdgeInsets.symmetric(horizontal: 30),          mainAxisSize: MainAxisSize.min,          children: widgets,        ));  }  Widget sureCancel() => Universal(          direction: Axis.horizontal,          mainAxisAlignment: MainAxisAlignment.spaceAround,          children: <Widget>[            SimpleButton(                padding:                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),                onTap: cancelTap,                child: cancel,                text: cancelText,                textStyle: cancelTextStyle),            SimpleButton(                onTap: sureTap,                padding:                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),                text: sureText,                child: sure,                textStyle: sureTextStyle),          ]);}class Loading extends Dialog {  Loading({    Key key,    LoadingType loadingType,    TextStyle textStyle,    double strokeWidth,    String text,    Color backgroundColor,    this.custom,    this.ignoring,    this.gaussian,    this.animatedOpacity,    this.value,    this.valueColor,    this.semanticsLabel,    this.semanticsValue,  })  : text = text ?? '加载中...',        textStyle = textStyle ?? WayStyles.textStyleBlack70(),        strokeWidth = strokeWidth ?? 4.0,        color = backgroundColor ?? getColors(white),        loadingType = loadingType ?? LoadingType.circular,        super(key: key);  final double value;  final Animation<Color> valueColor;  final String semanticsLabel;  final String semanticsValue;  final LoadingType loadingType;  final TextStyle textStyle;  final double strokeWidth;  final String text;  final Widget custom;  final Color color;  ///是否开始背景模糊  final bool gaussian;  final bool animatedOpacity;  ///是否可以操作背景  final bool ignoring;  @override  Widget build(BuildContext context) {    final List<Widget> children = <Widget>[];    switch (loadingType) {      case LoadingType.circular:        children.add(CircularProgressIndicator(            value: value,            backgroundColor: color,            valueColor: valueColor,            strokeWidth: strokeWidth,            semanticsLabel: semanticsLabel,            semanticsValue: semanticsValue));        break;      case LoadingType.linear:        children.add(LinearProgressIndicator(            value: value,            backgroundColor: color,            valueColor: valueColor,            semanticsLabel: semanticsLabel,            semanticsValue: semanticsValue));        break;      case LoadingType.refresh:        children.add(RefreshProgressIndicator(            value: value,            backgroundColor: color,            valueColor: valueColor,            strokeWidth: strokeWidth,            semanticsLabel: semanticsLabel,            semanticsValue: semanticsValue));        break;    }    children.add(Container(        margin: const EdgeInsets.only(top: 16),        child: Text(text, style: textStyle)));    return PopupBase(        ignoring: ignoring,        gaussian: gaussian,        alignment: Alignment.center,        onTap: () {},        child: custom ??            Universal(                padding:                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),                decoration: BoxDecoration(                    color: color, borderRadius: BorderRadius.circular(8.0)),                mainAxisAlignment: MainAxisAlignment.spaceBetween,                crossAxisAlignment: CrossAxisAlignment.center,                mainAxisSize: MainAxisSize.min,                children: children));  }}