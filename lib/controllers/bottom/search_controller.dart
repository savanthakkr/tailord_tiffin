
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/model/category_model.dart';

import '../../api/api_manager.dart';
import '../../utils/connection_utils.dart';
import '../../utils/prefs.dart';
import '../../utils/ui_utils.dart';

class SearchProductController extends GetxController{
  var images = [
    'assets/pngs/intro_1.png',
    'assets/pngs/intro_2.png',
    'assets/pngs/intro_3.png'
  ];
  double mHeight=0,mWidth=0;
  String? authToken,userId;
  bool? isLoading = false;
  List<AllCategory> categories = <AllCategory>[];
  AllCategory? selectedCategory;
  TextEditingController searchController = TextEditingController();


  // final List<Map<String, String>> categories = [
  //   {
  //     "title": "Compacts",
  //     "image":
  //     "https://media.istockphoto.com/id/1080502908/photo/cosmetic-blush-colors-for-glamor-skin-complextion.webp?a=1&s=612x612&w=0&k=20&c=XytWZ4dRngirAmYZyPZ9tzoSx6L__DBWQzItPyLXPSo="
  //   },
  //   {
  //     "title": "Eye Shadows",
  //     "image":
  //     "https://images.unsplash.com/photo-1583280157557-63caa755ba13?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDE1fHx8ZW58MHx8fHx8"
  //   },
  //   {
  //     "title": "Foundations",
  //     "image":
  //     "https://plus.unsplash.com/premium_photo-1726754448173-e68fc37cc29f?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDJ8fHxlbnwwfHx8fHw%3D"
  //   },
  //   {
  //     "title": "Countour",
  //     "image":
  //     "https://plus.unsplash.com/premium_photo-1661754333744-38817d55d79a?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDV8fHxlbnwwfHx8fHw%3D"
  //   },
  //   {
  //     "title": "Lipsticks",
  //     "image":
  //     "https://plus.unsplash.com/premium_photo-1726876844210-d0964a9e5ded?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDR8fHxlbnwwfHx8fHw%3D"
  //   },
  // ];

  @override
  void onReady() {
    super.onReady();
    mHeight = Get.size.height;
    mWidth = Get.size.width;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getPrefs();
  }

  void getPrefs()
  {
    authToken = Prefs.shared.getString(Prefs.authToken);
    userId = Prefs.shared.getString(Prefs.userId);
    getCategory();
    print("Token $authToken");
  }

  void onRefresh() {
    getCategory();
  }

  getCategory(){
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();

        try{
          final CategoryModel model = await ApiManager.getAllCategory(userId: userId!,authToken: authToken!);

          if(model.status == 'success' && model.data!=null) {

            categories = model.data! ?? [];

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

  getSubCategory(){
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();

        try{
          final CategoryModel model = await ApiManager.getAllCategory(userId: userId!,authToken: authToken!);

          if(model.status == 'success' && model.data!=null) {

            categories = model.data! ?? [];

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

