import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/auth/change_password_controller.dart';

import '../../utils/config.dart';
import '../../utils/validation_utils.dart';
import '../../widgets/text_field_common.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  var changePasswordCtrl = Get.find<ChangePasswordController>();

  Future<bool> _onBackPressed() async{
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
        child: GetBuilder<ChangePasswordController>(
            builder: (ctrl) {
              return Scaffold(
                backgroundColor: appCtrl.appTheme.white,
                appBar: CommonAppbar(
                  title: 'Change Password',
                  backEnable: true,
                  centerTitle: true,
                  bgColor: appCtrl.appTheme.white,
                  leadingOnTap: () => _onBackPressed(),
                ),
                body: Form(
                  key: changePasswordCtrl.changePassGlobalKey,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.widthSize,
                        vertical: Dimensions.heightSize
                    ),
                    children: [
                      TextFieldCommon(
                        controller: changePasswordCtrl.oldPasswordController,
                        labelText: 'old password'.toUpperCase(),
                        hintText: 'Old Password',
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 1,
                        suffixIcon: InkWell(
                            onTap: changePasswordCtrl.updateObsecure,
                            child: Icon(changePasswordCtrl.isObsecure ? Icons.visibility : Icons.visibility_off)),
                        obscureText: changePasswordCtrl.isObsecure,
                        validator: (value) => passwordValidator(value),
                      ),
                      addVerticalSpace(Dimensions.heightSize*1.5),
                      TextFieldCommon(
                        controller: changePasswordCtrl.passwordController,
                        labelText: 'new password'.toUpperCase(),
                        hintText: 'New Password',
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 1,
                        suffixIcon: InkWell(
                            onTap: changePasswordCtrl.updateObsecure1,
                            child: Icon(changePasswordCtrl.isObsecure1 ? Icons.visibility : Icons.visibility_off)),
                        obscureText: changePasswordCtrl.isObsecure1,
                        validator: (value) => passwordValidator(value),
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
                        isLoading: changePasswordCtrl.isLoading,
                        onPressed: () => changePasswordCtrl.updatePassword(),
                      ),

                    ],
                  ),
                ),
              );
            }
        )
    );
  }
}
