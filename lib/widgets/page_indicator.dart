import 'package:flutter/material.dart';

import '../utils/config.dart';

class PageIndicator extends StatelessWidget {
  final bool isActive;
  const PageIndicator({
    super.key,
    required this.isActive
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        height: 8,
        width: 20,
        decoration: BoxDecoration(
          // boxShadow: [
          //   isActive
          //       ? BoxShadow(
          //     color: appCtrl.appTheme.primary,
          //     blurRadius: 4.0,
          //     spreadRadius: 1.0,
          //     offset: const Offset(
          //       0.0,
          //       0.0,
          //     ),
          //   )
          //       : const BoxShadow(
          //     color: Colors.transparent,
          //   ),
          // ],
          borderRadius: BorderRadius.circular(18.0),
          shape: BoxShape.rectangle,
          color: isActive ? appCtrl.appTheme.primary : appCtrl.appTheme.hintColor,
        ),
      ),
    );
  }
}
