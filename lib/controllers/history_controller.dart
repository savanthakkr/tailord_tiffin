import 'package:get/get.dart';
import 'package:tailoredtiffin/model/order_model.dart';

import '../utils/config.dart';

class HistoryController extends GetxController{
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

  Future<void> getHistory() async {

    bool internet = await ConnectionUtils.checkConnection();

    if (!internet) {
      UIUtils.showInternetErrorToast();
      return;
    }

    try {

      isLoading = true;
      update();

      final OrderModel model =
      await ApiManager.getOrderHistory(authToken: authToken!);

      print("API MODEL STATUS: ${model.status}");
      print("API MODEL DATA LENGTH: ${model.data?.length}");

      if (model.status == 'success' && model.data != null) {

        orderList = model.data ?? [];

        print(orderList.first.orderId);
        print("dasdasdasd");

        // latest order first
        orderList.sort(
                (a, b) => b.createdAt!.compareTo(a.createdAt!)
        );


      } else {
        UIUtils.bottomToast(
            text: 'Error fetching Data',
            isError: true);
      }

    } catch (e) {
      print("History API ERROR: $e");
    }

    isLoading = false;
    update();
  }

  void onRefresh() {
    getHistory();
  }

}
