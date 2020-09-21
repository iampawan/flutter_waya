import 'dart:math' as math;import 'package:flutter/material.dart';import 'package:flutter_waya/flutter_waya.dart';class DottedLine extends StatelessWidget {  final double strokeWidth;  final Color color;  final double gap;  final double width;  final double height;  final EdgeInsetsGeometry padding;  final EdgeInsetsGeometry margin;  const DottedLine(      {Key key, double strokeWidth, Color color, double gap, double width, this.padding, this.margin, double height})      : this.strokeWidth = strokeWidth ?? 1,        this.color = color ?? Colors.greenAccent,        this.gap = gap ?? 5.0,        this.height = height ?? 1.0,        this.width = width ?? 100,        super(key: key);  @override  Widget build(BuildContext context) {    return Container(        width: width ?? ScreenFit.getWidth(0),        height: height,        margin: margin,        padding: padding ?? EdgeInsets.all(strokeWidth / 2),        child: CustomPaint(painter: DottedPainter(color: color, strokeWidth: strokeWidth, gap: gap)));  }}class DottedPainter extends CustomPainter {  double strokeWidth;  Color color;  double gap;  DottedPainter({this.strokeWidth = 5.0, this.color: Colors.greenAccent, this.gap = 5.0});  @override  void paint(Canvas canvas, Size size) {    Paint dashedPaint = Paint()      ..color = color      ..strokeWidth = strokeWidth      ..style = PaintingStyle.stroke;    double x = size.width;    double y = size.height;    Path _topPath = getDashedPath(      a: math.Point(0, 0),      b: math.Point(x, 0),      gap: gap,    );    Path _rightPath = getDashedPath(      a: math.Point(x, 0),      b: math.Point(x, y),      gap: gap,    );    Path _bottomPath = getDashedPath(      a: math.Point(0, y),      b: math.Point(x, y),      gap: gap,    );    Path _leftPath = getDashedPath(      a: math.Point(0, 0),      b: math.Point(0.001, y),      gap: gap,    );    canvas.drawPath(_topPath, dashedPaint);    canvas.drawPath(_rightPath, dashedPaint);    canvas.drawPath(_bottomPath, dashedPaint);    canvas.drawPath(_leftPath, dashedPaint);  }  Path getDashedPath({    @required math.Point<double> a,    @required math.Point<double> b,    @required gap,  }) {    Size size = Size(b.x - a.x, b.y - a.y);    Path path = Path();    path.moveTo(a.x, a.y);    bool shouldDraw = true;    math.Point currentPoint = math.Point(a.x, a.y);    num radians = math.atan(size.height / size.width);    num dx = math.cos(radians) * gap < 0 ? math.cos(radians) * gap * -1 : math.cos(radians) * gap;    num dy = math.sin(radians) * gap < 0 ? math.sin(radians) * gap * -1 : math.sin(radians) * gap;    while (currentPoint.x <= b.x && currentPoint.y <= b.y) {      shouldDraw ? path.lineTo(currentPoint.x, currentPoint.y) : path.moveTo(currentPoint.x, currentPoint.y);      shouldDraw = !shouldDraw;      currentPoint = math.Point(        currentPoint.x + dx,        currentPoint.y + dy,      );    }    return path;  }  @override  bool shouldRepaint(CustomPainter oldDelegate) => true;}