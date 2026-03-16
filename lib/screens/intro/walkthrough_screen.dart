import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/screens/intro/walkthrough_controller.dart';

import '../../utils/config.dart';
import '../../widgets/page_indicator.dart';
import '../auth/login_screen.dart';


class WalkthroughScreen extends StatefulWidget {
  const WalkthroughScreen({super.key});

  @override
  State<WalkthroughScreen> createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  var introCtrl = Get.put(WalkthroughController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<WalkthroughController>(
        builder: (ctrl) {
          return Scaffold(
            backgroundColor: appCtrl.appTheme.cardColor,
            body: Stack(
              children: [
                PageView(
                  controller: introCtrl.pageController,
                  onPageChanged: introCtrl.onPageChanged,
                  children: [
                    for(int i=0; i < introCtrl.contents.length ; i++)
                      _buildIconView(
                          title: introCtrl.contents[i]['title'],
                          subtitle: introCtrl.contents[i]['subtitle'],
                          pngIcon: introCtrl.contents[i]['image'])
                  ],
                ),
                Positioned(
                  left: Dimensions.marginSize,
                  right: introCtrl.mWidth*0.07,
                  top: introCtrl.mHeight*0.3,
                    child: Row(
                      mainAxisAlignment: mainSpaceBet,
                      crossAxisAlignment: crossEnd,
                      children: [
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (int i = 0; i < introCtrl.contents.length; i++)
                                  PageIndicator(
                                    isActive: i == introCtrl.currentIndex,
                                  )
                              ],
                            )
                        ),
                      ],
                    )
                ),
                Positioned(
                    left: Dimensions.widthSize,
                    right: Dimensions.widthSize,
                    bottom: introCtrl.mHeight*0.01,
                    child: PrimaryButtonWidget(
                        onPressed: () => introCtrl.btnOnClickMethod(),
                        text: 'Get Started')
                )
              ],
            ),
          );
        }
      ),
    );
  }

  _buildIconView({required String title,required String subtitle,required String pngIcon})
  {
    return SizedBox(
      height: introCtrl.mHeight,
      width: introCtrl.mWidth,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.marginSize,
          vertical: Dimensions.heightSize
        ),
        child: Column(
          crossAxisAlignment: crossStretch,
          children: [
            addVerticalSpace(Dimensions.heightSize*3),
            Text(title,
              textAlign: TextAlign.start,
              style: AppCss.introHeading.textColor(appCtrl.appTheme.primary),),
            addVerticalSpace(Dimensions.heightSize),
            Text(subtitle,
              textAlign: TextAlign.start,
              style: AppCss.introText.textColor(appCtrl.appTheme.secondaryText),),
            Spacer(),
            Image.asset(pngIcon,height: introCtrl.mHeight*0.4,),
          ],
        ),
      ),
    );
  }

}
