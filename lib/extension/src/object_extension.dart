import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_waya/flutter_waya.dart';

extension ExtensionUint8List on Uint8List {
  List<int> bit32ListFromUInt8List() {
    final Uint8List bytes = this;
    final int additionalLength = bytes.length % 4 > 0 ? 4 : 0;
    final List<int> result =
        (bytes.length ~/ 4 + additionalLength).generate((_) => 0);
    for (int i = 0; i < bytes.length; i++) {
      final int resultIdx = i ~/ 4;
      final int bitShiftAmount = (3 - i % 4).toInt();
      result[resultIdx] |= bytes[i] << bitShiftAmount;
    }
    for (int i = 0; i < result.length; i++) {
      result[i] = result[i] << 24;
    }
    return result;
  }
}

extension ExtensionListUnsafe on List? {
  /// null 或者 Empty 返回 true
  bool checkNullOrEmpty() => this == null || this!.isEmpty;
}

extension ExtensionList<T> on List<T> {
  String? get base64Encode {
    if (T != int) return null;
    return base64.encode(this as List<int>);
  }

  String? get utf8Decode {
    if (T != int) return null;
    return utf8.decode(this as List<int>);
  }

  Uint8List? get uInt8ListFrom32BitList {
    if (T != int) return null;
    final List<int> bit32 = this as List<int>;
    final Uint8List result = Uint8List(bit32.length * 4);
    for (int i = 0; i < bit32.length; i++) {
      for (int j = 0; j < 4; j++) {
        result[i * 4 + j] = bit32[i] >> (j * 8);
      }
    }
    return result;
  }

  /// List<int> toUtf8
  String? get toUtf8 {
    if (T != int) return null;
    final List<int?> words = this as List<int>;
    final int sigBytes = words.length;
    final List<int> chars = sigBytes.generate((int i) {
      if (words[i >> 2] == null) words[i >> 2] = 0;
      final int bite =
          ((words[i >> 2]!).toSigned(32) >> (24 - (i % 4) * 8)) & 0xff;
      return bite;
    });
    return String.fromCharCodes(chars);
  }

  /// list.map.toList()
  List<E> builder<E>(E Function(T) builder) =>
      map<E>((T e) => builder(e)).toList();

  List<E> generate<E>(E Function(int index) generator,
          {bool growable = true}) =>
      length.generate<E>((int index) => generator(index), growable: growable);

  /// list.asMap().entries.map.toList()
  List<E> builderEntry<E>(E Function(MapEntry<int, T>) builder) =>
      asMap().entries.map((MapEntry<int, T> entry) => builder(entry)).toList();

  /// 添加子元素 并返回 新数组
  List<T> addT(T value, {bool isAdd = true}) {
    if (isAdd) add(value);
    return this;
  }

  /// 添加数组 并返回 新数组
  List<T> addAllT(List<T> iterable, {bool isAdd = true}) {
    if (isAdd) addAll(iterable);
    return this;
  }

  /// 插入子元素 并返回 新数组
  List<T> insertT(int index, T value, {bool isInsert = true}) {
    if (isInsert) insert(index, value);
    return this;
  }

  /// 插入数组 并返回 新数组
  List<T> insertAllT(int index, List<T> iterable, {bool isInsert = true}) {
    if (isInsert) insertAll(index, iterable);
    return this;
  }

  /// 替换指定区域 返回 新数组
  List<T> replaceRangeT(int start, int end, Iterable<T> replacement,
      {bool isReplace = true}) {
    if (isReplace) replaceRange(start, end, replacement);
    return this;
  }
}

extension ExtensionListString on List<String> {
  /// 移出首尾的括号 转换为字符串
  String removeStartEnd() => toString().removeSuffix(']').removePrefix('[');
}

extension ExtensionIterable<V> on Iterable<V> {
  /// Iterable.map.toList()
  List<E> builder<E>(E Function(V) builder) =>
      map<E>((V e) => builder(e)).toList();
}

extension ExtensionMap<K, V> on Map<K, V> {
  List<K> keysList({bool growable = true}) => keys.toList(growable: growable);

  List<V> valuesList({bool growable = true}) =>
      values.toList(growable: growable);

  List<E> builderEntry<E>(E Function(MapEntry<K, V>) builder) =>
      entries.map((MapEntry<K, V> entry) => builder(entry)).toList();

  /// addAll map 并返回 新map
  Map<K, V> addAllT(Map<K, V> iterable, {bool isAdd = true}) {
    if (isAdd) addAll(iterable);
    return this;
  }

  /// update map 并返回 新map
  Map<K, V> updateAllT(V Function(K key, V value) update,
      {bool isUpdate = true}) {
    if (isUpdate) updateAll(update);
    return this;
  }

  /// update map 并返回 新map
  Map<K, V> updateT(K key, V Function(V value) update,
      {V Function()? ifAbsent, bool isUpdate = true}) {
    if (isUpdate) this.update(key, update, ifAbsent: ifAbsent);
    return this;
  }
}

enum DateTimeDist {
  /// 2020-01-01 00:00:00
  yearSecond,

  /// 2020-01-01 00:00
  yearMinute,

  /// 2020-01-01 00
  yearHour,

  /// 2020-01-01
  yearDay,

  /// 2020-01
  yearMonth,

  /// 01-01 00:00:00
  monthSecond,

  /// 01-01 00:00
  monthMinute,

  /// 01-01 00
  monthHour,

  /// 01-01
  monthDay,

  /// 01 00:00:00
  daySecond,

  /// 01 00:00
  dayMinute,

  /// 01 00
  dayHour,

  /// 00:00:00
  hourSecond,

  /// 00:00
  hourMinute,
}

/// DateTime 扩展
extension ExtensionDateTime on DateTime {
  /// 转换指定长度的字符串
  String format([DateTimeDist? dist, bool dual = true]) {
    final DateTime date = this;
    dist ??= DateTimeDist.yearSecond;
    final String year = date.year.toString();
    final String month =
        dual ? date.month.padLeft(2, '0') : date.month.toString();
    final String day = dual ? date.day.padLeft(2, '0') : date.day.toString();
    final String hour = dual ? date.hour.padLeft(2, '0') : date.hour.toString();
    final String minute =
        dual ? date.minute.padLeft(2, '0') : date.minute.toString();
    final String second =
        dual ? date.second.padLeft(2, '0') : date.second.toString();
    switch (dist) {
      case DateTimeDist.yearSecond:
        return '$year-$month-$day $hour:$minute:$second';
      case DateTimeDist.yearMinute:
        return '$year-$month-$day $hour:$minute';
      case DateTimeDist.yearHour:
        return '$year-$month-$day $hour';
      case DateTimeDist.yearDay:
        return '$year-$month-$day';
      case DateTimeDist.yearMonth:
        return '$year-$month';
      case DateTimeDist.monthSecond:
        return '$month-$day $hour:$minute:$second';
      case DateTimeDist.monthMinute:
        return '$month-$day $hour:$minute';
      case DateTimeDist.monthHour:
        return '$month-$day $hour';
      case DateTimeDist.monthDay:
        return '$month-$day';
      case DateTimeDist.daySecond:
        return '$day $hour:$minute:$second';
      case DateTimeDist.dayMinute:
        return '$day $hour:$minute';
      case DateTimeDist.dayHour:
        return '$day $hour';
      case DateTimeDist.hourSecond:
        return '$hour:$minute:$second';
      case DateTimeDist.hourMinute:
        return '$hour:$minute';
    }
  }

  /// Return whether it is leap year.
  /// 是否是闰年
  bool get isLeapYearByYear =>
      year % 4 == 0 && year % 100 != 0 || year % 400 == 0;
}

extension DurationExtension on Duration {
  /// final _delay = 3.seconds;
  /// print('+ wait $_delay');
  /// await _delay.delayed();
  /// print('- finish wait $_delay');
  /// print('+ callback in 700ms');
  Future<T> delayed<T>([FutureOr<T> Function()? callback]) =>
      Future<T>.delayed(this, callback);

  /// Timer
  Timer timer([Function? function]) {
    late Timer timer;
    timer = Timer(this, () {
      if (function != null) function.call();
      timer.cancel();
    });
    return timer;
  }

  /// 需要手动释放timer
  Timer timerPeriodic(void Function(Timer timer) callback) =>
      Timer.periodic(this, (Timer time) => callback(time));
}

extension ExtensionFunction on Function() {
  /// 函数防抖
  Function() debounce([Duration delay = const Duration(seconds: 2)]) {
    Timer? timer;
    return () {
      if (timer?.isActive ?? false) timer?.cancel();
      timer = Timer(delay, () => this.call());
    };
  }

  /// 截流函数
  Function() throttle([Duration delay = const Duration(seconds: 2)]) {
    bool enable = true;
    return () {
      if (enable == true) {
        enable = false;
        this.call();
        delay.delayed(() => enable = true);
      }
    };
  }
}
