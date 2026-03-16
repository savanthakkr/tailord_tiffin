import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/auth/forgot_password_controller.dart';

import '../../utils/config.dart';
import '../../utils/validation_utils.dart';
import '../../widgets/text_field_common.dart';

class ForgotPasswordScreen extends StatelessWidget {

  final forgotCtrl = Get.put(ForgotPasswordController());

  ForgotPasswordScreen({super.key});

  Future<bool> _onBackPressed() async{
    Get.back();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
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
                key: forgotCtrl.resetPassGlobalKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.widthSize*1.2,
                      vertical: Dimensions.heightSize
                  ),
                  children: [
                    Text('Reset Password',
                        style: AppCss.introHeading.textColor(appCtrl.appTheme.primary)
                    ),
                    Text('Create a new password to regain access to your account.',
                        style: AppCss.mulishExtraLight14.textColor(appCtrl.appTheme.secondaryText)),
                    addVerticalSpace(Dimensions.heightSize),
                    TextFieldCommon(
                      controller: forgotCtrl.passwordController,
                      labelText: 'new password'.toUpperCase(),
                      hintText: 'New Password',
                      keyboardType: TextInputType.emailAddress,
                      maxLines: 1,
                      suffixIcon: InkWell(
                          onTap: forgotCtrl.updateObsecure,
                          child: Icon(forgotCtrl.isObsecure ? Icons.visibility : Icons.visibility_off)),
                      obscureText: forgotCtrl.isObsecure,
                      validator: (value) => passwordValidator(value),
                    ),
                    addVerticalSpace(Dimensions.heightSize*2),
                    PrimaryButtonWidget(
                      text: 'Update',
                      isLoading: forgotCtrl.isLoading,
                      onPressed: () => forgotCtrl.updatePassword(),
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
