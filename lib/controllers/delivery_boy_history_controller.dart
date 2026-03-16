import 'package:get/get.dart';
import 'package:tailoredtiffin/model/order_model.dart';

import '../utils/config.dart';

class DeliveryBoyHistoryController extends GetxController{
  bool isLoading=false;
  String? authToken,userId;
  List<OrderData> orderList = <OrderData>[];

  @override
  void onInit() {
    super.onInit();
    getPrefs();
  }

  void getPrefs()
  {
    authToken = Prefs.shared.getString(Prefs.authToken);
    userId = Prefs.shared.getString(Prefs.userId);
    getHistory();
  }

  Future<void> getHistory({String? slot}) async {

    bool internet = await ConnectionUtils.checkConnection();

    if (!internet) {
      UIUtils.showInternetErrorToast();
      return;
    }

    try {

      isLoading = true;
      update();

      final OrderModel model =
      await ApiManager.getAssignedOrders(
        authToken: authToken!,
        slot: slot,
      );

      if (model.status == 'success' && model.data != null) {

        orderList = model.data!;

        orderList.sort(
                (a,b) => b.createdAt!.compareTo(a.createdAt!)
        );

      }

    } catch(e){
      print("Assigned Orders API ERROR: $e");
    }

    isLoading = false;
    update();
  }

  void onRefresh() {
    getHistory();
  }

}
