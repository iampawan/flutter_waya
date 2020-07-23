import 'package:flutter/material.dart';import 'package:flutter_waya/flutter_waya.dart';class HintDot extends StatelessWidget {  final Widget child;  final Widget pointChild;  final double width;  final double height;  final GestureTapCallback onTap;  final EdgeInsetsGeometry margin;  final EdgeInsetsGeometry pointPadding;  final Color pointColor;  final double pointSize;  final bool hide;  final double top;  final double right;  final double bottom;  final double left;  final AlignmentGeometry alignment;  const HintDot(      {Key key,      @required this.child,      this.pointPadding,      this.width,      this.height,      this.onTap,      this.margin,      this.pointColor,      this.top,      this.right,      this.bottom,      this.left,      this.pointSize,      bool hide,      this.pointChild,      this.alignment})      : this.hide = hide ?? false,        super(key: key);  @override  Widget build(BuildContext context) {    if (hide) return child;    List<Widget> children = [];    if (child != null) children.add(child);    Widget dot = dotWidget();    if (alignment != null) dot = Align(alignment: alignment, child: dot);    if (right != null || top != null || bottom != null || left != null)      dot = Positioned(          right: right, top: top, bottom: bottom, left: left, child: dot);    if (dot != null) children.add(dot);    return Universal(      onTap: onTap,      margin: margin,      width: width,      height: height,      isStack: true,      children: children,    );  }  Widget dotWidget() {    return Container(      child: pointChild,      padding: pointPadding,      width: pointChild == null ? (pointSize ?? ScreenFit.getWidth(4)) : null,      height: pointChild == null ? (pointSize ?? ScreenFit.getWidth(4)) : null,      decoration: BoxDecoration(          color: pointColor ?? getColors(red), shape: BoxShape.circle),    );  }}