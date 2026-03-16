import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/screens/auth/mobile_verify_screen.dart';
import 'package:tailoredtiffin/screens/auth/otp_screen.dart';
import 'package:tailoredtiffin/screens/auth/sign_up_screen.dart';
import 'package:tailoredtiffin/widgets/rounded_divider.dart';
import '../../utils/assets.dart';
import '../../utils/config.dart';
import '../../controllers/auth/login_controller.dart';
import '../../utils/validation_utils.dart';
import '../../widgets/text_field_common.dart';
import '../bottom/user_bottom_screen.dart';

class LoginScreen extends StatelessWidget {
  final loginCtrl = Get.put(LoginController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<LoginController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: appCtrl.appTheme.white,
          extendBodyBehindAppBar: false,
          appBar: null,
          body: Form(
            key: loginCtrl.signInGlobalKey,
            child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.widthSize*1.5,
                  vertical: Dimensions.heightSize
              ),
              children: [
                addVerticalSpace(Dimensions.heightSize*2),
                Image.asset(assets.loginImagePng,height: 350,),
                addVerticalSpace(Dimensions.heightSize*1.5),
                Text("Gujarat's #1 Customized Tiffin Service",
                    textAlign: TextAlign.center,
                    style: AppCss.introHeading.textColor(appCtrl.appTheme.textColor)),
                addVerticalSpace(Dimensions.heightSize),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Divider(color: appCtrl.appTheme.borderColor,thickness: 1)),
                    addHorizontalSpace(Dimensions.widthSize*0.5),
                    Text('Login or Signup',
                      textAlign: TextAlign.center,
                      style: AppCss.mulishExtraLight14.textColor(appCtrl.appTheme.secondaryText),),
                    addHorizontalSpace(Dimensions.widthSize*0.5),
                    Expanded(child: Divider(color: appCtrl.appTheme.borderColor,thickness: 1)),
                  ],
                ),
                addVerticalSpace(Dimensions.heightSize*2),
                inputWidget(),
                // addVerticalSpace(Dimensions.heightSize*1.5),
                // TextFieldCommon(
                //   controller: loginCtrl.passwordController,
                //   labelText: 'password'.toUpperCase(),
                //   hintText: 'Password',
                //   keyboardType: TextInputType.emailAddress,
                //   maxLines: 1,
                //   suffixIcon: InkWell(
                //       onTap: loginCtrl.updateObsecure,
                //       child: Icon(loginCtrl.isObsecure ? Icons.visibility : Icons.visibility_off)),
                //   obscureText: loginCtrl.isObsecure,
                //   validator: (value) => passwordValidator(value),
                // ),
                addVerticalSpace(Dimensions.heightSize*3),
                PrimaryButtonWidget(
                  text: 'Continue',
                  isLoading: loginCtrl.isLoading,
                  onPressed: () => loginCtrl.signInMethod(),
                ),
                addVerticalSpace(Dimensions.heightSize*2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "A taste of home, delivered with",
                      style: AppCss.mulishBold14.textColor(appCtrl.appTheme.textColor),
                    ),
                    addHorizontalSpace(Dimensions.widthSize*0.2),
                    Icon(Icons.favorite_rounded,color: appCtrl.appTheme.errorColor,)
                  ],
                ),
                // InkWell(
                //   onTap: (){
                //     Get.to(() => SignUpScreen());
                //   },
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text('Don\'t have an account? ',
                //         style: AppCss.mulishExtraLight14.textColor(appCtrl.appTheme.secondaryText),
                //         textAlign: TextAlign.center,),
                //       addHorizontalSpace(Dimensions.widthSize*0.5),
                //       Text('Sign up',
                //         style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.primary),
                //         textAlign: TextAlign.center,),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
          // bottomNavigationBar:  Container(
          //   margin: EdgeInsets.symmetric(
          //     horizontal: Dimensions.widthSize,
          //     vertical: Dimensions.heightSize
          //   ),
          //   child: ,
          // ),
        );
      },
    );
  }

  _countryPicker(){
    return CountryCodePicker(
      onChanged: loginCtrl.onCountryChanged,
      onInit: loginCtrl.onCountryInit,
      textStyle: AppCss.mulishMedium14.textColor(appCtrl.appTheme.black),
      padding: const EdgeInsets.all(0),
      showFlag: true,
      enabled: false,
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
      controller: loginCtrl.phoneController,
      keyboardType: TextInputType.phone,
      cursorColor: appCtrl.appTheme.black,
      maxLength: 10,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius),
          borderSide: BorderSide(
            color: appCtrl.appTheme.borderColor,
            width: 1,
          )
        ),
        contentPadding: EdgeInsets.zero,
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius),
            borderSide: BorderSide(
              color: appCtrl.appTheme.errorColor,
              width: 1,
            )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius),
            borderSide: BorderSide(
              color: appCtrl.appTheme.borderColor,
              width: 1,
            )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius),
            borderSide: BorderSide(
              color: appCtrl.appTheme.primary,
              width: 1,
            )
        ),
        errorStyle: AppCss.mulishRegular12.textColor(appCtrl.appTheme.errorColor),
        counterText: '',
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 6),
          child: Text(
            "+91",
            style: AppCss.mulishBold14.textColor(appCtrl.appTheme.textColor),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        hintText: 'Enter phone number',
        hintStyle: AppCss.mulishLight14.textColor(appCtrl.appTheme.hintColor),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      style: AppCss.mulishRegular14.textColor(appCtrl.appTheme.textColor),
      textAlign: TextAlign.start,
      autovalidateMode: loginCtrl.autoValidate,
      validator: (value) {
        if (value != null && !GetUtils.isPhoneNumber(value)) {
          return 'Invalid mobile number';
        }
        // else if(!loginCtrl.isNumberExist)
        // {
        //   return 'Mobile no. not registered';
        // }
        return null;
      },
    );
  }

  inputWidget() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: appCtrl.appTheme.borderColor),
            borderRadius: BorderRadius.circular(Dimensions.radius),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.widthSize,
              vertical: Dimensions.heightSize*0.5
          ),
          child: Image.asset(assets.flagePng,height: 30,width: 30,),
        ),
        addHorizontalSpace(Dimensions.widthSize),
        Expanded(
          child: _phoneTextField(),
        )

        // Container(
        //   margin: EdgeInsets.only(top: Dimensions.heightSize*0.7),
        //   decoration: BoxDecoration(
        //     border: Border.all(color: appCtrl.appTheme.borderColor),
        //     borderRadius: BorderRadius.circular(Dimensions.radius),
        //   ),
        //   padding: EdgeInsets.symmetric(
        //       horizontal: Dimensions.widthSize,
        //       vertical: Dimensions.heightSize*0.2
        //   ),
        //   child:
        // ),
      ],
    );
  }
}
