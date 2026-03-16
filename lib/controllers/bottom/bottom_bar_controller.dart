import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/address_controller.dart';
import 'package:tailoredtiffin/controllers/auth/change_password_controller.dart';
import 'package:tailoredtiffin/controllers/bottom/cart_controller.dart';
import 'package:tailoredtiffin/controllers/bottom/home_controller.dart';
import 'package:tailoredtiffin/controllers/bottom/search_controller.dart';
import 'package:tailoredtiffin/controllers/bottom/wish_controller.dart';
import 'package:tailoredtiffin/controllers/profile_controller.dart';

import '../../api/api_manager.dart';
import '../../model/cart_model.dart';
import '../../utils/connection_utils.dart';
import '../../utils/prefs.dart';
import '../../utils/ui_utils.dart';
import '../history_controller.dart';



class BottomBarController extends GetxController{

  int selectedIndex = 2;
  DateTime? currentBackPressTime;
  bool canPopNow = false;
  int requiredSeconds = 2;
  final GlobalKey<ScaffoldState> bottomKey = GlobalKey<ScaffoldState>();

  @override
  void onInit() {
    super.onInit();

    Get.put(HomeController(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(HistoryController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
    Get.put(AddressController(), permanent: true);
    Get.put(ChangePasswordController(), permanent: true);
  }

  onBottomTap(int index) {
    selectedIndex = index;

    if (index == 0 && Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().onRefresh();
    }
    if (index == 1 && Get.isRegistered<CartController>()) {
      Get.find<CartController>().onRefresh();
    }
    if (index == 2 && Get.isRegistered<HistoryController>()) {
      Get.find<HistoryController>().onRefresh();
    }
    if (index == 3 && Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().onRefresh();
    }

    update();
  }

  void onPopInvoked(bool didPop,result) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) >
            Duration(seconds: requiredSeconds)) {
      currentBackPressTime = now;
      UIUtils.bottomToast(text: 'Press back again to exit', isError: false);
      Future.delayed(
        Duration(seconds: requiredSeconds),
            () {
          // Disable pop invoke and close the toast after 2s timeout
          canPopNow = false;
          update();
          // Fluttertoast.cancel();
        },
      );
      // Ok, let user exit app on the next back press
      canPopNow = true;
      update();
    }
  }
}