import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/config.dart';
import '../auth/login_screen.dart';

class WalkthroughController extends GetxController{
  int currentIndex = 0;
  final pageController = PageController(initialPage: 0);
  List contents = [
    {
      'title': 'Welcome\nto Satvil Bhojan',
      'subtitle': 'Ghar jaisa shuddh aur swadisht veg khana, seedha aapke darwaze tak.',
      'image': 'assets/pngs/intro_1.png'
    },
    {
      'title': 'Apna Khud Ka Kitchen',
      'subtitle': 'Hamare apne kitchen me taiyar hota hai har tiffin—saaf, surakshit aur healthy.',
      'image': 'assets/pngs/intro_2.png'
    },
    {
      'title': 'Rozana Taza Tiffin',
      'subtitle': 'Ghar-ghar pahunchta hua nutritious veg tiffin, time par delivery ke saath.',
      'image': 'assets/pngs/intro_3.png'
    }
  ];
  Timer? timer;
  double mHeight=0,mWidth=0;

  @override
  void onReady() {
    super.onReady();
    mWidth = Get.size.width;
    mHeight = Get.size.height;
    update();
    setTimer();
  }

  @override
  void onClose() {
    super.onClose();
    if(timer!=null && timer!.isActive)
    {
      timer!.cancel();
    }

    pageController.dispose();
  }

  onPageChanged(int index){
    currentIndex = index;
    debugPrint('currentIndex: $currentIndex');
    update();
  }

  btnOnClickMethod() async {
    if(currentIndex == (contents.length-1))
    {
      Prefs.shared.setBool(Prefs.isIntroSeen,true);
      Get.off(()=> LoginScreen());
    }
    else{
      pageController.animateToPage(
        currentIndex+1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void setTimer(){
    timer = Timer.periodic(
      const Duration(seconds: 3),
          (Timer time) {
        if (currentIndex < (contents.length-1)) {
          currentIndex = currentIndex + 1;
          // update();
        } else {
          currentIndex = 0;
          // update();
        }
        pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
    );

    update();
  }

}