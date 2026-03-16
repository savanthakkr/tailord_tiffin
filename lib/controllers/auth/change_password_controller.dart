import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/api_manager.dart';
import '../../model/response_model.dart';
import '../../utils/connection_utils.dart';
import '../../utils/prefs.dart';
import '../../utils/ui_utils.dart';

class ChangePasswordController extends GetxController{
  var oldPasswordController = TextEditingController();
  var passwordController = TextEditingController();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  GlobalKey<FormState> changePassGlobalKey = GlobalKey<FormState>();
  String? authToken,userId;
  bool isLoading=false;
  bool isObsecure = true,isObsecure1 = true;

  @override
  void onInit() {
    super.onInit();
    getPrefs();
  }

  void getPrefs()
  {
    authToken = Prefs.shared.getString(Prefs.authToken);
    userId = Prefs.shared.getString(Prefs.userId);
    print("Token $authToken");
  }

  updateObsecure() {
    isObsecure = !isObsecure;
    update();
  }

  updateObsecure1() {
    isObsecure1 = !isObsecure1;
    update();
  }

  updatePassword() {
    if(changePassGlobalKey.currentState!.validate())
    {
      ConnectionUtils.checkConnection().then((internet) async {
        if (internet) {
          isLoading = true;
          update();
          try{
            final ResponseModel responseModel = await ApiManager.changePassword(
                authToken: authToken!,
                oldPassword: oldPasswordController.text,newPassword: passwordController.text);
            // showProgressDialouge("Login",context);

            if(responseModel.status == 'success') {
              isLoading = false;
              passwordController.clear();
              oldPasswordController.clear();
              update();
              UIUtils.bottomToast(text: responseModel.msg!, isError: false);
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