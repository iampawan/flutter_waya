import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'icon.dart';
export 'input_text.dart';
export 'list_wheel.dart';
export 'root/root.dart';
export 'root/route/ripple_router.dart';
export 'scroll/scroll_view.dart';
export 'scroll/sliver/element.dart';
export 'scroll/sliver/render.dart';
export 'scroll/sliver/sliver.dart';
export 'tab_bar.dart';
export 'text.dart';
export 'universal.dart';

class SystemUiOverlayStyleLight extends SystemUiOverlayStyle {
  const SystemUiOverlayStyleLight()
      : super(
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark);
}

class SystemUiOverlayStyleDark extends SystemUiOverlayStyle {
  const SystemUiOverlayStyleDark()
      : super(
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light);
}
