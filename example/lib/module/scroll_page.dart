import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

final List<Color> _colors = <Color>[
  ...Colors.accents,
  ...Colors.primaries,
];

class ScrollViewPage extends StatelessWidget {
  const ScrollViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('ScrollView'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          ElevatedText('ExtendedScrollView',
              onTap: () => push(_ExtendedScrollViewPage(slivers))),
          ElevatedText('ExtendedScrollView.nested',
              onTap: () => push(_ExtendedScrollViewNestedPage(slivers))),
          const SizedBox(height: 40),
          ElevatedText('CustomScrollView',
              onTap: () => push(const _CustomScrollViewPage())),
          ElevatedText('RefreshScrollView',
              onTap: () => push(const _RefreshScrollViewPage())),
          ElevatedText('DraggableScrollbar',
              onTap: () => push(_DraggableScrollbar(scrollController))),
          ElevatedText('ScrollList',
              onTap: () => push(_ScrollListPage(scrollController))),
          ElevatedText('ScrollList.builder',
              onTap: () => push(_ScrollListBuilderPage(scrollController))),
          ElevatedText('ScrollList.separated',
              onTap: () => push(_ScrollListSeparatedPage(scrollController))),
          ElevatedText('ScrollList.waterfallFlow',
              onTap: () =>
                  push(_ScrollListWaterfallFlowPage(scrollController))),
          ElevatedText('ScrollList.count',
              onTap: () => push(_ScrollListCountPage(scrollController))),
          ElevatedText('ScrollList.placeholder',
              onTap: () => push(_ScrollListPlaceholderPage(scrollController))),
        ]);
  }

  List<Widget> get slivers => <Widget>[
        ExtendedSliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            backgroundColor: Colors.transparent,
            flexibleSpaceTitle:
                const Text('title', style: TextStyle(color: Colors.black)),
            background:
                Container(height: kToolbarHeight * 2, color: _colors[0])),
        ExtendedSliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            backgroundColor: _colors[3],
            flexibleSpaceTitle:
                const Text('第二个Title', style: TextStyle(color: Colors.black)),
            background: Container(height: kToolbarHeight, color: _colors[7])),
        ExtendedSliverPersistentHeader(
            pinned: true,
            floating: false,
            child: Container(
                color: _colors[9],
                alignment: Alignment.center,
                child: const Text('ExtendedSliverPersistentHeader'))),
        ExtendedSliverPersistentHeader(
            pinned: true,
            floating: false,
            child: Container(
                color: _colors[13],
                alignment: Alignment.center,
                child: const Text('ExtendedSliverPersistentHeader'))),
      ];
}

class _ScrollListWaterfallFlowPage extends StatelessWidget {
  const _ScrollListWaterfallFlowPage(this.scrollController, {Key? key})
      : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollList.waterfall'),
        body: ScrollList.waterfall(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          maxCrossAxisExtent: 100,
          header: SliverToBoxAdapter(
              child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 100,
            alignment: Alignment.center,
            child: const Text('Header'),
            color: Colors.grey.withOpacity(0.3),
          )),
          footer: SliverToBoxAdapter(
              child: Container(
            margin: const EdgeInsets.only(top: 10),
            height: 100,
            alignment: Alignment.center,
            child: const Text('Footer'),
            color: Colors.grey.withOpacity(0.3),
          )),
          padding: const EdgeInsets.all(10),
          refreshConfig: RefreshConfig(onRefresh: () async {
            await showToast('onRefresh');
            await 2.seconds.delayed(() {
              sendRefreshType(EasyRefreshType.refreshSuccess);
            });
          }, onLoading: () async {
            await showToast('onLoading');
            await 2.seconds.delayed(() {
              sendRefreshType(EasyRefreshType.loadingSuccess);
            });
          }),
          itemCount: [..._colors, ..._colors, ..._colors].length,
          itemBuilder: (_, int index) => _Item(
              index, [..._colors, ..._colors, ..._colors][index],
              height: index.isEven ? 100 : 70, width: index.isEven ? 50 : 100),
        ));
  }
}

class _ScrollListSeparatedPage extends StatelessWidget {
  const _ScrollListSeparatedPage(this.scrollController, {Key? key})
      : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollList.separated'),
        body: ScrollList.separated(
          header: SliverToBoxAdapter(
              child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 100,
            alignment: Alignment.center,
            child: const Text('Header'),
            color: Colors.grey.withOpacity(0.3),
          )),
          footer: SliverToBoxAdapter(
              child: Container(
            margin: const EdgeInsets.only(top: 10),
            height: 100,
            alignment: Alignment.center,
            child: const Text('Footer'),
            color: Colors.grey.withOpacity(0.3),
          )),
          padding: const EdgeInsets.all(10),
          refreshConfig: RefreshConfig(
            onRefresh: () async {
              await showToast('onRefresh');
              await 2.seconds.delayed(() {
                sendRefreshType(EasyRefreshType.refreshSuccess);
              });
            },
            onLoading: () async {
              await showToast('onLoading');
              await 2.seconds.delayed(() {
                sendRefreshType(EasyRefreshType.loadingSuccess);
              });
            },
          ),
          itemCount: _colors.length,
          itemBuilder: (_, int index) =>
              _Item(index, _colors[index]).paddingSymmetric(vertical: 5),
          separatorBuilder: (_, int index) =>
              const Divider(color: Colors.black, height: 4),
        ));
  }
}

class _ScrollListPlaceholderPage extends StatelessWidget {
  const _ScrollListPlaceholderPage(this.scrollController, {Key? key})
      : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollList.builder'),
        body: ScrollList.builder(
            header: SliverToBoxAdapter(
                child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 100,
              alignment: Alignment.center,
              child: const Text('Header'),
              color: Colors.grey.withOpacity(0.3),
            )),
            footer: SliverToBoxAdapter(
                child: Container(
              margin: const EdgeInsets.only(top: 10),
              height: 100,
              alignment: Alignment.center,
              child: const Text('Footer'),
              color: Colors.grey.withOpacity(0.3),
            )),
            padding: const EdgeInsets.all(10),
            refreshConfig: RefreshConfig(onRefresh: () async {
              await showToast('onRefresh');
              await 2.seconds.delayed(() {
                sendRefreshType(EasyRefreshType.refreshSuccess);
              });
            }, onLoading: () async {
              await showToast('onLoading');
              await 2.seconds.delayed(() {
                sendRefreshType(EasyRefreshType.loadingSuccess);
              });
            }),
            placeholder: const BText('没有数据', color: Colors.white).container(
                alignment: Alignment.center,
                color: _colors[14],
                padding: const EdgeInsets.symmetric(vertical: 10)),
            itemCount: 0,
            itemBuilder: (_, int index) =>
                _Item(index, _colors[index]).paddingOnly(bottom: 10)));
  }
}

class _ScrollListBuilderPage extends StatelessWidget {
  const _ScrollListBuilderPage(this.scrollController, {Key? key})
      : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollList.builder'),
        body: Column(children: <Widget>[
          Container(
              height: 100,
              color: context.theme.primaryColor,
              alignment: Alignment.center,
              child: const BText('这里是头部',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          ScrollList.builder(
                  header: SliverToBoxAdapter(
                      child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 100,
                    alignment: Alignment.center,
                    child: const Text('Header'),
                    color: Colors.grey.withOpacity(0.3),
                  )),
                  footer: SliverToBoxAdapter(
                      child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 100,
                    alignment: Alignment.center,
                    child: const Text('Footer'),
                    color: Colors.grey.withOpacity(0.3),
                  )),
                  padding: const EdgeInsets.all(10),
                  refreshConfig: RefreshConfig(
                    onRefresh: () async {
                      showToast('onRefresh');
                      2.seconds.delayed(() {
                        sendRefreshType(EasyRefreshType.refreshSuccess);
                      });
                    },
                    onLoading: () async {
                      showToast('onLoading');
                      2.seconds.delayed(() {
                        sendRefreshType(EasyRefreshType.loadingSuccess);
                      });
                    },
                  ),
                  itemCount: _colors.length,
                  itemBuilder: (_, int index) =>
                      _Item(index, _colors[index]).paddingOnly(bottom: 10))
              .expandedNull,
        ]));
  }
}

class _ScrollListPage extends StatelessWidget {
  const _ScrollListPage(this.scrollController, {Key? key}) : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollList'),
        body: ScrollList(
            padding: const EdgeInsets.all(10),
            header: SliverToBoxAdapter(
                child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 100,
              alignment: Alignment.center,
              child: const Text('Header'),
              color: Colors.grey.withOpacity(0.3),
            )),
            footer: SliverToBoxAdapter(
                child: Container(
              margin: const EdgeInsets.only(top: 10),
              height: 100,
              alignment: Alignment.center,
              child: const Text('Footer'),
              color: Colors.grey.withOpacity(0.3),
            )),
            refreshConfig: RefreshConfig(
              onRefresh: () async {
                showToast('onRefresh');
                2.seconds.delayed(() {
                  sendRefreshType(EasyRefreshType.refreshSuccess);
                });
              },
              onLoading: () async {
                showToast('onLoading');
                2.seconds.delayed(() {
                  sendRefreshType(EasyRefreshType.loadingSuccess);
                });
              },
            ),
            sliver: <Widget>[
              SliverToBoxAdapter(
                  child: Container(
                      child: const BText('SliverListGrid builder',
                          color: Colors.white),
                      alignment: Alignment.center,
                      color: _colors[14],
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10))),
              SliverListGrid(
                  itemCount: _colors.length,
                  itemBuilder: (_, int index) =>
                      _Item(index, _colors[index]).paddingOnly(bottom: 10)),
              SliverToBoxAdapter(
                  child: Container(
                      child: const BText('SliverWaterfallFlow.aligned',
                          color: Colors.white),
                      alignment: Alignment.center,
                      color: _colors[14],
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10))),
              SliverWaterfallFlow.aligned(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemCount: _colors.length,
                  itemBuilder: (_, int index) => _Item(index, _colors[index],
                      height: index & 3 == 0 ? 200 : 40)),
              SliverToBoxAdapter(
                  child: Container(
                      child: const BText('SliverListGrid Grid Builder',
                          color: Colors.white),
                      alignment: Alignment.center,
                      color: _colors[14],
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10))),
              SliverListGrid(
                  itemCount: _colors.length,
                  crossAxisFlex: true,
                  maxCrossAxisExtent: 100,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemBuilder: (_, int index) =>
                      _Item(index, _colors[index]).paddingOnly(bottom: 10)),
              SliverToBoxAdapter(
                  child: Container(
                      child: const BText('SliverListGrid Grid Builder',
                          color: Colors.white),
                      alignment: Alignment.center,
                      color: _colors[14],
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10))),
              SliverListGrid(
                  itemCount: _colors.length,
                  crossAxisCount: 6,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemBuilder: (_, int index) =>
                      _Item(index, _colors[index]).paddingOnly(bottom: 10)),
              SliverToBoxAdapter(
                  child: Container(
                      child: const BText('SliverListGrid separatorBuilder',
                          color: Colors.white),
                      alignment: Alignment.center,
                      color: _colors[14],
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10))),
              SliverListGrid(
                  itemCount: _colors.length,
                  separatorBuilder: (_, int index) =>
                      Divider(color: _colors[index]),
                  itemBuilder: (_, int index) => _Item(index, _colors[index])),
              SliverToBoxAdapter(
                  child: Container(
                      child: const BText('SliverWaterfallFlow Children',
                          color: Colors.white),
                      alignment: Alignment.center,
                      color: _colors[14],
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10))),
              SliverWaterfallFlow.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: _colors.builderEntry((entry) => _Item(
                      entry.key, entry.value,
                      height: entry.key.isEven ? 100 : 70,
                      width: entry.key.isEven ? 50 : 100))),
              SliverToBoxAdapter(
                  child: Container(
                      child: const BText('SliverWaterfallFlow Builder',
                          color: Colors.white),
                      alignment: Alignment.center,
                      color: _colors[14],
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10))),
              SliverWaterfallFlow(
                  crossAxisCount: 5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemCount: _colors.length,
                  itemBuilder: (_, int index) => _Item(index, _colors[index],
                      height: index.isEven ? 100 : 70,
                      width: index.isEven ? 50 : 100)),
            ]));
  }
}

class _ScrollListCountPage extends StatelessWidget {
  const _ScrollListCountPage(this.scrollController, {Key? key})
      : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollList.count'),
        body: ScrollList.count(
            header: SliverToBoxAdapter(
                child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 100,
              alignment: Alignment.center,
              child: const Text('Header'),
              color: Colors.grey.withOpacity(0.3),
            )),
            footer: SliverToBoxAdapter(
                child: Container(
              margin: const EdgeInsets.only(top: 10),
              height: 100,
              alignment: Alignment.center,
              child: const Text('Footer'),
              color: Colors.grey.withOpacity(0.3),
            )),
            padding: const EdgeInsets.all(10),
            refreshConfig: RefreshConfig(onRefresh: () async {
              await showToast('onRefresh');
              await 2.seconds.delayed(() {
                sendRefreshType(EasyRefreshType.refreshSuccess);
              });
            }, onLoading: () async {
              await showToast('onLoading');
              await 2.seconds.delayed(() {
                sendRefreshType(EasyRefreshType.loadingSuccess);
              });
            }),
            children: _colors.builderEntry((MapEntry<int, Color> entry) =>
                _Item(entry.key, entry.value))));
  }
}

class _RefreshScrollViewPage extends StatelessWidget {
  const _RefreshScrollViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          body: RefreshScrollView(
              padding: const EdgeInsets.all(10),
              refreshConfig: RefreshConfig(onRefresh: () async {
                await showToast('onRefresh');
                sendRefreshType(EasyRefreshType.refreshSuccess);
              }, onLoading: () async {
                await showToast('onLoading');
                await 2.seconds.delayed(() {
                  sendRefreshType(EasyRefreshType.loadingSuccess);
                });
              }),
              slivers: <Widget>[
            const SliverAppBar(
                title: BText('RefreshScrollView', color: Colors.white)),
            SliverListGrid(
                itemCount: _colors.length,
                crossAxisFlex: true,
                maxCrossAxisExtent: 30,
                separatorBuilder: (_, int index) {
                  return Text('s' + index.toString());
                },
                itemBuilder: (_, int index) {
                  return _Item(index, _colors[index]);
                }),
            SliverListGrid.count(
                crossAxisCount: 6,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: _colors.builderEntry((MapEntry<int, Color> entry) =>
                    _Item(entry.key, entry.value))),
          ]));
}

class _CustomScrollViewPage extends StatelessWidget {
  const _CustomScrollViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          body: CustomScrollView(slivers: <Widget>[
        const CustomSliverAppBar(
            title: BText('CustomScrollViewPage', color: Colors.white)),
        SliverPinnedToBoxAdapter(
            child: Column(
                children: 4.generate((int index) =>
                    Text('SliverPinnedToBoxAdapter -- $index')))),
        SliverList(
            delegate: SliverChildListDelegate(_colors.builderEntry(
                (MapEntry<int, Color> entry) => _Item(entry.key, entry.value))))
      ]));
}

class _ExtendedScrollViewNestedPage extends StatelessWidget {
  const _ExtendedScrollViewNestedPage(this.slivers, {Key? key})
      : super(key: key);

  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          body: RefreshIndicator(
        notificationPredicate: (ScrollNotification notification) {
          /// 返回true即可
          return true;
        },
        onRefresh: () async {
          /// 模拟网络请求
          await Future<dynamic>.delayed(const Duration(seconds: 4));

          /// 结束刷新
          return Future<dynamic>.value(true);
        },
        child: ExtendedScrollView.nested(
            slivers: slivers,
            body: Universal(
                isScroll: true,
                color: Colors.yellow,
                children: List<Widget>.generate(
                    100, (int index) => Text(index.toString())))),
      ));
}

class _ExtendedScrollViewPage extends StatelessWidget {
  const _ExtendedScrollViewPage(this.slivers, {Key? key}) : super(key: key);

  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          body: ExtendedScrollView(slivers: <Widget>[
        ...slivers,
        SliverToBoxAdapter(
            child: Universal(
                color: Colors.yellow,
                children: List<Widget>.generate(
                    100, (int index) => Text(index.toString()))))
      ]));
}

class _Item extends StatelessWidget {
  const _Item(this.index, this.color, {this.height = 80, this.width = 80});

  final int index;
  final Color color;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) =>
      Container(width: width, height: height, color: color);
}

class _DraggableScrollbar extends StatelessWidget {
  const _DraggableScrollbar(this.scrollController, {Key? key})
      : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final ScrollList list = ScrollList.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(10),
        itemCount: _colors.length,
        itemBuilder: (_, int index) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            color: _colors[index],
            width: double.infinity,
            height: 40));

    Widget scrollbar = DraggableScrollbar(
        controller: scrollController,
        child: list,
        backgroundColor: context.theme.dialogBackgroundColor,
        scrollbarStyle: ScrollbarStyle.semicircle);
    // scrollbar = DraggableScrollbar(
    //     controller: scrollController,
    //     child: list,
    //     backgroundColor: context.theme.dialogBackgroundColor,
    //     scrollbarStyle: ScrollbarStyle.rect);
    // scrollbar = DraggableScrollbar(
    //     controller: scrollController,
    //     child: list,
    //     backgroundColor: context.theme.dialogBackgroundColor,
    //     scrollbarStyle: ScrollbarStyle.arrows);

    return ExtendedScaffold(
        appBar: AppBarText('DraggableScrollbar'), body: scrollbar);
  }
}
