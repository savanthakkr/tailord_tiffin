import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/dimensions.dart';

class RoundedIconWidget extends StatelessWidget {
  final Color color,iconColor,borderColor;
  final String svgAsset;
  final double height;
  final GestureTapCallback? onTap;
  const RoundedIconWidget({
    super.key,
    required this.color,
    required this.iconColor,
    required this.svgAsset,
    this.height = 30,
    this.borderColor = Colors.transparent,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor),
          color: color,
        ),
        padding: EdgeInsets.all(Dimensions.defaultPaddingSize*1.1),
        child: SvgPicture.asset(
          svgAsset,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcATop),),
      ),
    );
  }
}
