
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/bottom/cart_controller.dart';

import '../model/product.dart';
import '../utils/config.dart';

class ProductDetailController extends GetxController{
  double mHeight=0,mWidth=0;
  Product? product;
  String? authToken,userId;
  CarouselSliderController controller = CarouselSliderController();
  var initialPage = 0.obs;

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
    if(Get.arguments!=null)
    {
      product = Get.arguments['product'];
    }
    Get.find<CartController>().onRefresh();
    getPrefs();
  }

  void getPrefs()
  {
    authToken = Prefs.shared.getString(Prefs.authToken);
    userId = Prefs.shared.getString(Prefs.userId);
  }

  onBannerChanged(int index, CarouselPageChangedReason reason) {
    initialPage.value = index;
  }

  
}

