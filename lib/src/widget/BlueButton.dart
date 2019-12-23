import 'package:flutter/cupertino.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/constant/WayStyles.dart';
import 'package:flutter_waya/src/custom/CustomButton.dart';
import 'package:flutter_waya/src/utils/WayUtils.dart';

class BlueButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;
  final double width;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  BlueButton({
    this.text,
    this.onTap,
    this.width,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      margin: margin,
      padding: padding,
      text: text ?? 'BlueButton',
      onTap: onTap,
      height: WayUtils.getHeight(35),
      width: width ?? WayUtils.getWidth() - WayUtils.getWidth(40),
      decoration: BoxDecoration(
        color: getColors(blue),
        borderRadius: BorderRadius.circular(30),
      ),
      textStyle: WayStyles.textStyleWhite( fontSize: 15),
    );
  }
}
