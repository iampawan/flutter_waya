import 'dart:async';import 'dart:io';import 'dart:ui';import 'package:flutter/material.dart';import 'package:flutter_waya/flutter_waya.dart';import 'package:flutter_waya/src/constant/way.dart';typedef ValueCallback<int> = void Function(int titleIndex, int valueIndex);class DropdownMenu extends StatefulWidget {  const DropdownMenu({    Key key,    Color itemBackground,    Color titleBackground,    @required this.title,    @required this.value,    this.titleTap,    this.valueTap,    this.titleStyle,    this.valueStyle,    this.width,    this.alertMargin,    this.iconColor,    this.itemPadding,    this.decoration,    this.itemDecoration,    this.background,  })  : itemBackground = itemBackground ?? Colors.white,        titleBackground = titleBackground ?? Colors.white,        super(key: key);  ///头部数组  final List<String> title;  ///每个头部弹出菜单数组， 必须和title长度一样  final List<List<String>> value;  ///点击头部item回调  final ValueChanged<int> titleTap;  ///点击菜单的回调  final ValueCallback<int> valueTap;  final Color iconColor;  final Color itemBackground;  final Color background;  final Color titleBackground;  final TextStyle titleStyle;  final TextStyle valueStyle;  final double width;  final EdgeInsetsGeometry alertMargin;  final EdgeInsetsGeometry itemPadding;  final Decoration decoration;  final Decoration itemDecoration;  @override  _DropdownMenuState createState() => _DropdownMenuState();}class _DropdownMenuState extends State<DropdownMenu> {  List<String> title = <String>[];  List<List<String>> value = <List<String>>[];  List<bool> titleState = <bool>[];  GlobalKey titleKey = GlobalKey();  void changeState(int index) => setState(() {        titleState[index] = !titleState[index];      });  void popupWidget(int index) {    final RenderBox title = titleKey.currentContext.findRenderObject() as RenderBox;    final Offset local = title.localToGlobal(Offset.zero);    final double titleHeight = context.size.height;    final ListBuilder listBuilder = ListBuilder(        itemCount: value[index].length,        itemBuilder: (_, int i) => SimpleButton(              text: value[index][i],              width: double.infinity,              textStyle: widget.valueStyle ?? WayStyles.textStyleBlack70(),              onTap: () {                if (widget.valueTap != null) widget.valueTap(index, i);                changeState(index);              },              alignment: Alignment.center,              decoration: widget.itemDecoration ??                  BoxDecoration(color: widget.itemBackground, border: Border(top: BorderSide(color: getColors(line)))),              padding: widget.itemPadding,              height: titleHeight,            ));    final Widget popup = PopupBase(      top: local.dy + titleHeight,      onTap: () {        changeState(index);        pop();      },      child: Universal(          width: widget.width ?? double.infinity,          margin: widget.alertMargin,          height: double.infinity,          color: widget.background ?? getColors(black70).withOpacity(0.2),          child: listBuilder),    );    showDialogPopup<dynamic>(widget: popup);  }  @override  Widget build(BuildContext context) {    title = widget.title;    value = widget.value;    if (title.isEmpty) return Container();    if (title.length != value.length) return Container();    return Universal(        key: titleKey,        width: widget.width,        padding: const EdgeInsets.symmetric(vertical: 10),        mainAxisAlignment: MainAxisAlignment.spaceAround,        direction: Axis.horizontal,        color: widget.titleBackground ?? getColors(white),        decoration: widget.decoration,        children: titleChildren());  }  List<Widget> titleChildren() {    if (title == null || title.isEmpty) return <Widget>[];    // ignore: always_specify_types    return List.generate(title.length, (int index) {      titleState.add(false);      return IconBox(          onTap: () => onTap(index),          titleStyle: widget.titleStyle,          titleText: title[index],          reversal: true,          color: widget.iconColor ?? getColors(black70),          size: 20,          icon: titleState[index] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down);    });  }  void onTap(int index) {    if (widget.titleTap != null) widget.titleTap(index);    final double keyboardHeight = getViewInsets().bottom;    if (keyboardHeight > 0) {      Tools.closeKeyboard(context);      Timer timer;      timer = Timer(const Duration(milliseconds: 300), () {        changeState(index);        popupWidget(index);        if (timer != null) timer.cancel();      });    } else {      changeState(index);      popupWidget(index);    }  }}class PopupSureCancel extends StatelessWidget {  PopupSureCancel({    Key key,    String cancelText,    String sureText,    Color backgroundColor,    Color backsideColor,    TextStyle cancelTextStyle,    TextStyle sureTextStyle,    this.width,    this.height,    this.children,    this.sureTap,    this.padding,    this.margin,    this.cancelTap,    this.sure,    this.cancel,    this.backsideTap,    this.alignment,    this.decoration,    this.animatedOpacity,    this.gaussian,    this.addMaterial,    this.popupMode,  })  : cancelText = cancelText ?? 'cancel',        sureText = sureText ?? 'sure',        backgroundColor = backgroundColor ?? getColors(white),        backsideColor = backsideColor ?? getColors(black50),        sureTextStyle = sureTextStyle ?? WayStyles.textStyleBlack30(),        cancelTextStyle = cancelTextStyle ?? WayStyles.textStyleBlack30(),        super(key: key);  final List<Widget> children;  final GestureTapCallback sureTap;  final GestureTapCallback cancelTap;  final String cancelText;  final String sureText;  final Color backgroundColor;  final Color backsideColor;  final TextStyle cancelTextStyle;  final TextStyle sureTextStyle;  final EdgeInsetsGeometry padding;  final EdgeInsetsGeometry margin;  final Widget sure;  final Widget cancel;  final GestureTapCallback backsideTap;  final double width;  final double height;  final Decoration decoration;  final AlignmentGeometry alignment;  final bool animatedOpacity;  final bool gaussian;  final bool addMaterial;  final PopupMode popupMode;  @override  Widget build(BuildContext context) {    final List<Widget> widgets = <Widget>[];    widgets.addAll(children);    widgets.add(sureCancel());    return PopupBase(        popupMode: popupMode,        addMaterial: addMaterial,        gaussian: gaussian,        onTap: backsideTap,        color: backsideColor,        alignment: alignment,        child: Universal(          onTap: () {},          width: width,          height: height,          decoration: decoration ?? BoxDecoration(color: backgroundColor),          padding: padding,          margin: margin,          mainAxisSize: MainAxisSize.min,          children: widgets,        ));  }  Widget sureCancel() => Universal(direction: Axis.horizontal, mainAxisSize: MainAxisSize.min, children: <Widget>[        SimpleButton(            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),            onTap: cancelTap,            child: cancel,            text: cancelText,            textStyle: cancelTextStyle),        SimpleButton(            onTap: sureTap,            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),            text: sureText,            child: sure,            textStyle: sureTextStyle),      ]);}class Loading extends Dialog {  Loading({    Key key,    LoadingType loadingType,    TextStyle textStyle,    double strokeWidth,    String text,    Color backgroundColor,    this.custom,    this.ignoring,    this.gaussian,    this.animatedOpacity,    this.value,    this.valueColor,    this.semanticsLabel,    this.semanticsValue,  })  : text = text ?? '加载中...',        textStyle = textStyle ?? WayStyles.textStyleBlack70(),        strokeWidth = strokeWidth ?? 4.0,        color = backgroundColor ?? getColors(white),        loadingType = loadingType ?? LoadingType.circular,        super(key: key);  final double value;  final Animation<Color> valueColor;  final String semanticsLabel;  final String semanticsValue;  final LoadingType loadingType;  final TextStyle textStyle;  final double strokeWidth;  final String text;  final Widget custom;  final Color color;  ///是否开始背景模糊  final bool gaussian;  final bool animatedOpacity;  ///是否可以操作背景  final bool ignoring;  @override  Widget build(BuildContext context) {    final List<Widget> children = <Widget>[];    switch (loadingType) {      case LoadingType.circular:        children.add(CircularProgressIndicator(            value: value,            backgroundColor: color,            valueColor: valueColor,            strokeWidth: strokeWidth,            semanticsLabel: semanticsLabel,            semanticsValue: semanticsValue));        break;      case LoadingType.linear:        children.add(LinearProgressIndicator(            value: value,            backgroundColor: color,            valueColor: valueColor,            semanticsLabel: semanticsLabel,            semanticsValue: semanticsValue));        break;      case LoadingType.refresh:        children.add(RefreshProgressIndicator(            value: value,            backgroundColor: color,            valueColor: valueColor,            strokeWidth: strokeWidth,            semanticsLabel: semanticsLabel,            semanticsValue: semanticsValue));        break;    }    children.add(Container(margin: const EdgeInsets.only(top: 16), child: Text(text, style: textStyle)));    return PopupBase(        ignoring: ignoring,        gaussian: gaussian,        alignment: Alignment.center,        onTap: () {},        child: custom ??            Universal(                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8.0)),                mainAxisAlignment: MainAxisAlignment.spaceBetween,                crossAxisAlignment: CrossAxisAlignment.center,                mainAxisSize: MainAxisSize.min,                children: children));  }}