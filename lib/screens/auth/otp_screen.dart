import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../app_theme/app_css.dart';
import '../../utils/config.dart';
import '../../utils/dimensions.dart';
import '../../utils/size.dart';
import '../../widgets/appbar_common.dart';
import '../../widgets/primary_button.dart';
import '../../controllers/auth/otp_verification_controller.dart';
import '../bottom/user_bottom_screen.dart';

class OtpScreen extends StatelessWidget {

  final otpCtrl = Get.put(OtpVerificationController());

  OtpScreen({super.key});

  Future<bool> _onBackPressed() async{
    Get.back();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtpVerificationController>(
      builder: (controller) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              return;
            }
            if (context.mounted) {
              _onBackPressed();
            }
          },
          child: Scaffold(
            backgroundColor: appCtrl.appTheme.cardColor,
            extendBodyBehindAppBar: false,
            appBar: CommonAppbar(
              title: '',
              backEnable: true,
              bgColor: appCtrl.appTheme.cardColor,
              leadingOnTap: _onBackPressed,
            ),
            body: Form(
              key: otpCtrl.otpGlobalKey,
              child: ListView(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.widthSize*1.5,
                    vertical: Dimensions.heightSize
                ),
                children: [
                  Image.asset(assets.loginImagePng,height: 330,),
                  addVerticalSpace(Dimensions.heightSize*1.5),
                  Text('Verify Code',
                      style: AppCss.introHeading.textColor(appCtrl.appTheme.primary)
                  ),
                  Text('We sent the verification code to your phone number',
                      style: AppCss.mulishExtraLight14.textColor(appCtrl.appTheme.secondaryText)),
                  addVerticalSpace(Dimensions.heightSize),
                  PinCodeTextField(
                    cursorColor: appCtrl.appTheme.black,
                    controller: otpCtrl.otpController,
                    appContext: context,
                    length: 6,
                    obscureText: false,
                    enableActiveFill: true,
                    keyboardType: TextInputType.number,
                    textStyle: AppCss.mulishRegular14.textColor(appCtrl.appTheme.primary),
                    animationType: AnimationType.fade,
                    hintStyle: AppCss.mulishLight14.textColor(appCtrl.appTheme.hintColor),
                    autovalidateMode: otpCtrl.autoValidate,
                    errorTextMargin: EdgeInsets.symmetric(horizontal: Dimensions.widthSize,vertical: 0),
                    pinTheme: PinTheme(
                        errorBorderColor: Colors.transparent,
                        activeColor: appCtrl.appTheme.borderColor,
                        inactiveColor: appCtrl.appTheme.borderColor,
                        selectedColor: appCtrl.appTheme.primary,
                        borderRadius: BorderRadius.circular(10.0),
                        shape: PinCodeFieldShape.box,
                        selectedFillColor: Colors.transparent,
                        errorBorderWidth: 1,
                        fieldHeight: 50,
                        fieldWidth: 50,
                        activeFillColor: Colors.transparent,
                        inactiveFillColor: Colors.transparent,
                        borderWidth: 1,
                        fieldOuterPadding: const EdgeInsets.all(1)
                    ),
                    validator: (value) {
                      if(value!.isEmpty || value == '123456')
                      {
                        return 'Invalid OTP' ;
                      }
                      return null;
                    },
                    onChanged: (value) => otpCtrl.onPinChanged(value),
                  ),
                  // addVerticalSpace(Dimensions.heightSize),
                  addVerticalSpace(Dimensions.heightSize*2),
                  PrimaryButtonWidget(
                    isLoading: otpCtrl.isLoading,
                    text: 'Verify',
                    onPressed: () => otpCtrl.verifyVerificationCode(),
                  ),
                  addVerticalSpace(Dimensions.heightSize*2),
                  InkWell(
                    onTap: () => otpCtrl.sendMobileOtp(),
                    child: otpCtrl.timerText != "00:00" ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Resend In ',
                          style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.black),
                          textAlign: TextAlign.center,),
                        addHorizontalSpace(Dimensions.widthSize),
                        Text(
                            controller.timerText,
                            textAlign: TextAlign.center,
                            style: AppCss.mulishSemiBold15.textColor(appCtrl.appTheme.hintColor)
                        ),
                      ],
                    ) : InkWell(
                      onTap: (){
                        otpCtrl.sendMobileOtp();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Didn\'t Received Yet? ',
                            style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.black),
                            textAlign: TextAlign.center,),
                          addHorizontalSpace(Dimensions.widthSize*0.5),
                          Text('Resend',
                            style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.primary),
                            textAlign: TextAlign.center,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
