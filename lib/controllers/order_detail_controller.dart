import 'dart:ui';

import 'package:get/get.dart';
import 'package:tailoredtiffin/model/order_detail_model.dart';
import 'package:tailoredtiffin/model/order_model.dart';

import '../utils/config.dart';

class OrderDetailController extends GetxController{
  bool isLoading=false;
  String? authToken,orderId;
  OrderDetailsData? orderData;

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
          final OrderDetailModel model = await ApiManager.getOrderDetail(authToken: authToken!,
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
