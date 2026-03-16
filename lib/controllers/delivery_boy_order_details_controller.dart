import 'dart:ui';

import 'package:get/get.dart';

import '../model/delivery_boy_order_details_model.dart';
import '../utils/config.dart';

class DeliveryBoyOrderDetailController extends GetxController{
  bool isLoading=false;
  String? authToken,orderId;
  DeliveryBoyOrderDetailsData? orderData;

  @override
  void onInit() {
    super.onInit();
    orderId = Get.arguments['orderId'];
    getPrefs();
  }

  void getPrefs()
  {
    authToken = Prefs.shared.getString(Prefs.authToken);
    update();
    getDetails();
  }

  void getDetails() {
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();

        try{
          final DeliveryBoyOrderDetailModel model = await ApiManager.getAssignedOrderDetails(authToken: authToken!,
              orderId: int.parse(orderId!));

          if(model.status == 'success' && model.data!=null) {

            orderData = model.data!;

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

  String getDeliveryCharge()
  {
    // if(orderData!.order!=null)
    //   {
    //     if(orderData!.order!.deliveryCharge!=null)
    //       {
    //         double dCharge = double.parse(orderData!.order!.deliveryCharge!);
    //         if(dCharge<=0)
    //           {
    //             return 'Free';
    //           }
    //         return '$dCharge';
    //       }
    //   }
    return '';
  }

  Color getStatusColor()
  {
    return orderData!.order!.status!.toLowerCase() == 'active'
        ? appCtrl.appTheme.saleGreen
        : appCtrl.appTheme.errorColor;
  }

  Color getPaymentColor()
  {
    return orderData!.order!.isPaid == '0'
        ? appCtrl.appTheme.errorColor
        : appCtrl.appTheme.saleGreen;
  }

  String getStatusIcon()
  {
    return orderData!.order!.isPaid == '0'
        ? assets.closeSvg
        : orderData!.order!.isPaid == '1'
        ? assets.checkSvg
        : assets.clockSquareSvg ;
  }

}
