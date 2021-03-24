import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

/// EasyRefresh滚动形式
/// Scroll physics for environments that allow the scroll offset to go beyond
/// the bounds of the content, but then bounce the content back to the edge of
/// those bounds.
///
/// This is the behavior typically seen on iOS.
///
/// See also:
///
///  * [ScrollConfiguration], which uses this to provide the default
///    scroll behavior on iOS.
///  * [ClampingScrollPhysics], which is the analogous physics for Android's
///    clamping behavior.
class EasyRefreshPhysics extends ScrollPhysics {
  /// Creates scroll physics that bounce back from the edge.
  const EasyRefreshPhysics({
    required ScrollPhysics parent,
    required this.taskNotifier,
    required this.bouncingNotifier,
    required this.extraExtentNotifier,
  }) : super(parent: parent);

  /// 任务状态
  final ValueNotifier<double> taskNotifier;

  /// 回弹设置
  final ValueNotifier<BouncingSettings> bouncingNotifier;

  /// 列表未占满时多余长度
  final ValueNotifier<double> extraExtentNotifier;

  /// @override
  /// EasyRefreshPhysics applyTo(ScrollPhysics ancestor) {
  ///   return EasyRefreshPhysics(
  ///     parent: buildParent(ancestor)!,
  ///     taskNotifier: taskNotifier,
  ///     bouncingNotifier: bouncingNotifier,
  ///     extraExtentNotifier: extraExtentNotifier,
  ///   );
  /// }

  /// 是否允许Bottom越界(列表未占满)
  bool get bottomOverScroll => extraExtentNotifier.value > 0.0;

  double frictionFactor(double overScrollFraction) =>
      0.52 * math.pow(1 - overScrollFraction, 2);

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    assert(offset != 0.0);
    assert(position.minScrollExtent <= position.maxScrollExtent);

    if (!position.outOfRange) return offset;

    final double overScrollPastStart =
        math.max(position.minScrollExtent - position.pixels, 0.0);
    final double overScrollPastEnd =
        math.max(position.pixels - position.maxScrollExtent, 0.0);
    final double overScrollPast =
        math.max(overScrollPastStart, overScrollPastEnd);
    final bool easing = (overScrollPastStart > 0.0 && offset < 0.0) ||
        (overScrollPastEnd > 0.0 && offset > 0.0);

    final double friction = easing
        ? frictionFactor(
            (overScrollPast - offset.abs()) / position.viewportDimension)
        : frictionFactor(overScrollPast / position.viewportDimension);
    final double direction = offset.sign;

    return direction * _applyFriction(overScrollPast, offset.abs(), friction);
  }

  static double _applyFriction(
      double extentOutside, double absDelta, double gamma) {
    assert(absDelta > 0);
    double total = 0.0;
    if (extentOutside > 0) {
      final double deltaToLimit = extentOutside / gamma;
      if (absDelta < deltaToLimit) return absDelta * gamma;
      total += extentOutside;
      absDelta -= deltaToLimit;
    }
    return total + absDelta;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (!bouncingNotifier.value.top) {
      if (value < position.pixels &&
          position.pixels <= position.minScrollExtent)

        /// underscroll
        return value - position.pixels;
      if (value < position.minScrollExtent &&
          position.minScrollExtent < position.pixels)

        /// hit top edge
        return value - position.minScrollExtent;
    }
    if (!bouncingNotifier.value.top && value - position.minScrollExtent < 0.0) {
      /// 防止越界超过header高度
      return value - position.minScrollExtent + 0.0001;
    }
    if (!bouncingNotifier.value.bottom && !bottomOverScroll) {
      if (position.maxScrollExtent <= position.pixels &&
          position.pixels < value) {
        /// overScroll
        return value - position.pixels;
      }
      if (position.pixels < position.maxScrollExtent &&
          position.maxScrollExtent < value)

        /// hit bottom edge
        return value - position.maxScrollExtent;
    }
    if (!bouncingNotifier.value.bottom &&
        value - position.maxScrollExtent > 0.0 &&
        !bottomOverScroll) {
      /// 防止越界超过footer高度
      return value - position.maxScrollExtent;
    }
    return 0.0;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.tolerance;
    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity: velocity * 0.91,
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
      );
    }
    return null;
  }

  /// The ballistic simulation here decelerates more slowly than the one for
  /// ClampingScrollPhysics so we require a more deliberate input gesture
  /// to trigger a fling.
  @override
  double get minFlingVelocity => kMinFlingVelocity * 2.0;

  /// Methodology:
  /// 1- Use https:///github.com/flutter/scroll_overlay to test with Flutter and
  ///    platform scroll views superimposed.
  /// 2- Record incoming speed and make rapid flings in the test app.
  /// 3- If the scrollable stopped overlapping at any moment, adjust the desired
  ///    output value of this function at that input speed.
  /// 4- Feed new input/output set into a power curve fitter. Change function
  ///    and repeat from 2.
  /// 5- Repeat from 2 with medium and slow flings.
  /// Momentum build-up function that mimics iOS's scroll speed increase with repeated flings.
  ///
  /// The velocity of the last fling is not an important factor. Existing speed
  /// and (related) time since last fling are factors for the velocity transfer
  /// calculations.
  @override
  double carriedMomentum(double existingVelocity) {
    return existingVelocity.sign *
        math.min(0.000816 * math.pow(existingVelocity.abs(), 1.967).toDouble(),
            40000.0);
  }

  /// Eyeballed from observation to counter the effect of an unintended scroll
  /// from the natural motion of lifting the finger after a scroll.
  @override
  double get dragStartDistanceMotionThreshold => 3.5;
}

/// 回弹设置
class BouncingSettings {
  BouncingSettings({
    this.top = true,
    this.bottom = true,
  });

  bool top;
  bool bottom;

  BouncingSettings copy({
    bool? top,
    bool? bottom,
    bool? hasFooter,
  }) {
    return BouncingSettings(
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
    );
  }
}
