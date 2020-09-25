import 'package:flutter/widgets.dart';import 'package:flutter_waya/flutter_waya.dart';import 'package:flutter_waya/src/constant/way.dart';class DateTimePicker extends StatefulWidget {  DateTimePicker({    Key key,    bool dual,    bool showUnit,    double height,    this.itemWidth,    Widget sure,    Widget cancel,    Widget title,    this.diameterRatio,    this.offAxisFraction,    this.perspective,    this.magnification,    this.useMagnifier = true,    this.squeeze,    this.itemHeight,    this.physics,    this.backgroundColor,    this.cancelTap,    this.sureTap,    DateTimePickerUnit unit,    this.unitStyle,    this.contentStyle,    this.startDate,    this.defaultDate,    this.endDate,    this.titleBottom,  })  : unit = unit ?? DateTimePickerUnit().getDefaultUnit(),        sure = sure ?? WayWidgets.textDefault('sure'),        title = title ?? WayWidgets.textDefault('title'),        cancel = cancel ?? WayWidgets.textDefault('cancel'),        height = height ?? 200,        showUnit = showUnit ?? true,        dual = dual ?? true,        super(key: key);  ///补全双位数  final bool dual;  ///单位是否显示  final bool showUnit;  ///点击事件  final GestureTapCallback cancelTap;  final ValueChanged<String> sureTap;  ///title底部内容  final Widget titleBottom;  final Widget sure;  final Widget cancel;  final Widget title;  ///容器属性  final Color backgroundColor;  final double height;  ///时间选择器单位  final DateTimePickerUnit unit;  ///字体样式  final TextStyle unitStyle;  final TextStyle contentStyle;  ///时间  final DateTime startDate;  final DateTime defaultDate;  final DateTime endDate;  ///以下为ListWheel属性  ///高度  final double itemHeight;  final double itemWidth;  /// 半径大小,越大则越平面,越小则间距越大  final double diameterRatio;  /// 选中item偏移  final double offAxisFraction;  ///表示ListWheel水平偏离中心的程度  范围[0,0.01]  final double perspective;  ///放大倍率  final double magnification;  ///是否启用放大镜  final bool useMagnifier;  ///1或者2  final double squeeze;  final ScrollPhysics physics;  @override  _DateTimePickerState createState() => _DateTimePickerState();}class _DateTimePickerState extends State<DateTimePicker> {  List<String> yearData = <String>[],      monthData = <String>[],      dayData = <String>[],      hourData = <String>[],      minuteData = <String>[],      secondData = <String>[];  FixedExtentScrollController controllerDay;  ///字体样式  TextStyle contentStyle;  TextStyle unitStyle;  ///时间  DateTime startDate;  DateTime defaultDate;  DateTime endDate;  DateTimePickerUnit unit;  double itemWidth;  int yearIndex = 0;  int monthIndex = 0;  int dayIndex = 0;  int hourIndex = 0;  int minuteIndex = 0;  int secondIndex = 0;  @override  void initState() {    super.initState();    unit = widget.unit;    itemWidth = widget.itemWidth ?? (getWidth(0) - getWidth(20)) / unit.getLength();    ///样式设置    contentStyle = widget.contentStyle ?? textStyleVoid();    unitStyle = widget.unitStyle ?? textStyleVoid();    startDate = widget.startDate ?? DateTime.now();    endDate = initEndDate();    defaultDate = initDefaultDate();    ///初始化每个Wheel数组    final int year = (endDate.year - startDate.year) + 1;    for (int i = 0; i < year; i++) {      yearData.add((startDate.year + i).toString());    }    yearIndex = defaultDate.year - startDate.year;    monthIndex = defaultDate.month - 1;    dayIndex = defaultDate.day - 1;    hourIndex = defaultDate.hour;    minuteIndex = defaultDate.minute;    secondIndex = defaultDate.second;    monthData = addList(12, startNumber: 1).cast<String>();    dayData = calculateDayNumber(isFirst: true).cast<String>();    hourData = addList(24).cast<String>();    minuteData = addList(60).cast<String>();    secondData = addList(60).cast<String>();    controllerDay = FixedExtentScrollController(initialItem: dayIndex);  }  DateTime initDefaultDate() {    if (widget.defaultDate == null) return startDate;    if (widget.defaultDate.isBefore(startDate)) return startDate;    if (widget.defaultDate.isAfter(endDate)) return endDate;    return widget.defaultDate;  }  DateTime initEndDate() {    if (widget.endDate != null && startDate.isBefore(widget.endDate)) return widget.endDate;    return startDate.add(const Duration(days: 3650));  }  TextStyle textStyleVoid() => TextStyle(      fontSize: 14,      color: getColors(black),      decoration: TextDecoration.none,      decorationStyle: TextDecorationStyle.dashed);  ///显示双数还是单数  String valuePadLeft(String value) => widget.dual ? value.padLeft(2, '0') : value;  ///wheel数组添加数据  List<String> addList(int maxNumber, {int startNumber = 0}) {    final List<String> list = <String>[];    for (int i = startNumber; i < (startNumber == 0 ? maxNumber : maxNumber + 1); i++) {      list.add(valuePadLeft(i.toString()));    }    return list;  }  ///计算每月day的数量  List<String> calculateDayNumber({bool isFirst = false}) {    final int selectYearItem = isFirst ? (defaultDate.year - startDate.year) : yearIndex;    final int selectMonthItem = isFirst ? defaultDate.month : monthIndex + 1;    if (selectMonthItem == 1 ||        selectMonthItem == 3 ||        selectMonthItem == 5 ||        selectMonthItem == 7 ||        selectMonthItem == 8 ||        selectMonthItem == 10 ||        selectMonthItem == 12) {      return addList(31, startNumber: 1);    }    if (selectMonthItem == 2) {      return addList(          DateTime(int.parse(yearData[selectYearItem]), 3)              .difference(DateTime(int.parse(yearData[selectYearItem]), 2))              .inDays,          startNumber: 1);    } else {      return addList(30, startNumber: 1);    }  }  ///刷新day数  void refreshDay() {    int oldDayIndex = dayIndex;    final List<String> newDayList = calculateDayNumber().cast<String>();    if (newDayList.length != dayData.length) {      dayData = newDayList;      if (oldDayIndex > 25) {        jumpToIndex(25, controllerDay);        final int newDayIndex = newDayList.length - 1;        if (oldDayIndex > newDayIndex) oldDayIndex = newDayIndex;      }      datState(() {});      jumpToIndex(oldDayIndex, controllerDay);    }  }  ///点击确定返回日期  void sureTapVoid() {    if (widget.sureTap == null) return;    String dateTime = '';    if (unit?.year != null) dateTime = yearData[yearIndex] + '-';    if (unit?.month != null) dateTime += monthData[monthIndex] + '-';    if (unit?.day != null) dateTime += dayData[dayIndex] + ' ';    if (unit?.hour != null) dateTime += hourData[hourIndex];    if (unit?.minute != null) dateTime += ':' + minuteData[minuteIndex];    if (unit?.second != null) dateTime += ':' + secondData[secondIndex];    widget.sureTap(dateTime.trim());  }  StateSetter datState;  @override  Widget build(BuildContext context) {    final List<Widget> rowChildren = <Widget>[];    if (unit.year != null)      rowChildren.add(wheelItem(yearData, initialIndex: yearIndex, unit: unit?.year, onChanged: (int newIndex) {        yearIndex = newIndex;        if (unit.day != null) refreshDay();        limitStartAndEnd();      }));    if (unit.month != null)      rowChildren.add(wheelItem(monthData, initialIndex: monthIndex, unit: unit?.month, onChanged: (int newIndex) {        monthIndex = newIndex;        if (unit.day != null) refreshDay();        limitStartAndEnd();      }));    if (unit.day != null)      rowChildren.add(StatefulBuilder(builder: (BuildContext context, StateSetter setState) {        datState = setState;        return wheelItem(dayData, controller: controllerDay, unit: unit?.day, onChanged: (int newIndex) {          dayIndex = newIndex;          limitStartAndEnd();        });      }));    if (unit.hour != null)      rowChildren.add(wheelItem(hourData, unit: unit?.hour, initialIndex: hourIndex, onChanged: (int newIndex) {        hourIndex = newIndex;        limitStartAndEnd();      }));    if (unit.minute != null)      rowChildren.add(wheelItem(minuteData, initialIndex: minuteIndex, unit: unit?.minute, onChanged: (int newIndex) {        minuteIndex = newIndex;        limitStartAndEnd();      }));    if (unit.second != null)      rowChildren.add(wheelItem(secondData, initialIndex: secondIndex, unit: unit?.second, onChanged: (int newIndex) {        secondIndex = newIndex;        limitStartAndEnd();      }));    final List<Widget> columnChildren = <Widget>[];    columnChildren.add(Universal(        direction: Axis.horizontal,        padding: EdgeInsets.all(getWidth(10)),        mainAxisAlignment: MainAxisAlignment.spaceBetween,        children: <Widget>[          Universal(child: widget.cancel, onTap: widget.cancelTap),          Container(child: widget.title),          Universal(child: widget.sure, onTap: sureTapVoid)        ]));    if (widget.titleBottom != null) columnChildren.add(widget.titleBottom);    columnChildren.add(Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: rowChildren)));    return Universal(        onTap: () {},        mainAxisSize: MainAxisSize.min,        height: widget.height,        decoration: BoxDecoration(color: widget.backgroundColor ?? getColors(white)),        children: columnChildren);  }  Widget wheelItem(List<String> list,      {FixedExtentScrollController controller, String unit, int initialIndex, ValueChanged<int> onChanged}) {    return Universal(        direction: Axis.horizontal,        mainAxisAlignment: MainAxisAlignment.center,        crossAxisAlignment: CrossAxisAlignment.center,        width: itemWidth,        children: !widget.showUnit            ? null            : <Widget>[                Expanded(                    child: listWheel(                        list: list, initialIndex: initialIndex, controller: controller, onChanged: onChanged)),                Container(                    margin: EdgeInsets.only(left: getWidth(2)),                    alignment: Alignment.center,                    height: double.infinity,                    child: Text(unit, style: unitStyle))              ],        child: widget.showUnit            ? null            : listWheel(list: list, initialIndex: initialIndex, controller: controller, onChanged: onChanged));  }  Widget listWheel(      {List<String> list, int initialIndex, FixedExtentScrollController controller, ValueChanged<int> onChanged}) {    return ListWheel(        controller: controller,        itemExtent: widget.itemHeight,        diameterRatio: widget.diameterRatio,        offAxisFraction: widget.offAxisFraction,        perspective: widget.perspective,        magnification: widget.magnification,        useMagnifier: widget.useMagnifier,        squeeze: widget.squeeze,        physics: widget.physics,        initialIndex: initialIndex,        itemBuilder: (_, int index) => WayWidgets.textSmall(list[index].toString(), style: contentStyle),        itemCount: list.length,        onChanged: onChanged);  }  bool limitStartAndEnd() {    final DateTime selectDateTime = DateTime.parse(        '${yearData[yearIndex]}-${monthData[monthIndex]}-${dayData[dayIndex]} ${hourData[hourIndex]}:${minuteData[minuteIndex]}:${secondData[dayIndex]}');    if (selectDateTime.isBefore(startDate)) {      return true;    } else if (selectDateTime.isAfter(endDate)) {      return false;    } else {      return null;    }  }  void jumpToIndex(int index, FixedExtentScrollController controller, {Duration duration}) {    if (controller != null) controller.jumpToItem(index);  }}