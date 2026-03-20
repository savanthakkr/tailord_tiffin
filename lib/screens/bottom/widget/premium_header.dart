import 'package:flutter/material.dart';

import '../../../utils/config.dart';

class PremiumHeader extends StatelessWidget {
  const PremiumHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: appCtrl.appTheme.primary,
          ),
          child: const Icon(Icons.verified_rounded, color: Colors.white, size: 40),
        ),
        addVerticalSpace(Dimensions.heightSize),
        Text("Be Our Verified User",
            style: AppCss.mulishExtraBold18.textColor(appCtrl.appTheme.textColor)),
        addVerticalSpace(Dimensions.heightSize*0.5),
        Container(
          margin: EdgeInsets.symmetric(horizontal: Dimensions.widthSize*2),
          child: Text(
            "Unlock premium benefits and enjoy a superior dining experience",
            textAlign: TextAlign.center,
            style: AppCss.mulishRegular14.textColor(appCtrl.appTheme.hintColor),
          ),
        ),
      ],
    );
  }
}
