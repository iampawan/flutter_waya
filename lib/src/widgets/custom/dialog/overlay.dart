import 'package:flutter/cupertino.dart';import 'package:flutter/material.dart';import 'package:flutter_waya/flutter_waya.dart';import 'package:flutter_waya/src/constant/widgets.dart';class OverlayEntryMap {  ///叠层  final OverlayEntry overlayEntry;  ///是否自动关闭  final bool isAutomaticOff;  OverlayEntryMap({this.overlayEntry, this.isAutomaticOff});}List<OverlayEntryMap> overlayEntryList = [];OverlayState _overlayState;class OverlayBase extends StatelessWidget {  final Widget child;  final TextDirection textDirection;  OverlayBase({Key key, this.child, TextDirection textDirection})      : this.textDirection = textDirection ?? TextDirection.ltr,        super(key: key);  @override  Widget build(BuildContext context) {    var initialEntries = [      OverlayEntry(builder: (ctx) {        _overlayState = Overlay.of(ctx);        return child;      })    ];    return Directionality(      textDirection: textDirection,      child: Overlay(initialEntries: initialEntries),    );  }}///自定义叠层OverlayEntryMap showOverlay(Widget widget, {bool isAutomaticOff}) {  if (_overlayState == null) return null;  OverlayEntry entry = OverlayEntry(builder: (context) => widget);  _overlayState.insert(entry);  var entryMap = OverlayEntryMap(overlayEntry: entry, isAutomaticOff: isAutomaticOff ?? false);  overlayEntryList.add(entryMap);  return entryMap;}///关闭最顶层的叠层void closeOverlay({OverlayEntryMap element}) {  try {    if (element != null) {      element.overlayEntry.remove();      if (overlayEntryList.contains(element)) overlayEntryList.remove(element);    } else {      if (overlayEntryList.length > 0) {        overlayEntryList.last.overlayEntry.remove();        overlayEntryList.remove(overlayEntryList.last);      }    }  } catch (e) {    log(e);  }}///关闭所有void closeAllOverlay() {  overlayEntryList.forEach((element) => element.overlayEntry.remove());  overlayEntryList = [];}///loading 加载框///关闭 closeOverlay();OverlayEntryMap showLoading({  String text,  double value,  bool gaussian,  Color backgroundColor,  Animation<Color> valueColor,  double strokeWidth,  String semanticsLabel,  String semanticsValue,  LoadingType loadingType,  TextStyle textStyle,}) {  var loading = Loading(    gaussian: gaussian,    text: text,    value: value,    backgroundColor: backgroundColor,    valueColor: valueColor,    strokeWidth: strokeWidth ?? 4.0,    semanticsLabel: semanticsLabel,    semanticsValue: semanticsValue,    loadingType: loadingType ?? LoadingType.circular,    textStyle: textStyle,  );  return showOverlay(loading);}///ToastDuration _duration = Duration(milliseconds: 1500);///设置全局弹窗时间void setToastDuration(Duration duration) {  _duration = duration;}///Toast///关闭 closeOverlay();void showToast(String message,    {Color backgroundColor,    BoxDecoration boxDecoration,    GestureTapCallback onTap,    TextStyle textStyle,    Duration closeDuration}) {  var entry = showOverlay(      PopupBase(          child: Container(        margin: EdgeInsets.symmetric(horizontal: ScreenFit.getWidth(0) / 5, vertical: ScreenFit.getHeight(0) / 4),        decoration: boxDecoration ?? BoxDecoration(color: getColors(black90), borderRadius: BorderRadius.circular(5)),        padding: EdgeInsets.all(ScreenFit.getWidth(10)),        child: Widgets.textDefault(message, color: getColors(white), maxLines: 4),      )),      isAutomaticOff: true);  Tools.timerTools(closeDuration ?? _duration, () => closeOverlay(element: entry));}