import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:tailoredtiffin/widgets/rounded_divider.dart';

import '../utils/config.dart';

class EmptyLayout extends StatelessWidget {
  final String image,title,subtitle,btnText;
  final String? secondaryBtnText;
  final GestureTapCallback? onBtnTap,onSecondaryBtnTap;

  const EmptyLayout({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.btnText,
    this.secondaryBtnText,
    required this.onBtnTap,
    this.onSecondaryBtnTap
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossCenter,
      mainAxisAlignment: mainCenter,
      children: [
        Image.asset(image,height: 150,width: 170,),
        addVerticalSpace(Dimensions.heightSize*0.5),
        RoundedDivider(color: appCtrl.appTheme.primary,height: Dimensions.heightSize*2.5,),
        addVerticalSpace(Dimensions.heightSize),
        Text(title,
          textAlign: TextAlign.center,
          style: AppCss.mulishSemiBold20.textColor(appCtrl.appTheme.primary),),
        Text(subtitle,
          textAlign: TextAlign.center,
          style: AppCss.mulishRegular14.textColor(appCtrl.appTheme.secondaryText),),
        addVerticalSpace(Dimensions.heightSize*1.5),
        PrimaryButtonWidget(
            onPressed: onBtnTap!,
            text: btnText),
        if(onSecondaryBtnTap!=null)
          PrimaryButtonWidget(
              onPressed: onSecondaryBtnTap!,
              text: secondaryBtnText!,
            backgroundColor: appCtrl.appTheme.btnSecondary,
            textColor: appCtrl.appTheme.primary,
          ).marginOnly(top: Dimensions.heightSize*1.5),
      ],
    ).paddingSymmetric(
      horizontal: Dimensions.widthSize*1.5,vertical: Dimensions.heightSize
    );
  }
}
