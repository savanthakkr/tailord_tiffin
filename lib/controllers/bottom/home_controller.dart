
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tailoredtiffin/model/all_bread_model.dart';
import 'package:tailoredtiffin/model/all_meals_model.dart';
import 'package:tailoredtiffin/model/all_subji_model.dart';
import 'package:tailoredtiffin/model/home_model.dart';
import 'package:tailoredtiffin/model/special_item_model.dart';
import '../../model/product.dart';
import '../../model/response_model.dart';
import '../../utils/config.dart';

class HomeController extends GetxController{
  var images = [
    'assets/pngs/banners/s2.png',
    'assets/pngs/banners/s3.png',
    'assets/pngs/banners/s4.png',
    'assets/pngs/banners/slide1.png',
  ];
  CarouselSliderController controller = CarouselSliderController();
  var initialPage = 0.obs;
  double mHeight=0,mWidth=0;
  List<AllMeals> allMealList = <AllMeals>[];
  List<SpecialItem> allSpecialItem = <SpecialItem>[];
  List<Subji> allSubjiList = <Subji>[];
  List<Bread> allBreadList = <Bread>[];
  bool? isLoading = false,addingToCart = false;
  String? authToken,userId;

  @override
  void onReady() {
    super.onReady();
    mHeight = Get.size.height;
    mWidth = Get.size.width;
    update();
  }

  onBannerChanged(int index, CarouselPageChangedReason reason) {
    initialPage.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    getPrefs();
    checkPermission();
  }

  void onRefresh() async {
    await getProducts();
    await getSubji();
    await getBread();
    await getSpecialItems();
  }

  void getPrefs() async {
    authToken = Prefs.shared.getString(Prefs.authToken);
    userId = Prefs.shared.getString(Prefs.userId);
    await getProducts();
    await getSubji();
    await getBread();
    await getSpecialItems();

    print("TOken $authToken");
  }

  checkPermission() async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        final notification = await Permission.notification.request();

        if (notification == PermissionStatus.granted) {
          print('Permission granted.');
        } else if (notification == PermissionStatus.denied) {
          print(
              'Permission denied. Show a dialog and again ask for the permission');
          await [Permission.notification].request();
        }
      }
    }
  }

  getProducts(){
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();

        try{
          final AllMealsModel model = await ApiManager.getAllMeals(userId: userId!,authToken: authToken!);

          if(model.status == 'success' && model.data!=null) {

            allMealList = model.data! ?? [];

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

  getSpecialItems(){
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();

        try{
          final SpecialItemModel model = await ApiManager.getAllSpecialItems(userId: userId!,authToken: authToken!);

          if(model.status == 'success' && model.data!=null) {

            allSpecialItem = model.data! ?? [];

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

  getSubji(){
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();

        try{
          final AllSubjiModel model = await ApiManager.getAllSubji(userId: userId!,authToken: authToken!);

          if(model.status == 'success' && model.data!=null) {

            allSubjiList = model.data! ?? [];

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

  getBread(){
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();

        try{
          final AllBreadModel model = await ApiManager.getAllBread(userId: userId!,authToken: authToken!);

          if(model.status == 'success' && model.data!=null) {

            allBreadList = model.data! ?? [];

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
}
