import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/screens/auth/forgot_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_manager.dart';
import '../../model/login_model.dart';
import '../../utils/config.dart';
import '../../utils/prefs.dart';
import '../../utils/ui_utils.dart';
import '../../screens/bottom/user_bottom_screen.dart';

class OtpVerificationController extends GetxController{
  TextEditingController otpController = TextEditingController();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  GlobalKey<FormState> otpGlobalKey = GlobalKey<FormState>();
  bool isLoading=false;
  String? phone,token,userId;
  int _secondsRemaining = 60;
  Timer? _timer;
  String mVerificationId = '',strOTP = '',sentOtp = '';
  var mResend;
  late FirebaseAuth auth;

  @override
  void onReady() {
    super.onReady();
    auth = FirebaseAuth.instance;
    phone = Get.arguments['phone'];
    token = Get.arguments['token'];

    getPrefs();
  }

  getPrefs() async {
    // authToken = Prefs.shared.getString(Prefs.authToken);
    //
    // update();

    startTimer();
    sendMobileOtp();
  }

  void startTimer() {
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        _secondsRemaining--;
        update();
      }
    });
  }

  String get timerText {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void sendMobileOtp() {
    // registerUser();
    auth.verifyPhoneNumber(
        phoneNumber: "+91$phone",
        timeout: const Duration(minutes: 2),
        verificationCompleted:(PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          navigateUser();
        },
        verificationFailed: (FirebaseAuthException authException){
          debugPrint(authException.message);

          UIUtils.bottomToast(text: 'Verification failed', isError: true);
        },
        codeSent:(String verificationId, [int? forceResendingToken]){
          onCodeSent(verificationId,forceResendingToken);
        },
        codeAutoRetrievalTimeout: (String verificationId){
          mVerificationId = verificationId;
          debugPrint('verificationId : $verificationId');
        }
    );
  }

  Future onCodeSent(String verificationId, [int? forceResendingToken]) async{
    mVerificationId = verificationId;
    mResend = forceResendingToken;
    otpController = TextEditingController();
    update();
  }

  Future verifyVerificationCode() async
  {
    // debugPrint('mVerificationId : $mVerificationId || code : $strOTP');
    var credential = PhoneAuthProvider.credential(verificationId: mVerificationId, smsCode: strOTP);
    signInWithPhoneAuthCredential(credential);
  }

  Future signInWithPhoneAuthCredential(AuthCredential credential) async{
    auth.signInWithCredential(credential).then((UserCredential result){
      isLoading = false;
      update();

      navigateUser();
    }).catchError((e){
      isLoading = false;
      update();
      debugPrint('Otp Error: $e');
      UIUtils.bottomToast(text: 'Invalid OTP', isError: true);
    });
  }

  navigateUser() async {
    Prefs.shared.setString(Prefs.authToken, token!);
    Prefs.shared.setString(Prefs.phone, phone!);
    Prefs.shared.setBool(Prefs.isLoggedIn, true);
    Prefs.shared.setBool(Prefs.isIntroSeen, true);
    Get.offAll(() => const UserBottomBar());
  }

  onPinChanged(String value) {
    strOTP = value;
    update();
  }

  verifyOtp() async {

    if(otpGlobalKey.currentState!.validate()) {

      try {

        isLoading = true;
        update();

        var credential = PhoneAuthProvider.credential(
          verificationId: mVerificationId,
          smsCode: otpController.text,
        );

        UserCredential result =
        await auth.signInWithCredential(credential);

        if(result.user != null){

          // Firebase OTP Verified
          navigateUser();

        }

      } on FirebaseAuthException catch (e) {

        isLoading = false;
        update();

        UIUtils.bottomToast(text: "Invalid OTP", isError: true);

      }

    } else {
      UIUtils.bottomToast(text: 'Wrong OTP', isError: true);
    }
  }

  /*
  otpVerifyMethod() async {
    if(otpGlobalKey.currentState!.validate()) {
      if(intentTo == 'reg') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool(Prefs.isLoggedIn, true);

        // appCtrl.updateToken(authToken);
        Get.offAll(() => RegisterScreen(),arguments: {'phone': phone});
      }
      else{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool(Prefs.isLoggedIn,true);
        Get.offAll(() => const UserBottomBar());
      }
      /*
      ConnectionUtils.checkConnection().then((internet) async {
        if (internet) {
          isLoading = true;
          update();
          try {
            final LoginModel loginModel = await ApiManager.verifyOtp(
                mobile: phone!, otp: otpController.text);
            // showProgressDialouge("Login",context);
            if (loginModel.success != false) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString(Prefs.authToken, '${loginModel.token}');
              prefs.setBool(Prefs.isLoggedIn, true);

              isLoading = false;
              update();

              debugPrint('AUTH TOKEN: ${loginModel.token}');

              Get.offAll(() => const UserBottomBar());
            } else {
              isLoading = false;
              update();
              UIUtils.bottomToast(text: loginModel.message!, isError: true);
            }
          }
          on Exception catch (_, e) {
            isLoading = true;
            update();
          }
        }
        else {
          // No-Internet Case
          UIUtils.showInternetErrorToast();
        }
      });

       */
    }
    else{
      autoValidate = AutovalidateMode.onUserInteraction;
      update();
    }
  }

   */
}