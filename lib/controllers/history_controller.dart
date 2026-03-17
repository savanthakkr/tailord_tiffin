import 'package:get/get.dart';
import 'package:tailoredtiffin/model/order_model.dart';

import '../screens/order_details_popup.dart';
import '../utils/config.dart';
enum OrderType { all, delivered, confirmed }
class HistoryController extends GetxController{
  bool isLoading=false;
  String? authToken,userId;
  List<OrderData> orderList = <OrderData>[];
  OrderType _orderType = OrderType.all;
  OrderType get orderType => _orderType;

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

  void setOrderType(OrderType type) {
    _orderType = type;
    update();
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

  void showOrderDetailPopup(String orderId) {
    Get.dialog(
      OrderDetailPopup(orderId: orderId),
      barrierDismissible: true,
    );
  }

}
