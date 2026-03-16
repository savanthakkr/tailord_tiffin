import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/utils/config.dart';
import 'package:tailoredtiffin/widgets/rounded_divider.dart';


class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Get.width*0.7,
      backgroundColor: appCtrl.appTheme.primary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize),
        children: [
          addVerticalSpace(kToolbarHeight),
          RoundedDivider(height: 40,width: 5,color: appCtrl.appTheme.white,alignment: Alignment.centerLeft,),
          addVerticalSpace(Dimensions.heightSize*1.5),
          Text('Contact us',
              textAlign: TextAlign.start,
              style: AppCss.mulishSemiBold20.textColor(appCtrl.appTheme.white)),
          addVerticalSpace(Dimensions.heightSize*3),
          _buildItemWidget(
              onTap: (){},
              title: '27 Division St, New York,\nNY 10002, USA',
              svgIcon: assets.mapPinSvg),
          _divider(),
          _buildItemWidget(
              onTap: (){},
              title: 'stephubsale@mail.com\nstephubsupport@mail.com',
              svgIcon: assets.mailSvg),
          _divider(),
          _buildItemWidget(
              onTap: (){},
              title: '+17  123456789 \n+17  987654321',
              svgIcon: assets.phoneCallSvg),
          _divider(),
        ],
      ),
    );
  }

  _buildItemWidget({required GestureTapCallback onTap,
    required String title,
    required String svgIcon}){
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.widthSize*0.5,
          vertical: 0
      ),
      leading: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: appCtrl.appTheme.borderColor)
        ),
        padding: EdgeInsets.all(Dimensions.defaultPaddingSize),
        child: SvgPicture.asset(svgIcon,
          height: 20,width: 20,
          colorFilter: ColorFilter.mode(
             appCtrl.appTheme.white, BlendMode.srcATop),),
      ),
      title: Text(title,
        style: AppCss.mulishRegular14.textColor(
            appCtrl.appTheme.white),),
    );
  }

  _divider()
  {
    return Divider(
      color: appCtrl.appTheme.hintColor,
      thickness: 0.5,
      height: Dimensions.heightSize,
    );
  }
}
