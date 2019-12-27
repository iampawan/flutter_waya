import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/recognizer.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayConstant.dart';
import 'package:flutter_waya/src/utils/WayMediaQueryUtils.dart';
import 'package:flutter_waya/src/utils/WayUtils.dart';

class CustomScaffold extends StatelessWidget {
  final Widget bottomNavigationBar;
  final CustomAppBar appBar;
  final EdgeInsetsGeometry padding;
  final bool isScroll;
  final bool expandedBody;
  final bool paddingStatusBar;
  final Color backgroundColor;
  final Widget body;

  //isScroll  和expandedBody  不可同时使用
  CustomScaffold({
    Key key,
    this.appBar,
    this.bottomNavigationBar,
    this.isScroll: false,
    this.expandedBody: false,
    this.body,
    this.backgroundColor,
    this.paddingStatusBar: false,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? getColors(background),
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: bodyWidget(context),
    );
  }

  Widget bodyWidget(BuildContext context) {
    return Container(
      color: backgroundColor,
      margin: expandedBody
          ? EdgeInsets.only(top: WayUtils.getHeight(10))
          : EdgeInsets.zero,
      padding: paddingStatusBar
          ? EdgeInsets.only(top: WayMediaQueryUtils.getStatusBarHeight())
          : padding,
      width: double.infinity,
      height: double.infinity,
      child: isScroll ? SingleChildScrollView(child: body) : body,
    );
  }
}
