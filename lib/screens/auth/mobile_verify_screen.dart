import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:tailoredtiffin/controllers/auth/mobile_verify_controller.dart';
import 'package:get/get.dart';

import '../../utils/config.dart';
import '../../widgets/appbar_common.dart';
import '../../widgets/rounded_divider.dart';

class MobileVerifyScreen extends StatelessWidget {
  final mobileCtrl = Get.put(MobileVerifyController());

  MobileVerifyScreen({super.key});

  Future<bool> _onBackPressed() async{
    Get.back();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MobileVerifyController>(
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
              backgroundColor: appCtrl.appTheme.white,
              extendBodyBehindAppBar: false,
              appBar: CommonAppbar(
                title: '',
                backEnable: true,
                bgColor: appCtrl.appTheme.white,
                leadingOnTap: _onBackPressed,
              ),
              body: Form(
                key: mobileCtrl.mobileVerifyGlobalKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.widthSize*1.2,
                      vertical: Dimensions.heightSize
                  ),
                  children: [
                    Text('Forgot Password',
                        style: AppCss.introHeading.textColor(appCtrl.appTheme.primary)
                    ),
                    Text('Enter your registered mobile number to receive an OTP for password reset.',
                        style: AppCss.mulishExtraLight14.textColor(appCtrl.appTheme.secondaryText)),
                    addVerticalSpace(Dimensions.heightSize),
                    inputWidget(),
                    addVerticalSpace(Dimensions.heightSize*3),
                    PrimaryButtonWidget(
                      text: 'Send OTP',
                      isLoading: mobileCtrl.isLoading,
                      onPressed: () => mobileCtrl.checkMobileExistApi(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  inputWidget() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: Dimensions.heightSize*0.6),
          decoration: BoxDecoration(
            border: Border.all(color: appCtrl.appTheme.borderColor),
            borderRadius: BorderRadius.circular(Dimensions.radius),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.widthSize,
              vertical: Dimensions.heightSize*0.2
          ),
          child: Row(
            crossAxisAlignment: crossCenter,
            children: [
              _countryPicker(),
              addHorizontalSpace(Dimensions.widthSize*0.5),
              RoundedDivider(width: 2,height: 30,color: appCtrl.appTheme.primaryYellow,),
              addHorizontalSpace(Dimensions.widthSize*0.5),
              Expanded(
                flex: 7,
                child: _phoneTextField(),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: Dimensions.widthSize*0.5,
          child: Container(
            color: appCtrl.appTheme.white,
            padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize*0.2),
            child: Text('Phone number'.toUpperCase(),
              style: AppCss.mulishSemiBold10.textColor(appCtrl.appTheme.secondaryText),),
          ),
        )
      ],
    );
  }

  _countryPicker(){
    return CountryCodePicker(
      onChanged: mobileCtrl.onCountryChanged,
      onInit: mobileCtrl.onCountryInit,
      textStyle: AppCss.mulishMedium14.textColor(appCtrl.appTheme.black),
      padding: const EdgeInsets.all(0),
      showFlag: true,
      initialSelection: '+91',
      showCountryOnly: true,
      showOnlyCountryWhenClosed: false,
      showFlagMain: true,
      alignLeft: false,
      dialogBackgroundColor: appCtrl.appTheme.white,
      // backgroundColor: appCtrl.appTheme.white,
      dialogTextStyle: AppCss.mulishMedium12.textColor(appCtrl.appTheme.secondaryText),
      headerTextStyle: AppCss.mulishSemiBold15.textColor(appCtrl.appTheme.black),

    );
  }

  _phoneTextField() {
    return TextFormField(
      controller: mobileCtrl.phoneController,
      keyboardType: TextInputType.phone,
      cursorColor: appCtrl.appTheme.black,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        errorBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorStyle: AppCss.mulishRegular12.textColor(appCtrl.appTheme.errorColor),
        counterText: '',
        hintText: 'Enter Mobile No.',
        hintStyle: AppCss.mulishLight14.textColor(appCtrl.appTheme.hintColor),
      ),
      style: AppCss.mulishRegular14.textColor(appCtrl.appTheme.primary),
      textAlign: TextAlign.start,
      autovalidateMode: mobileCtrl.autoValidate,
      validator: (value) {
        if (value != null && !GetUtils.isPhoneNumber(value)) {
          return 'Invalid mobile number';
        }
        return null;
      },
    );
  }
}
