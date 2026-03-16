import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/model/reg_model.dart';
import 'package:tailoredtiffin/screens/auth/otp_screen.dart';

import '../../screens/bottom/user_bottom_screen.dart';
import '../../utils/config.dart';


class SignUpController extends GetxController{

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  GlobalKey<FormState> regGlobalKey = GlobalKey<FormState>();
  bool isLoading=false;
  // String? phone;
  CountryCode countryCode = CountryCode(code: "IN");
  bool isObsecure = true;
  String firebaseToken = '';

  @override
  void onReady() {
    super.onReady();

    // phone = Get.arguments['phone'];
    // startTimer();
    update();
  }

  onCountryChanged(CountryCode code) {
    countryCode = code;
    update();
  }

  onCountryInit(CountryCode? code) {
    countryCode = code!;
    // update();
  }

  updateObsecure() {
    isObsecure = !isObsecure;
    update();
  }

  Future<void> firebaseCloudMessagingListeners(context) async {
    FirebaseMessaging.instance.getToken().then((token) {
      firebaseToken =  token.toString();
      update();
      print(token);
    });
  }

  regMethod() {
    if(regGlobalKey.currentState!.validate())
      {
        ConnectionUtils.checkConnection().then((internet) async {
          if (internet) {
            isLoading = true;
            update();
            try{
              String phone = '${countryCode.dialCode}${phoneController.text}';
              FirebaseMessaging.instance.getToken().then((token) {
                firebaseToken =  token.toString();
                update();
                print(token);
              });

              print("Outer Token $firebaseToken");
              final RegisterModel responseModel = await ApiManager.signUp(
                name: nameController.text,mobileNo: phoneController.text,email: emailController.text,
                password: passwordController.text,firebaseToken: firebaseToken);
              // showProgressDialouge("Login",context);

              if(responseModel.status == 'success' && responseModel.data != null) {

                Prefs.shared.setString(Prefs.userId, responseModel.data!.userId!);
                Prefs.shared.setString(Prefs.authToken, responseModel.data!.token!);
                Prefs.shared.setBool(Prefs.isLoggedIn, true);
                Prefs.shared.setBool(Prefs.isIntroSeen, true);

                isLoading = false;
                update();

                Get.offAll(() => const UserBottomBar());

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