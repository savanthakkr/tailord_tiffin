import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/model/profile_model.dart';
import 'package:tailoredtiffin/model/response_model.dart';

import '../screens/auth/login_screen.dart';
import '../utils/config.dart';

class ProfileController extends GetxController{
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var referController = TextEditingController();
  var phoneController = TextEditingController();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  GlobalKey<FormState> regGlobalKey = GlobalKey<FormState>();
  bool isLoading=false,getLoading = false;
  // String? phone;
  CountryCode countryCode = CountryCode(code: "IN");
  String? authToken,userId,userName,userPhone;
  bool isEditName = false;
  bool isEditEmail = false;

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
    getProfile();
  }

  void onRefresh() {
    getProfile();
  }

  onCountryChanged(CountryCode code) {
    countryCode = code;
    update();
  }

  onCountryInit(CountryCode? code) {
    countryCode = code!;
    // update();
  }

  void toggleNameEdit() {
    isEditName = !isEditName;
    update();
  }

  void toggleEmailEdit() {
    isEditEmail = !isEditEmail;
    update();
  }

  getProfile(){
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();

        try{
          final ProfileModel model = await ApiManager.getUserProfile(authToken: authToken!);

          if(model.status == 'success' && model.data!=null) {

           Data data = model.data!;
           userName = data.user!.name!;
           print("Data $userName");
           userPhone = data.user!.mobileNo!;
           nameController.text = data.user!.name ?? "Guest User";
           emailController.text = data.user!.email ?? "guest@gmail.com";
           phoneController.text = data.user!.mobileNo!;
           Prefs.shared.setString(Prefs.allowPayLater, data.user!.allow_pay_later!);
           if (data.deliveryBoyInfo?.deliveryBoyId == "undefined") {
             Prefs.shared.setString(Prefs.id_deliveryboy, "0");
           } else {
             Prefs.shared.setString(Prefs.id_deliveryboy, "1");
           }

          }else{
            UIUtils.bottomToast(text: 'Error fetching Data', isError: true);
          }

          isLoading = false;
          update();
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

  updateInfoMethod() {
    if (regGlobalKey.currentState!.validate()) {

      ConnectionUtils.checkConnection().then((internet) async {

        if (internet) {

          isLoading = true;
          update();

          try {

            final ResponseModel responseModel =
            await ApiManager.updateUserProfile(
                authToken: authToken!,
                name: nameController.text,
                email: emailController.text);

            if (responseModel.status == 'success') {

              /// ✅ EXIT EDIT MODE
              isEditName = false;
              isEditEmail = false;

              /// ✅ UPDATE LOCAL VALUES
              userName = nameController.text;
              userPhone = phoneController.text;

              isLoading = false;

              update();

              UIUtils.bottomToast(
                  text: "Profile updated successfully",
                  isError: false);

            } else {

              autoValidate = AutovalidateMode.onUserInteraction;
              isLoading = false;
              update();

              UIUtils.bottomToast(
                  text: responseModel.msg!,
                  isError: true);
            }

          } catch (e) {

            isLoading = false;
            update();
          }

        } else {
          UIUtils.showInternetErrorToast();
        }

      });

    } else {
      autoValidate = AutovalidateMode.onUserInteraction;
      update();
    }
  }

  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          "Logout",
          style: AppCss.mulishSemiBold16.textColor(appCtrl.appTheme.primary),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: AppCss.mulishMedium13.textColor(appCtrl.appTheme.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "No",
              style: AppCss.mulishBold14.textColor(appCtrl.appTheme.textColor),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(appCtrl.appTheme.primary),
              foregroundColor: MaterialStateProperty.all(appCtrl.appTheme.white), // text color
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () async {
              Get.back();
              await Prefs.shared.clearUserSession();
              Get.offAll(() => LoginScreen());
            },
            child: Text(
              "Yes",
              style: AppCss.mulishBold14.textColor(appCtrl.appTheme.white),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

}