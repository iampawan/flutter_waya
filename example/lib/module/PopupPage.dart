import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class PopupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Popup Demo'), centerTitle: true),
      body: Universal(children: <Widget>[
        customElasticButton('showBottomPopup', onTap: () => showBottom()),
        customElasticButton('showDialogSureCancel',
            onTap: () => push(widget: ContentPage())),
        customElasticButton('showBottomPagePopup',
            onTap: () => showBottomPage()),
      ]),
    );
  }

  void showBottomPage() {
    showBottomPagePopup<dynamic>(
        widget: CupertinoActionSheet(
      title: const Text('提示'),
      message: const Text('是否要删除当前项？'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Text('删除'),
          onPressed: () => closePopup(),
          isDefaultAction: true,
        ),
        CupertinoActionSheetAction(
          child: const Text('暂时不删'),
          onPressed: () => closePopup(),
          isDestructiveAction: true,
        ),
      ],
    ));
  }

  void showBottom() {
    showBottomPopup<dynamic>(
        widget: CupertinoActionSheet(
      title: const Text('提示'),
      message: const Text('是否要删除当前项？'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Text('删除'),
          onPressed: () => closePopup(),
          isDefaultAction: true,
        ),
        CupertinoActionSheetAction(
          child: const Text('暂时不删'),
          onPressed: () => closePopup(),
          isDestructiveAction: true,
        ),
      ],
    ));
  }
}

class ContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        appBar: AppBar(title: const Text('Content'), centerTitle: true),
        body: Center(
          child: customElasticButton('showDialogSureCancel',
              onTap: () => showDialogSureCancel()),
        ));
  }

  void showDialogSureCancel() {
    const bool isOverlay = true;
    dialogSureCancel<dynamic>(
        isOverlay: isOverlay,
        sure: Text('确定', style: _textStyle()),
        sureTap: () {
          if (isOverlay) {
            closeOverlay();
          } else {
            closePopup();
          }

          ///如果isOverlay=true; 必须先closeOverlay() 再toast或者loading
          showToast('确定');
        },
        cancelTap: () {
          if (isOverlay) {
            closeOverlay();
          } else {
            closePopup();
          }

          ///如果isOverlay=true; 必须先closeOverlay() 再toast或者loading
          showToast('取消');
        },
        cancel: Text('取消', style: _textStyle()),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text(
              '内容',
              style: _textStyle(),
            ),
          ),
        ]);
  }

  TextStyle _textStyle() => const TextStyle(
        color: Colors.blueAccent,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      );
}