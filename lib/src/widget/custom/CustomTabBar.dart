import 'package:flutter/material.dart';import 'package:flutter_waya/flutter_waya.dart';import 'package:flutter_waya/src/constant/WayColor.dart';import 'package:flutter_waya/src/constant/WayStyles.dart';class CustomTabBar extends StatelessWidget {  final TabController controller;  final EdgeInsetsGeometry labelPadding;  final List<Widget> tabBar;  final EdgeInsetsGeometry margin;  final EdgeInsetsGeometry padding;  final double height;  final double width;  final Decoration decoration;  final EdgeInsetsGeometry indicatorPadding;  ///true 最小宽度，false充满最大宽度  final bool isScrollable;  final Color underlineBackgroundColor;  ///tabBar 位置  final TabBarLevelPosition levelPosition;  final TabBarIndicatorSize indicatorSize;  ///选中与未选中的指示器和字体样式和颜色，  final Color labelColor;  final Color unselectedLabelColor;  final TextStyle labelStyle;  final TextStyle unselectedLabelStyle;  ///指示器高度  final double indicatorWeight;  ///tabBar 水平左边或者右边的Widget  final Widget tabBarLevel;  final Decoration indicator; //tabBar 指示器  final double underlineHeight;  final AlignmentGeometry alignment;  const CustomTabBar({    Key key,    this.underlineBackgroundColor,    EdgeInsetsGeometry indicatorPadding,    TabBarLevelPosition levelPosition,    @required this.controller,    this.labelPadding,    @required this.tabBar,    this.isScrollable,    this.alignment,    this.tabBarLevel,    this.labelColor,    this.unselectedLabelColor,    this.indicatorSize,    this.labelStyle,    this.unselectedLabelStyle,    this.indicatorWeight,    this.indicator,    this.underlineHeight,    this.margin,    this.padding,    this.height,    this.decoration,    this.width,  })  : this.levelPosition = levelPosition ?? TabBarLevelPosition.right,        this.indicatorPadding = indicatorPadding ?? EdgeInsets.zero,        super(key: key);  @override  Widget build(BuildContext context) {    List<Widget> children;    if (tabBarLevel != null) {      children = [];      switch (levelPosition) {        case TabBarLevelPosition.right:          children.add(Expanded(child: tabBarWidget()));          children.add(tabBarLevel);          break;        case TabBarLevelPosition.left:          children.add(tabBarLevel);          children.add(Expanded(child: tabBarWidget()));          break;      }    }    return Universal(        height: height,        margin: margin,        padding: padding,        width: width,        alignment: alignment,        direction: Axis.horizontal,        decoration: decoration ??            BoxDecoration(                border: Border(                    bottom: BorderSide(                        width: underlineHeight ?? 0,                        color: underlineBackgroundColor ??                            getColors(transparent)))),        children: children,        child: tabBarLevel == null ? tabBarWidget() : null);  }  Widget tabBarWidget() {    return TabBar(      controller: controller,      labelPadding: labelPadding,      tabs: tabBar,      isScrollable: isScrollable ?? true,      indicator: indicator,      labelColor: labelColor ?? getColors(blue),      unselectedLabelColor: unselectedLabelColor ?? getColors(background),      indicatorColor: labelColor ?? getColors(blue),      indicatorWeight: indicatorWeight ?? Tools.getWidth(1),      indicatorPadding: indicatorPadding,      labelStyle: labelStyle ?? WayStyles.textStyleBlack70(fontSize: 13),      unselectedLabelStyle: unselectedLabelStyle,      indicatorSize: indicatorSize ?? TabBarIndicatorSize.label,    );  }}