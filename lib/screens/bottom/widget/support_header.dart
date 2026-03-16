import 'package:flutter/material.dart';
import 'package:tailoredtiffin/utils/config.dart';

class SupportHeader extends StatelessWidget {
  const SupportHeader({super.key});

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
          child: const Icon(Icons.support_rounded, color: Colors.white, size: 40),
        ),
        addVerticalSpace(Dimensions.heightSize),
        Text("How can we help you?",
            style: AppCss.mulishExtraBold18.textColor(appCtrl.appTheme.textColor)),
        addVerticalSpace(Dimensions.heightSize*0.5),
        Container(
          margin: EdgeInsets.symmetric(horizontal: Dimensions.widthSize*2),
          child: Text(
            "Choose your preferred way to get in touch with our support team",
            textAlign: TextAlign.center,
            style: AppCss.mulishRegular14.textColor(appCtrl.appTheme.hintColor),
          ),
        ),
      ],
    );
  }
}