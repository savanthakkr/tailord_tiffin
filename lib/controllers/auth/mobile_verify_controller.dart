import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/model/response_model.dart';
import 'package:tailoredtiffin/screens/auth/otp_screen.dart';

import '../../api/api_manager.dart';
import '../../utils/connection_utils.dart';
import '../../utils/ui_utils.dart';

class MobileVerifyController extends GetxController{
  var phoneController = TextEditingController();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  GlobalKey<FormState> mobileVerifyGlobalKey = GlobalKey<FormState>();
  bool isLoading=false;
  // String? phone;
  CountryCode countryCode = CountryCode(code: "IN");

  onCountryChanged(CountryCode code) {
    countryCode = code;
    update();
  }

  onCountryInit(CountryCode? code) {
    countryCode = code!;
    // update();
  }

  checkMobileExistApi() {
    if(mobileVerifyGlobalKey.currentState!.validate())
    {
      ConnectionUtils.checkConnection().then((internet) async {
        if (internet) {
          isLoading = true;
          update();
          try{
            final ResponseModel responseModel = await ApiManager.checkMobileExist(mobileNo: phoneController.text,);
            // showProgressDialouge("Login",context);

            if(responseModel.status == 'success') {
              isLoading = false;
              update();

              Get.to(() => OtpScreen(), arguments: {'phone': phoneController.text },);

            } else {
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