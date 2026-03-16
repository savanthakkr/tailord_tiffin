import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/model/login_model.dart';
import 'package:tailoredtiffin/screens/auth/otp_screen.dart';
import '../../screens/bottom/user_bottom_screen.dart';
import '../../utils/config.dart';
import '../../utils/connection_utils.dart';
import '../../utils/prefs.dart';
import '../../utils/ui_utils.dart';

class LoginController extends GetxController{
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  CountryCode countryCode = CountryCode(code: "IN");
  GlobalKey<FormState> signInGlobalKey = GlobalKey<FormState>();
  bool isLoading=false;
  bool isObsecure = true;
  String firebaseToken = '';

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

  signInMethod() async {

    if (signInGlobalKey.currentState!.validate()) {

      bool internet = await ConnectionUtils.checkConnection();

      if (internet) {

        isLoading = true;
        update();

        try {

          /// 🔹 FIRST GET FIREBASE TOKEN
          firebaseToken = await FirebaseMessaging.instance.getToken() ?? "";

          print("Firebase Token => $firebaseToken");

          String phone = '${countryCode.dialCode}${phoneController.text}';

          /// 🔹 THEN CALL API
          final LoginModel responseModel = await ApiManager.login(
            mobileNo: phoneController.text,
            firebasetoken: firebaseToken,
          );

          if (responseModel.status == 'success') {

            isLoading = false;
            update();

            Prefs.shared.setString(Prefs.authToken, responseModel.data!.token!);
            Prefs.shared.setString(Prefs.phone, phoneController.text);
            Prefs.shared.setString(
                Prefs.userId,
                responseModel.data!.user!.userId.toString().isEmpty
                    ? "0"
                    : responseModel.data!.user!.userId.toString());

            Prefs.shared.setBool(Prefs.isLoggedIn, true);
            Prefs.shared.setBool(Prefs.isIntroSeen, true);

            if (responseModel.data!.user!.deliveryBoyDetails != null) {
              Prefs.shared.setString(Prefs.id_deliveryboy, "1");
            } else {
              Prefs.shared.setString(Prefs.id_deliveryboy, "0");
            }

            print("Delivery Boy Status: ${Prefs.shared.getString(Prefs.id_deliveryboy)}");

            Get.to(() => OtpScreen(), arguments: {
              'phone': phoneController.text,
              'token': responseModel.data!.token
            });

          } else {

            autoValidate = AutovalidateMode.onUserInteraction;
            isLoading = false;
            update();

            UIUtils.bottomToast(text: responseModel.msg!, isError: true);
          }

        } catch (e) {

          isLoading = false;
          update();
          print("Login Error => $e");
        }

      } else {

        UIUtils.showInternetErrorToast();
      }

    } else {

      autoValidate = AutovalidateMode.onUserInteraction;
      update();
    }
  }

}