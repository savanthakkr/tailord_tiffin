import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/profile_controller.dart';
import 'package:tailoredtiffin/widgets/contry_picker_widget.dart';

import '../utils/config.dart';
import '../utils/validation_utils.dart';
import '../widgets/rounded_divider.dart';
import '../widgets/text_field_common.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var prCtrl = Get.find<ProfileController>();

  Future<bool> _onBackPressed() async{
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    Get.back();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
          if (context.mounted) {
            _onBackPressed();
          }
        },
        child: GetBuilder<ProfileController>(
            builder: (ctrl) {
              return Scaffold(
                backgroundColor: appCtrl.appTheme.white,
                appBar: CommonAppbar(
                  title: 'Edit Profile',
                  backEnable: true,
                  centerTitle: true,
                  bgColor: appCtrl.appTheme.white,
                  leadingOnTap: () => _onBackPressed(),
                ),
                body: Form(
                  key: prCtrl.regGlobalKey,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.widthSize,
                        vertical: Dimensions.heightSize
                    ),
                    children: [
                      TextFieldCommon(
                        controller: prCtrl.nameController,
                        labelText: 'name'.toUpperCase(),
                        hintText: 'John Doe',
                        validator: (value) => nameValidator(value,"Enter Name"),),

                      addVerticalSpace(Dimensions.heightSize*1.5),

                      inputWidget(),//mobile number

                      addVerticalSpace(Dimensions.heightSize*1.5),

                      TextFieldCommon(
                        controller: prCtrl.emailController,
                        labelText: 'Email'.toUpperCase(),
                        hintText: 'example@gmail.com',
                        validator: (value) => emailValidator(value),
                      ),

                      // addVerticalSpace(Dimensions.heightSize*1.5),
                      //
                      // TextFieldCommon(
                      //   controller: prCtrl.referController,
                      //   labelText: 'Referred By(Optional)'.toUpperCase(),
                      //   hintText: 'REF123456',),

                      addVerticalSpace(Dimensions.heightSize*3),

                      PrimaryButtonWidget(
                        text: 'Save Changes',
                        isLoading: prCtrl.isLoading,
                        onPressed: () => prCtrl.updateInfoMethod(),
                      ),

                    ],
                  ),
                ),
              );
            }
        )
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
              ContryPickerWidget(onChanged: prCtrl.onCountryChanged, onInit: prCtrl.onCountryInit),
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

  _phoneTextField() {
    return TextFormField(
      controller: prCtrl.phoneController,
      keyboardType: TextInputType.phone,
      cursorColor: appCtrl.appTheme.black,
      enabled: false,
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
      autovalidateMode: prCtrl.autoValidate,
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
}
