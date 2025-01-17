import 'package:flutter/widgets.dart';
import 'package:flutter_waya/widgets/scroll_view/extended_scroll_view.dart';

import 'render.dart';

class SliverPinnedPersistentHeaderElement extends RenderObjectElement {
  SliverPinnedPersistentHeaderElement(super.widget);

  @override
  SliverPinnedPersistentHeaderRenderObjectWidget get widget =>
      super.widget as SliverPinnedPersistentHeaderRenderObjectWidget;

  @override
  RenderSliverPinnedPersistentHeader get renderObject =>
      super.renderObject as RenderSliverPinnedPersistentHeader;

  Element? _minExtentPrototype;
  static final Object _minExtentPrototypeSlot = Object();
  Element? _maxExtentPrototype;
  static final Object _maxExtentPrototypeSlot = Object();

  @override
  void mount(Element? parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    renderObject.element = this;
    _minExtentPrototype = updateChild(_minExtentPrototype,
        widget.delegate.minExtentProtoType, _minExtentPrototypeSlot);
    _maxExtentPrototype = updateChild(_maxExtentPrototype,
        widget.delegate.maxExtentProtoType, _maxExtentPrototypeSlot);
  }

  @override
  void unmount() {
    renderObject.element = null;
    super.unmount();
  }

  @override
  void update(SliverPinnedPersistentHeaderRenderObjectWidget newWidget) {
    final SliverPinnedPersistentHeaderRenderObjectWidget oldWidget = widget;
    super.update(newWidget);
    final SliverPinnedPersistentHeaderDelegate newDelegate = newWidget.delegate;
    final SliverPinnedPersistentHeaderDelegate oldDelegate = oldWidget.delegate;
    if (newDelegate != oldDelegate &&
        (newDelegate.runtimeType != oldDelegate.runtimeType ||
            newDelegate.shouldRebuild(oldDelegate))) {
      renderObject.triggerRebuild();
    }
    _minExtentPrototype = updateChild(_minExtentPrototype,
        widget.delegate.minExtentProtoType, _minExtentPrototypeSlot);
    _maxExtentPrototype = updateChild(_maxExtentPrototype,
        widget.delegate.maxExtentProtoType, _maxExtentPrototypeSlot);
  }

  @override
  void performRebuild() {
    super.performRebuild();
    renderObject.triggerRebuild();
  }

  Element? child;

  void build(double shrinkOffset, double? minExtent, double maxExtent,
      bool overlapsContent) {
    owner!.buildScope(this, () {
      child = updateChild(
          child,
          widget.delegate
              .build(this, shrinkOffset, minExtent, maxExtent, overlapsContent),
          null);
    });
  }

  @override
  void forgetChild(Element child) {
    assert(child == this.child);
    this.child = null;
    super.forgetChild(child);
  }

  @override
  void insertRenderObjectChild(
      covariant RenderObject child, covariant dynamic slot) {
    assert(renderObject.debugValidateChild(child));

    assert(child is RenderBox);
    if (slot == _minExtentPrototypeSlot) {
      renderObject.minProtoType = child as RenderBox;
    } else if (slot == _maxExtentPrototypeSlot) {
      renderObject.maxProtoType = child as RenderBox;
    } else {
      renderObject.child = child as RenderBox;
    }
  }

  @override
  void moveRenderObjectChild(
      covariant RenderObject child, dynamic oldSlot, dynamic newSlot) {
    assert(false);
  }

  @override
  void removeRenderObjectChild(covariant RenderObject child, dynamic slot) {
    if (child == renderObject.minProtoType) {
      renderObject.minProtoType = null;
    } else if (child == renderObject.maxProtoType) {
      renderObject.maxProtoType = null;
    } else {
      renderObject.child = null;
    }
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    if (child != null) visitor(child!);

    if (_minExtentPrototype != null) visitor(_minExtentPrototype!);

    if (_maxExtentPrototype != null) visitor(_maxExtentPrototype!);
  }
}
