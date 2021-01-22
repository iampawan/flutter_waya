import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

bool get isDebug => !kReleaseMode;
const int _limitLength = 800;

void log(dynamic msg) {
  final String message = msg.toString();
  if (isDebug) {
    if (message.length < _limitLength) {
      print(msg);
    } else {
      _segmentationLog(message);
    }
  }
}

void _segmentationLog(String msg) {
  final StringBuffer outStr = StringBuffer();
  for (int index = 0; index < msg.length; index++) {
    outStr.write(msg[index]);
    if (index % _limitLength == 0 && index != 0) {
      print(outStr);
      outStr.clear();
      final int lastIndex = index + 1;
      if (msg.length - lastIndex < _limitLength) {
        final String remainderStr = msg.substring(lastIndex, msg.length);
        print(remainderStr);
        break;
      }
    }
  }
}

/// int 字节转 k MB GB
String getFileSize(int size) {
  if (size < 1024) {
    return '$size字节';
  } else if (size >= 1024 && size < pow(1024, 2)) {
    size = (size / 10.24).round();
    return '${size / 100}k';
  } else if (size >= pow(1024, 2) && size < pow(1024, 3)) {
    size = (size / (pow(1024, 2) * 0.01)).round();
    return '${size / 100}MB';
  } else if (size >= pow(1024, 3) && size < pow(1024, 4)) {
    size = (size / (pow(1024, 3) * 0.01)).round();
    return '${size / 100}GB';
  }
  return size.toString();
}

void addPostFrameCallback(FrameCallback callback) =>
    WidgetsBinding.instance.addPostFrameCallback(callback);

void setStatusBarLight(bool isLight) {
  const Color color = ConstColors.transparent;
  if (isLight is bool) {
    SystemChrome.setSystemUIOverlayStyle(isLight
        ? const SystemUiOverlayStyle(
            systemNavigationBarColor: ConstColors.black70,
            systemNavigationBarDividerColor: ConstColors.transparent,
            statusBarColor: color,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark)
        : const SystemUiOverlayStyle(
            systemNavigationBarColor: ConstColors.black70,
            systemNavigationBarDividerColor: color,
            statusBarColor: color,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light));
  }
}
