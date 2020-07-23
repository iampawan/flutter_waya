import 'package:flutter/material.dart';import 'package:flutter_waya/flutter_waya.dart';import 'package:flutter_waya/src/widget/indicator/IndicatorPainter.dart';class IndicatorState extends State<Indicator> {  int index = 0;  Paint _paint = Paint();  IndicatorPainter _createPainer() {    switch (widget.layout) {      case IndicatorType.none:        return NonePainter(            widget, widget.controller.page ?? 0.0, index, _paint);      case IndicatorType.slide:        return SlidePainter(            widget, widget.controller.page ?? 0.0, index, _paint);      case IndicatorType.warm:        return WarmPainter(            widget, widget.controller.page ?? 0.0, index, _paint);      case IndicatorType.color:        return ColorPainter(            widget, widget.controller.page ?? 0.0, index, _paint);      case IndicatorType.scale:        return ScalePainter(            widget, widget.controller.page ?? 0.0, index, _paint);      case IndicatorType.drop:        return DropPainter(            widget, widget.controller.page ?? 0.0, index, _paint);      default:        throw Exception("Not a valid layout");    }  }  @override  Widget build(BuildContext context) {    Widget child = SizedBox(      width: widget.count * widget.size + (widget.count - 1) * widget.space,      height: widget.size,      child: CustomPaint(        painter: _createPainer(),      ),    );    if (widget.layout == IndicatorType.scale ||        widget.layout == IndicatorType.color) {      child = ClipRect(        child: child,      );    }    return IgnorePointer(      child: child,    );  }  void _onController() {    double page = widget.controller.page ?? 0.0;    index = page.floor();    setState(() {});  }  @override  void initState() {    widget.controller.addListener(_onController);    super.initState();  }  @override  void didUpdateWidget(Indicator oldWidget) {    if (widget.controller != oldWidget.controller) {      oldWidget.controller.removeListener(_onController);      widget.controller.addListener(_onController);    }    super.didUpdateWidget(oldWidget);  }  @override  void dispose() {    widget.controller.removeListener(_onController);    super.dispose();  }}class Indicator extends StatefulWidget {  /// size of the dots  final double size;  /// space between dots.  final double space;  /// count of dots  final int count;  /// active color  final Color activeColor;  /// normal color  final Color color;  /// layout of the dots,default is [IndicatorType.slide]  final IndicatorType layout;  // Only valid when layout==IndicatorType.scale  final double scale;  // Only valid when layout==IndicatorType.drop  final double dropHeight;  final PageController controller;  final double activeSize;  Indicator(      {Key key,      this.size: 20.0,      this.space: 5.0,      this.count,      this.activeSize: 20.0,      this.controller,      this.color: Colors.white30,      this.layout: IndicatorType.slide,      this.activeColor: Colors.white,      this.scale: 0.6,      this.dropHeight: 20.0})      : assert(count != null),        assert(controller != null),        super(key: key);  @override  State<StatefulWidget> createState() {    return IndicatorState();  }}