import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailoredtiffin/utils/config.dart';

class RoundedDivider extends StatelessWidget {
  final double height;
  final double width;
  final Color? color;
  final Alignment alignment;

  const RoundedDivider({
    super.key,
    this.height = 10,
    this.width = 5,
    this.color,
    this.alignment = Alignment.center
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
            color: color ?? appCtrl.appTheme.primary,
            borderRadius: BorderRadius.circular(Dimensions.radius)
        ),
        height: height,
        width: width,
      ),
    );
  }
}
