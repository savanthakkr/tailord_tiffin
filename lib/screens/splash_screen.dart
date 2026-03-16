
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/screens/auth/login_screen.dart';
import 'package:tailoredtiffin/screens/intro/walkthrough_screen.dart';
import 'package:tailoredtiffin/screens/bottom/user_bottom_screen.dart';

import '../app_theme/theme_service.dart';
import '../utils/config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoggedIn = false,_isIntroSeen = false;
  double mHeight=0,mWidth=0;

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(
    //     SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    Timer(const Duration(seconds: 3),() => navigateUser());
  }

  @override
  void dispose() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
    super.dispose();
  }


  navigateUser() async {
    bool isLoggedIn = Prefs.shared.getBool(Prefs.isLoggedIn) ?? false;
    bool isIntroSeen = Prefs.shared.getBool(Prefs.isIntroSeen) ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isIntroSeen = isIntroSeen;
    });

    bool isTheme = appCtrl.storage.read(Prefs.isDark) ?? false;
    debugPrint('isTheme: $isTheme');
    debugPrint('isIntroSeen: $isIntroSeen');
    ThemeService().switchTheme(isTheme);
    appCtrl.isTheme = isTheme;

    //check if user is logged in
    // if(!_isIntroSeen)
    // {
    //   Get.off(() => const WalkthroughScreen());
    // }
    // else
    if(!_isLoggedIn) {
      Get.off(() => LoginScreen());
    } else {
      Get.off(()=> const UserBottomBar());
    }
  }

  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: appCtrl.appTheme.white,
      body: SizedBox(
          height: mHeight,
          width: mWidth,
          child: Container(
            alignment: Alignment.center,
            child: Image.asset(
              assets.logo,
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          )
      ),
    );
  }

}