
import 'package:get/get.dart';
import 'package:tailoredtiffin/model/product.dart';
import 'package:tailoredtiffin/model/wish_list_model.dart';
import 'package:tailoredtiffin/model/wish_response_model.dart';

import '../../model/response_model.dart';
import '../../utils/config.dart';

class WishController extends GetxController{
  double mHeight=0,mWidth=0;
  List<WishElement> wishList = <WishElement>[];
  bool isLoading = false,updatingWishlist = false;
  String? authToken,userId;

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
    getWishlist();
  }

  void onRefresh() {
    getWishlist();
  }

  void getWishlist() {
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update(['wishList']);

        try{
          final WishListModel model = await ApiManager.getWishList(authToken: authToken!);

          if(model.status == 'success' && model.data!=null) {

            wishList = model.data!.list ?? [];

          }else{
            UIUtils.bottomToast(text: 'Error fetching Data', isError: true);
          }

          isLoading = false;
          update(['wishList']);
        }
        on Exception catch(_,e){
          isLoading = false;
          update(['wishList']);
        }
      }
      else {
        // No-Internet Case
        UIUtils.showInternetErrorToast();
      }
    });
  }

  addProductToWishlist({required String productId})
  {
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        updatingWishlist = true;
        update();
        try{

          final WishResponseModel responseModel = await ApiManager.addToWishlist(
              authToken: authToken!,
              productId: int.parse(productId),
              userId: int.parse(userId!));
          // showProgressDialouge("Login",context);

          if(responseModel.status == 'success') {

            updatingWishlist = false;
            update(['wishList']);
            onRefresh();
            UIUtils.bottomToast(text: responseModel.msg!, isError: false);

          }else{

            updatingWishlist = false;
            update(['wishList']);
            onRefresh();
            UIUtils.bottomToast(text: responseModel.msg!, isError: true);
          }

        }
        on Exception catch(_,e){
          updatingWishlist = false;
          update();
        }
      }
      else {
        // No-Internet Case
        UIUtils.showInternetErrorToast();
      }
    });
  }

  removeWishItem({required String wishId})
  {
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        updatingWishlist = true;
        update();
        try{

          final ResponseModel responseModel = await ApiManager.removeFromWishlist(
              authToken: authToken!,
              wishId: int.parse(wishId));
          // showProgressDialouge("Login",context);

          if(responseModel.status == 'success') {

            updatingWishlist = false;
            update(['wishList']);
            onRefresh();
            UIUtils.bottomToast(text: responseModel.msg!, isError: false);

          }else{

            updatingWishlist = false;
            update(['wishList']);
            UIUtils.bottomToast(text: responseModel.msg!, isError: true);
          }

        }
        on Exception catch(_,e){
          updatingWishlist = false;
          update();
        }
      }
      else {
        // No-Internet Case
        UIUtils.showInternetErrorToast();
      }
    });
  }

  bool addedToWishlist(Product? product) {
    if(product!=null && wishList.isNotEmpty)
    {
      for(int i=0 ; i < wishList.length ; i++)
      {
        if(product.productId == wishList[i].productId)
        {
          return true;
        }
      }
      return false;
    }
    return false;
  }

  WishElement? getWishProduct(Product? product) {
    if(product!=null && wishList.isNotEmpty)
    {
      for(int i=0 ; i < wishList.length ; i++)
      {
        if(product.productId == wishList[i].productId)
        {
          return wishList[i];
        }
      }
      return null;
    }
    return null;
  }
}


