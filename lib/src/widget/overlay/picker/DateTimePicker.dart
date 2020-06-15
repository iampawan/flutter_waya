import 'package:flutter/widgets.dart';import 'package:flutter_waya/flutter_waya.dart';import 'package:flutter_waya/src/common/CommonWidget.dart';import 'package:flutter_waya/src/constant/WayColor.dart';import 'package:flutter_waya/src/constant/WayStyles.dart';class DateTimePicker extends StatefulWidget {  ///补全双位数  final bool dual;  ///单位是否显示  final bool showUnit;  ///点击事件  final GestureTapCallback cancelTap;  final ValueChanged<String> sureTap;  ///title底部内容  final Widget titleBottom;  final Widget sure;  final Widget cancel;  final Widget title;  ///容器属性  final Color backgroundColor;  final double height;  ///时间选择器单位  final DateTimePickerUnit unit;  ///字体样式  final TextStyle unitStyle;  final TextStyle contentStyle;  ///时间  final DateTime startDate;  final DateTime defaultDate;  final DateTime endDate;  ///以下为滚轮属性  ///高度  final double itemHeight;  final double itemWidth;  /// 半径大小,越大则越平面,越小则间距越大  final double diameterRatio;  /// 选中item偏移  final double offAxisFraction;  ///表示车轮水平偏离中心的程度  范围[0,0.01]  final double perspective;  ///放大倍率  final double magnification;  ///是否启用放大镜  final bool useMagnifier;  ///1或者2  final double squeeze;  final ScrollPhysics physics;  DateTimePicker({    Key key,    bool dual,    bool showUnit,    double height,    this.itemWidth,    Widget titleBottom,    Widget sure,    Widget cancel,    Widget title,    this.diameterRatio,    this.offAxisFraction,    this.perspective,    this.magnification,    this.useMagnifier: true,    this.squeeze,    this.itemHeight,    this.physics,    this.backgroundColor,    this.cancelTap,    this.sureTap,    DateTimePickerUnit unit,    this.unitStyle,    this.contentStyle,    this.startDate,    this.defaultDate,    this.endDate,  })  : this.titleBottom = titleBottom ?? Container(),        this.unit = unit ?? DateTimePickerUnit().getDefaultUnit(),        this.sure = sure ?? CommonWidget.textDefault('sure'),        this.title = title ?? CommonWidget.textDefault('title'),        this.cancel = cancel ?? CommonWidget.textDefault('cancel'),        this.height = height ?? Tools.getHeight() / 4,        this.showUnit = showUnit ?? true,        this.dual = dual ?? true,        super(key: key);  @override  State<StatefulWidget> createState() {    return DateTimePickerState();  }}class DateTimePickerState extends State<DateTimePicker> {  ///内置变量  List<String> yearData = [],      monthData = [],      dayData = [],      hourData = [],      minuteData = [],      secondData = [];  FixedExtentScrollController controllerYear,      controllerMonth,      controllerDay,      controllerHour,      controllerMinute,      controllerSecond;  ///字体样式  TextStyle contentStyle;  TextStyle unitStyle;  ///时间  DateTime startDate;  DateTime defaultDate;  DateTime endDate;  DateTimePickerUnit unit;  double itemWidth;  int yearIndex = 0;  int monthIndex = 0;  int dayIndex = 0;  int hourIndex = 0;  int minuteIndex = 0;  int secondIndex = 0;  @override  void initState() {    super.initState();    unit = widget.unit;    itemWidth = widget.itemWidth ??        (Tools.getWidth() - Tools.getWidth(20)) / unit.getLength();    ///样式设置    contentStyle = widget.contentStyle ?? textStyleVoid();    unitStyle = widget.unitStyle ?? textStyleVoid();    startDate = widget.startDate ?? DateTime.now();    endDate = initEndDate();    defaultDate = initDefaultDate();    ///初始化每个Wheel数组    int year = (endDate.year - startDate.year) + 1;    for (int i = 0; i < year; i++) {      yearData.add((startDate.year + i).toString());    }    yearIndex = defaultDate.year - startDate.year;    monthIndex = defaultDate.month - 1;    dayIndex = defaultDate.day - 1;    hourIndex = defaultDate.hour;    minuteIndex = defaultDate.minute;    secondIndex = defaultDate.second;    monthData = addList(12, startNumber: 1);    dayData = calculateDayNumber(isFirst: true);    hourData = addList(24);    minuteData = addList(60);    secondData = addList(60);    controllerYear = FixedExtentScrollController(initialItem: yearIndex);    controllerMonth = FixedExtentScrollController(initialItem: monthIndex);    controllerDay = FixedExtentScrollController(initialItem: dayIndex);    controllerHour = FixedExtentScrollController(initialItem: hourIndex);    controllerMinute = FixedExtentScrollController(initialItem: minuteIndex);    controllerSecond = FixedExtentScrollController(initialItem: secondIndex);  }  DateTime initDefaultDate() {    if (widget.defaultDate == null) return startDate;    if (widget.defaultDate.isBefore(startDate)) return startDate;    if (widget.defaultDate.isAfter(endDate)) return endDate;    return widget.defaultDate;  }  DateTime initEndDate() {    if (widget.endDate != null && startDate.isAfter(widget.endDate))      return widget.endDate;    return startDate.add(Duration(days: 3650));  }  textStyleVoid() {    return TextStyle(        fontSize: 14,        color: getColors(black),        decoration: TextDecoration.none,        decorationStyle: TextDecorationStyle.dashed);  }  ///显示双数还是单数  valuePadLeft(String value) {    return widget.dual ? value.padLeft(2, "0") : value;  }  ///wheel数组添加数据  addList(maxNumber, {int startNumber: 0}) {    List<String> list = List();    for (int i = startNumber;        i < (startNumber == 0 ? maxNumber : maxNumber + 1);        i++) {      list.add(valuePadLeft(i.toString()));    }    return list;  }  ///计算每月day的数量  calculateDayNumber({bool isFirst: false}) {    int selectYearItem =        isFirst ? (defaultDate.year - startDate.year) : yearIndex;    int selectMonthItem = isFirst ? defaultDate.month : monthIndex + 1;    if (selectMonthItem == 1 ||        selectMonthItem == 3 ||        selectMonthItem == 5 ||        selectMonthItem == 7 ||        selectMonthItem == 8 ||        selectMonthItem == 10 ||        selectMonthItem == 12) {      return addList(31, startNumber: 1);    }    if (selectMonthItem == 2) {      return addList(          DateTime(int.parse(yearData[selectYearItem]), 3)              .difference(DateTime(int.parse(yearData[selectYearItem]), 2))              .inDays,          startNumber: 1);    } else {      return addList(30, startNumber: 1);    }  }  ///刷新day数  refreshDay() {    int oldDayIndex = dayIndex;    List<String> newDayList = calculateDayNumber();    if (newDayList.length != dayData.length) {      dayData = newDayList;      if (oldDayIndex > 25) {        jumpToIndex(25, controllerDay);        int newDayIndex = newDayList.length - 1;        if (oldDayIndex > newDayIndex) {          oldDayIndex = newDayIndex;        }      }      setState(() {});      Tools.timerTools(Duration(milliseconds: 8), () {        jumpToIndex(yearIndex, controllerYear);        jumpToIndex(monthIndex, controllerMonth);        jumpToIndex(oldDayIndex, controllerDay);        jumpToIndex(hourIndex, controllerHour);        jumpToIndex(minuteIndex, controllerMinute);        jumpToIndex(secondIndex, controllerSecond);      });    }  }  ///点击确定返回日期  sureTapVoid() {    if (widget.sureTap == null) return;    String dateTime = '';    if (unit?.year != null) dateTime = yearData[yearIndex] + '-';    if (unit?.month != null) dateTime += monthData[monthIndex] + '-';    if (unit?.day != null) dateTime += dayData[dayIndex] + ' ';    if (unit?.hour != null) dateTime += hourData[hourIndex];    if (unit?.minute != null) dateTime += ':' + minuteData[minuteIndex];    if (unit?.second != null) dateTime += ':' + secondData[secondIndex];    widget.sureTap(dateTime.trim());  }  @override  Widget build(BuildContext context) {    List<Widget> children = List();    if (unit.year != null)      children.add(        wheelItem(yearData, controller: controllerYear, unit: unit?.year,            onItemSelected: (int newIndex) {          yearIndex = newIndex;          refreshDay();          limitStartAndEnd();        }),      );    if (unit.month != null)      children.add(        wheelItem(monthData, controller: controllerMonth, unit: unit?.month,            onItemSelected: (int newIndex) {          monthIndex = newIndex;          refreshDay();          limitStartAndEnd();        }),      );    if (unit.day != null)      children.add(wheelItem(dayData,          controller: controllerDay,          unit: unit?.day, onItemSelected: (int newIndex) {        dayIndex = newIndex;        limitStartAndEnd();      }));    if (unit.hour != null)      children.add(        wheelItem(hourData, unit: unit?.hour, controller: controllerHour,            onItemSelected: (int newIndex) {          hourIndex = newIndex;          limitStartAndEnd();        }),      );    if (unit.minute != null)      children.add(        wheelItem(minuteData, controller: controllerMinute, unit: unit?.minute,            onItemSelected: (int newIndex) {          minuteIndex = newIndex;          limitStartAndEnd();        }),      );    if (unit.second != null)      children.add(        wheelItem(secondData, controller: controllerSecond, unit: unit?.second,            onItemSelected: (int newIndex) {          secondIndex = newIndex;          limitStartAndEnd();        }),      );    return Universal(      onTap: () {},      mainAxisSize: MainAxisSize.min,      height: widget.height,      decoration:          BoxDecoration(color: widget.backgroundColor ?? getColors(white)),      children: <Widget>[        Universal(          direction: Axis.horizontal,          padding: EdgeInsets.all(Tools.getWidth(10)),          mainAxisAlignment: MainAxisAlignment.spaceBetween,          children: <Widget>[            Universal(child: widget.cancel, onTap: widget.cancelTap),            Container(child: widget.title),            Universal(child: widget.sure, onTap: sureTapVoid)          ],        ),        widget.titleBottom,        Expanded(            child: Row(          mainAxisAlignment: MainAxisAlignment.center,          children: children,        ))      ],    );  }  Widget wheelItem(List<String> list,      {FixedExtentScrollController controller,      String unit,      WheelChangedListener onItemSelected}) {    return Universal(        direction: Axis.horizontal,        mainAxisAlignment: MainAxisAlignment.center,        crossAxisAlignment: CrossAxisAlignment.center,        width: itemWidth,        children: !widget.showUnit            ? null            : <Widget>[                Expanded(child: listWheel(list, controller, onItemSelected)),                Container(                    margin: EdgeInsets.only(left: Tools.getWidth(2)),                    alignment: Alignment.center,                    height: double.infinity,                    child: Text(unit, style: unitStyle))              ],        child: widget.showUnit            ? null            : listWheel(list, controller, onItemSelected));  }  Widget listWheel(List<String> list, FixedExtentScrollController controller,      WheelChangedListener onItemSelected) {    return ListWheel(        controller: controller,        itemExtent: widget.itemHeight,        diameterRatio: widget.diameterRatio,        offAxisFraction: widget.offAxisFraction,        perspective: widget.perspective,        magnification: widget.magnification,        useMagnifier: widget.useMagnifier,        squeeze: widget.squeeze,        physics: widget.physics,        itemBuilder: (BuildContext context, int index) {          return Text(list[index].toString(), style: contentStyle);        },        itemCount: list.length,        onItemSelected: onItemSelected);  }  limitStartAndEnd() {    var selectDateTime = DateTime.parse(        '${yearData[yearIndex]}-${monthData[monthIndex]}-${dayData[dayIndex]} ${hourData[hourIndex]}:${minuteData[minuteIndex]}:${secondData[dayIndex]}');    if (selectDateTime.isBefore(startDate)) {      return true;    } else if (selectDateTime.isAfter(endDate)) {      return false;    } else {      return null;    }  }  jumpToIndex(int index, FixedExtentScrollController controller,      {Duration duration}) {    if (controller != null) {      controller.jumpToItem(index);    }  }}