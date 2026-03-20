import 'package:flutter/material.dart';
import 'package:tailoredtiffin/screens/bottom/widget/premium_body.dart';
import 'package:tailoredtiffin/screens/bottom/widget/premium_header.dart';

import '../../utils/config.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [appCtrl.appTheme.deliveryBg, appCtrl.appTheme.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              addVerticalSpace(Dimensions.heightSize*2),
              const PremiumHeader(),
              addVerticalSpace(Dimensions.heightSize*0.5),
              const Expanded(
                child: PremiumBody(),
              ),
              addVerticalSpace(Dimensions.heightSize*0.5),
              Container(
                decoration: BoxDecoration(
                  color: appCtrl.appTheme.white
                ),
                child: Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius*1.5),
                    gradient: LinearGradient(
                      begin: AlignmentGeometry.topCenter,
                      end: AlignmentGeometry.bottomCenter,
                      colors: [
                        appCtrl.appTheme.primary,
                        appCtrl.appTheme.primary.withOpacity(0.75)
                      ]
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_rounded,color: appCtrl.appTheme.white,),
                      addHorizontalSpace(Dimensions.widthSize*1.5),
                      Text(
                        "Subscribe Now - \u20b9 99/month",
                        style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.white),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
