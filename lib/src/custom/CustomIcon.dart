import 'package:flutter/material.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';

import 'CustomFlex.dart';

class CustomIcon extends StatelessWidget {
  //需要什么属性  自行添加
  final String text;
  final bool inkWell;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color background;
  final Color iconColor;
  final double height;
  final double width;
  final Decoration decoration;
  final GestureTapCallback onTap;
  final IconData icon;

  final TextDirection textDirection;
  final String semanticLabel;
  final ImageProvider imageProvider;
  Axis direction;
  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;
  int maxLines;
  bool reversal;
  TextOverflow overflow;
  double spacing;
  double iconSize;
  AlignmentGeometry alignment;

  CustomIcon({
    Key key,
    this.icon,
    this.iconSize,
    this.reversal,
    this.background,
    this.iconColor,
    this.semanticLabel,
    this.textDirection,
    this.text,
    this.inkWell,
    this.textStyle,
    this.onTap,
    this.padding,
    this.margin,
    this.width,
    this.spacing,
    this.height,
    this.decoration,
    this.direction,
    this.alignment,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.maxLines,
    this.overflow,
    this.imageProvider,
  }) : super(key: key) {
    if (maxLines == null) maxLines = 1;
    if (overflow == null) overflow = TextOverflow.ellipsis;
    if (iconSize == null) iconSize = BaseUtils.getWidth(15);
    if (reversal == null) reversal = false;
    if (spacing == null) spacing = 0;
    if (crossAxisAlignment == null) crossAxisAlignment = CrossAxisAlignment.center;
    if (mainAxisAlignment == null) mainAxisAlignment = MainAxisAlignment.center;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listWidget = [];
    if (text != null && icon != null) {
      if (reversal) {
        listWidget.add(textWidget());
        listWidget.add(spacingWidget());
        listWidget.add(iconWidget());
      } else {
        listWidget.add(iconWidget());
        listWidget.add(spacingWidget());
        listWidget.add(textWidget());
      }
    }
    return CustomFlex(
      inkWell: inkWell,
      child: (text != null && icon != null) ? null : iconWidget(),
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: (text != null && icon != null) ? listWidget : null,
      width: width,
      height: height,
      onTap: onTap,
      margin: margin,
      decoration: decoration ?? BoxDecoration(color: background),
      padding: padding,
      alignment: alignment,
    );
  }

  Widget spacingWidget() {
    return Container(
        width: direction == Axis.horizontal ? spacing : 0, height: direction == Axis.vertical ? spacing : 0);
  }

  Widget textWidget() {
    return Text(
      text,
      style: textStyle,
      textAlign: TextAlign.start,
      maxLines: maxLines,
      textDirection: textDirection,
      overflow: overflow,
    );
  }

  Widget iconWidget() {
    return imageProvider == null
        ? Icon(icon,
            color: iconColor,
            size: iconSize,
            textDirection: textDirection,
            semanticLabel: semanticLabel //帮助盲人或者视力有障碍的用户提供语言辅助描述
            )
        : ImageIcon(imageProvider,
            color: iconColor, size: iconSize, semanticLabel: semanticLabel //帮助盲人或者视力有障碍的用户提供语言辅助描述
            );
  }
}
