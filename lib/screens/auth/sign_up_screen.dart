import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/screens/auth/login_screen.dart';
import 'package:tailoredtiffin/controllers/auth/sign_up_controller.dart';
import 'package:tailoredtiffin/utils/validation_utils.dart';
import 'package:tailoredtiffin/widgets/rounded_divider.dart';
import 'package:tailoredtiffin/widgets/text_field_common.dart';
import '../../utils/config.dart';
import '../../controllers/auth/login_controller.dart';

class SignUpScreen extends StatelessWidget {
  final regCtrl = Get.put(SignUpController());

  SignUpScreen({super.key});

  Future<bool> _onBackPressed() async{
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    Get.back();
    return false;
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<SignUpController>(
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
              bgColor: appCtrl.appTheme.white,
              backEnable: true,
              centerTitle: true,
              textColor: appCtrl.appTheme.primary,
            ),
            body: Form(
              key: regCtrl.regGlobalKey,
              child: ListView(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.widthSize*1.2,
                    vertical: Dimensions.heightSize
                ),
                children: [
                  Center(child: RoundedDivider(width: 4,height: 35,
                    color: appCtrl.appTheme.primaryYellow,)),
                  addVerticalSpace(Dimensions.heightSize*1.5),

                  Text('Sign up',
                      textAlign: TextAlign.center,
                      style: AppCss.introHeading.textColor(appCtrl.appTheme.primary)),
                  addVerticalSpace(Dimensions.heightSize*3),

                  TextFieldCommon(
                    controller: regCtrl.nameController,
                      labelText: 'name'.toUpperCase(),
                  hintText: 'John Doe',
                  validator: (value) => nameValidator(value,"Enter Name"),),
                  addVerticalSpace(Dimensions.heightSize*1.5),
                  TextFieldCommon(
                    controller: regCtrl.emailController,
                    labelText: 'email'.toUpperCase(),
                    hintText: 'example@gmail.com',
                    validator: (value) => emailValidator(value),),

                  addVerticalSpace(Dimensions.heightSize*1.5),

                  inputWidget(),//mobile number

                  addVerticalSpace(Dimensions.heightSize*1.5),

                  TextFieldCommon(
                    controller: regCtrl.passwordController,
                    labelText: 'password'.toUpperCase(),
                    hintText: 'Password',
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    suffixIcon: InkWell(
                        onTap: regCtrl.updateObsecure,
                        child: Icon(regCtrl.isObsecure ? Icons.visibility : Icons.visibility_off)),
                    obscureText: regCtrl.isObsecure,
                    validator: (value) => passwordValidator(value),
                  ),

                  addVerticalSpace(Dimensions.heightSize*3),

                  PrimaryButtonWidget(
                    text: 'Sign up',
                    isLoading: regCtrl.isLoading,
                    onPressed: () => regCtrl.regMethod(),
                  ),

                  addVerticalSpace(Dimensions.heightSize*2),

                  InkWell(
                    onTap: (){
                      Get.offAll(() => LoginScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? ',
                          style: AppCss.mulishExtraLight14.textColor(appCtrl.appTheme.secondaryText),
                          textAlign: TextAlign.center,),
                        addHorizontalSpace(Dimensions.widthSize*0.5),
                        Text('Sign in.',
                          style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.primary),
                          textAlign: TextAlign.center,),
                      ],
                    ),
                  )
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
          ),
        );
      },
    );
  }

  _countryPicker(){
    return CountryCodePicker(
      onChanged: regCtrl.onCountryChanged,
      onInit: regCtrl.onCountryInit,
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
      controller: regCtrl.phoneController,
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
      autovalidateMode: regCtrl.autoValidate,
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
}
