part of 'picker.dart';

/// 单列选择
class SingleColumnPicker extends StatelessWidget {
  SingleColumnPicker({
    super.key,
    int initialIndex = 0,
    required this.itemCount,
    required this.itemBuilder,
    PickerOptions<int>? options,
    this.wheelOptions,
    FixedExtentScrollController? controller,
  })  : controller = controller ??
            FixedExtentScrollController(initialItem: initialIndex),
        options = options ?? PickerOptions<int>();

  /// 头部和背景色配置
  final PickerOptions<int> options;

  /// Wheel配置信息
  final PickerWheelOptions? wheelOptions;

  /// 渲染子组件
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// 控制器
  final FixedExtentScrollController? controller;

  @override
  Widget build(BuildContext context) => PickerSubject<int>(
      options: options,
      child: SizedBox(
          width: double.infinity,
          height: kPickerDefaultHeight,
          child: _PickerListWheel(
              wheel: wheelOptions ?? GlobalOptions().pickerWheelOptions,
              controller: controller,
              itemBuilder: itemBuilder,
              itemCount: itemCount)),
      confirmTap: () => controller?.selectedItem ?? 0);
}

/// list 单多项选择器
class SingleListPicker extends StatelessWidget {
  SingleListPicker({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    PickerOptions<List<int>>? options,
    this.singleListPickerOptions = const SingleListPickerOptions(),
    this.listBuilder,
  }) : options = options ?? PickerOptions<List<int>>();

  /// 头部和背景色配置
  final PickerOptions<List<int>> options;

  /// 渲染子组件
  final int itemCount;
  final SelectIndexedWidgetBuilder itemBuilder;

  /// 可选配置项
  final SingleListPickerOptions singleListPickerOptions;

  /// 自定义渲染 list
  final SelectScrollListBuilder? listBuilder;

  @override
  Widget build(BuildContext context) {
    List<int> selectIndex = [];
    return PickerSubject<List<int>>(
        options: options,
        child: _SingleListPickerContent(
                listBuilder: listBuilder,
                singleListPickerOptions: singleListPickerOptions,
                onChanged: (List<int> index) {
                  selectIndex = index;
                },
                itemBuilder: itemBuilder,
                itemCount: itemCount)
            .expandedNull,
        confirmTap: () => selectIndex);
  }
}

class SingleListPickerOptions {
  const SingleListPickerOptions(
      {this.isCustomGestureTap = false, this.allowedMultipleChoice = true});

  final bool isCustomGestureTap;
  final bool allowedMultipleChoice;
}

typedef SelectIndexedWidgetBuilder = Widget Function(BuildContext context,
    int index, bool isSelect, SelectIndexedChangedFunction changeFunc);

typedef SelectIndexedChangedFunction = void Function([int? index]);

typedef SelectIndexedChanged = void Function(List<int> index);

typedef SelectScrollListBuilder = Widget Function(
    int itemCount, IndexedWidgetBuilder itemBuilder);

class _SingleListPickerContent extends StatefulWidget {
  const _SingleListPickerContent(
      {required this.itemCount,
      required this.itemBuilder,
      required this.onChanged,
      required this.singleListPickerOptions,
      this.listBuilder});

  final int itemCount;
  final SelectIndexedWidgetBuilder itemBuilder;
  final SelectIndexedChanged onChanged;
  final SelectScrollListBuilder? listBuilder;
  final SingleListPickerOptions singleListPickerOptions;

  @override
  State<_SingleListPickerContent> createState() =>
      _SingleListPickerContentState();
}

class _SingleListPickerContentState extends State<_SingleListPickerContent> {
  List<int> selectIndex = [];

  void changeSelect([int? index]) {
    if (index != null) {
      if (widget.singleListPickerOptions.allowedMultipleChoice) {
        if (selectIndex.contains(index)) {
          selectIndex.remove(index);
        } else {
          selectIndex.add(index);
        }
      } else {
        selectIndex = [index];
      }
      widget.onChanged(selectIndex);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget itemBuilder(_, int index) {
      final entry = widget.itemBuilder(
          context, index, selectIndex.contains(index), changeSelect);
      if (widget.singleListPickerOptions.isCustomGestureTap) return entry;
      return Universal(onTap: () => changeSelect(index), child: entry);
    }

    if (widget.listBuilder != null) {
      return widget.listBuilder!.call(widget.itemCount, itemBuilder);
    }
    return ScrollList.builder(
        itemBuilder: itemBuilder, itemCount: widget.itemCount);
  }
}
