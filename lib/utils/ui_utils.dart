import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config.dart';

class UIUtils{

  static bottomToast({required String text,required bool isError})
  {
    Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: Dimensions.radius*3,
          margin: EdgeInsets.symmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize),
          backgroundColor: isError ? appCtrl.appTheme.errorColor : appCtrl.appTheme.cardColor,
          messageText: Text(text,
            style: AppCss.mulishMedium14.textColor(
                isError ? appCtrl.appTheme.sameWhite : appCtrl.appTheme.black
            ),
          ),
          snackStyle: SnackStyle.FLOATING,
          duration: const Duration(seconds: 3),
        )
    );
  }

  static showInternetErrorToast()
  {
    Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: appCtrl.appTheme.sameWhite,
          messageText: Text(
            'Please check your internet connection',
            style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.sameBlack),
          ),
          snackStyle: SnackStyle.FLOATING,
          duration: const Duration(seconds: 3),
        )
    );
  }

  static var textInputPadding = const EdgeInsets.symmetric(vertical: 15,horizontal: 10);


  static OutlineInputBorder searchInputBorder = OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(Dimensions.radius*3),
  );

  /*
  static OutlineInputBorder textInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimensions.radius),
      borderSide: const BorderSide(
        color: CustomColor.borderColor,
        width: 1
      )
  );

  static OutlineInputBorder textInputFocusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimensions.radius),
      borderSide: const BorderSide(
        color: CustomColor.primaryColor,
        width: 1,
        style: BorderStyle.solid
      )
  );

  static OutlineInputBorder dropDownBorder = const OutlineInputBorder(
    borderSide: BorderSide(
      color: CustomColor.primaryColor,
      width: 1
    ),
    // borderRadius: BorderRadius.circular(Dimensions.radius),
  );

  static OutlineInputBorder tansparentinputborder = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.transparent,
    ),
    borderRadius: BorderRadius.circular(Dimensions.radius),
  );

  static OutlineInputBorder errorBorder = OutlineInputBorder(
    borderSide: const BorderSide(
      color: CustomColor.errorColor,
    ),
    borderRadius: BorderRadius.circular(Dimensions.radius*3),
  );

  static rounded_decoration({required Color color,required double radius,required Color borderColor})
  {
    return BoxDecoration(
        color: color,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(radius))
    );
  }

  static emptyImageWidget({required double size}){
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Dimensions.radius),
        color: CustomColor.primaryColor.withOpacity(0.2)
      ),
    );
  }

  static notFountText({required String text}){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //not_found.json
          // Lottie.asset('assets/lottie/not_found.json',
          //         height: 200,
          //         width: 200),
          Text(text,
            style: CustomStyle.notFoundTextStyle,),
        ],
      ),
    );
  }
   */
}