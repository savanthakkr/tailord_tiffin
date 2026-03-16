import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/api_manager.dart';
import '../../model/response_model.dart';
import '../../screens/auth/login_screen.dart';
import '../../utils/connection_utils.dart';
import '../../utils/ui_utils.dart';

class ForgotPasswordController extends GetxController {

  bool isLoading=false;
  String? phone;
  var passwordController = TextEditingController();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  GlobalKey<FormState> resetPassGlobalKey = GlobalKey<FormState>();
  bool isObsecure = true;

  @override
  void onReady() {
    super.onReady();
    phone = Get.arguments['phone'];
  }

  updateObsecure() {
    isObsecure = !isObsecure;
    update();
  }

  updatePassword() {
    if(resetPassGlobalKey.currentState!.validate())
    {
      ConnectionUtils.checkConnection().then((internet) async {
        if (internet) {
          isLoading = true;
          update();
          try{
            final ResponseModel responseModel = await ApiManager.resetPassword(
                mobileNo: phone!,
                password: passwordController.text);
            // showProgressDialouge("Login",context);

            if(responseModel.status == 'success') {
              isLoading = false;
              passwordController.clear();
              update();
              UIUtils.bottomToast(text: responseModel.msg!, isError: false);
              Get.offAll(() => LoginScreen());
            }else{
              autoValidate = AutovalidateMode.onUserInteraction;
              isLoading = false;
              update();
              UIUtils.bottomToast(text: responseModel.msg!, isError: true);
            }

          }
          on Exception catch(_,e){
            isLoading = false;
            update();
          }
        }
        else {
          // No-Internet Case
          UIUtils.showInternetErrorToast();
        }
      });
    }
    else{
      autoValidate = AutovalidateMode.onUserInteraction;
      update();
    }
  }

}