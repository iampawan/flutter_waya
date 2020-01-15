import 'package:flutter/material.dart';import 'package:flutter_waya/flutter_waya.dart';import 'package:flutter_waya/src/constant/WayColor.dart';import 'package:flutter_waya/src/custom/OverlayBase.dart';showToast(message, {Duration closeDuration}) {  AlertUtils.showToast(message.toString(), closeDuration: closeDuration);}showToastWidget(Widget widget, {Duration closeDuration}) {  AlertUtils.showToastWidget(widget, closeDuration: closeDuration);}class AlertUtils {  static BuildContext context = baseContext?.values?.first ?? null;  static showToast(String message, {Duration closeDuration}) {    AlertUtils.showToastWidget(AlertBase(        onTap: () {},        child: Container(          alignment: Alignment.center,          child: Container(            decoration: BoxDecoration(                color: getColors(black70), borderRadius: BorderRadius.circular(5)),            padding: EdgeInsets.all(BaseUtils.getWidth(10)),            child: Text(              message,              style: TextStyle(color: getColors(white), fontSize: 16),            ),          ),)), closeDuration: closeDuration);  }  static showToastWidget(Widget widget, {Duration closeDuration}) {    if (context == null) return;    OverlayEntry entry = OverlayEntry(builder: (context) => widget);    Overlay.of(context).insert(entry);    if (closeDuration == null) {      Future.delayed(closeDuration ?? Duration(seconds: 2)).then((value) {        entry.remove();      });    }  }  /// 自行定义弹窗及关闭  static OverlayEntry alertBaseWidget(Widget widget) {    if (context == null) return null;    return alertWidget(AlertBase(onTap: () {}, child: widget,));  }  /// 自行定义弹窗及关闭  static OverlayEntry alertWidget(Widget widget) {    if (context == null) return null;    OverlayEntry entry = OverlayEntry(builder: (context) => widget);    Overlay.of(context).insert(entry);    return entry;  }  static OverlayEntry alertSureCancel(Widget widget, {    GestureTapCallback sureOnTap,    GestureTapCallback cancelOnTap,    String cancelText,    String sureText,    Widget sure,    Widget cancel,    Color backgroundColor,    TextStyle cancelTextStyle,    TextStyle sureTextStyle,    bool onTapBackClose: true,    EdgeInsetsGeometry padding,  }) {    OverlayEntry entry;    entry = alertWidget(        AlertSureCancel(          backsideTap: () {            if (onTapBackClose && entry != null) entry.remove();          },          showWidget: widget,          sureOnTap: sureOnTap ?? () {            if (entry != null) entry.remove();          },          cancelOnTap: cancelOnTap ?? () {            if (entry != null) entry.remove();          },          cancelText: cancelText ?? 'cancle',          sureText: sureText ?? 'sure',          cancelTextStyle: cancelTextStyle ?? TextStyle(color: getColors(black)),          sureTextStyle: sureTextStyle ?? TextStyle(color: getColors(black)),          sure: sure,          cancel: cancel,          backgroundColor: backgroundColor ?? getColors(white),          padding: padding,        ));    return entry;  }  static OverlayEntry showLoading({    String text,    double value,    Color backgroundColor,    Animation<Color> valueColor,    double strokeWidth,    String semanticsLabel,    String semanticsValue,    LoadingType loadingType,    TextStyle textStyle,  }) {    return alertWidget(Loading(      text: text ?? '加载中...',      value: value,      backgroundColor: backgroundColor,      valueColor: valueColor,      strokeWidth: strokeWidth ?? 4.0,      semanticsLabel: semanticsLabel,      semanticsValue: semanticsValue,      loadingType: loadingType ?? LoadingType.Circular,      textStyle: textStyle,    ));  }}