import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tailoredtiffin/api/api_manager.dart';
import '../model/all_bread_model.dart';
import '../model/all_meals_model.dart';
import '../model/all_subji_model.dart';
import '../model/notification_model.dart';
import '../model/special_item_model.dart';
import '../utils/connection_utils.dart';
import '../utils/prefs.dart';
import '../utils/ui_utils.dart';

class NotificationController extends GetxController {

  List<NotificationModel> notificationList = [];
  int unreadCount = 0;
  bool isLoading = false;
  List<AllMeals> allMealList = <AllMeals>[];
  List<SpecialItem> allSpecialItem = <SpecialItem>[];
  List<Subji> allSubjiList = <Subji>[];
  List<Bread> allBreadList = <Bread>[];
  String? authToken,userId;
  int? selectedMealId;
  int? selectedBreadId;
  Map<int, int> subjiQty = {}; // id -> quantity

  int quantity = 1;
  double totalPrice = 0;
  bool mealExpanded = false;
  bool finalExpanded = false;

  int subjiLimit = 0;
  int breadLimit = 0;

  Map<int, int> extraQty = {}; // extra item quantity

  int get totalSelectedSubji {
    int total = 0;
    subjiQty.forEach((key, value) {
      total += value;
    });
    return total;
  }

  void incrementSubji(int id) {
    if (selectedMealId == null) {
      UIUtils.bottomToast(text: "Select meal first", isError: true);
      return;
    }

    if (totalSelectedSubji < subjiLimit) {
      subjiQty[id] = (subjiQty[id] ?? 0) + 1;
      calculatePrice(); // ✅ ADD THIS
      update();
    } else {
      UIUtils.bottomToast(
          text: "Only $subjiLimit subji allowed", isError: true);
    }
  }

  void decrementSubji(int id) {
    if ((subjiQty[id] ?? 0) > 0) {
      subjiQty[id] = subjiQty[id]! - 1;

      if (subjiQty[id] == 0) {
        subjiQty.remove(id);
      }

      calculatePrice(); // ✅ ADD THIS
      update();
    }
  }

// 🔥 MEAL SELECT
  void selectMeal(int id) {
    selectedMealId = id;

    final meal = allMealList.firstWhereOrNull(
            (e) => int.parse(e.mealsId!) == id);

    subjiLimit = int.parse(meal?.subjiCount ?? "0") ?? 0;
    breadLimit = int.parse(meal?.breadCount ?? "0") ?? 0;

    subjiQty.clear();
    selectedBreadId = null;
    extraQty.clear();

    mealExpanded = false;

    calculatePrice();
    update();
  }

// 🔥 BREAD SELECT
  void selectBread(int id) {
    if (selectedMealId == null) {
      UIUtils.bottomToast(text: "Select meal first", isError: true);
      return;
    }

    selectedBreadId = id;
    update();
  }

// 🔥 EXTRA ITEM QTY
  void incrementExtra(int id) {
    extraQty[id] = (extraQty[id] ?? 0) + 1;
    calculatePrice();
    update();
  }

  void decrementExtra(int id) {
    if ((extraQty[id] ?? 0) > 0) {
      extraQty[id] = extraQty[id]! - 1;
      calculatePrice();
      update();
    }
  }

// 🔥 QUANTITY
  void incrementQty() {
    quantity++;
    calculatePrice();
    update();
  }

  void decrementQty() {
    if (quantity > 1) {
      quantity--;
      calculatePrice();
      update();
    }
  }

// 🔥 PRICE CALCULATION
  void calculatePrice() {
    double price = 0;

    final meal = allMealList.firstWhereOrNull(
            (e) => int.parse(e.mealsId!) == selectedMealId);

    if (meal != null) {
      price += double.parse(meal.price ?? "0");
    }

    extraQty.forEach((key, qty) {
      final item = allSpecialItem.firstWhereOrNull(
              (e) => int.parse(e.specialItemId!) == key);

      if (item != null) {
        price += double.parse(item.price ?? "0") * qty;
      }
    });

    subjiQty.forEach((key, qty) {
      final subji = allSubjiList.firstWhereOrNull(
              (e) => int.parse(e.subjiId!) == key);

      if (subji != null) {
        price += double.parse(subji.price ?? "0") * qty;
      }
    });

    totalPrice = price * quantity;
  }

  @override
  void onInit() {
    super.onInit();
    getPrefs();
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

  Future<void> getNotifications(String userToken) async {

    isLoading = true;
    update();

    try {

      final response = await http.get(
        Uri.parse("${ApiManager.baseUrl}/user/get_notifications"),
        headers: {
          "Authorization": "$userToken",
        },
      );

      final data = jsonDecode(response.body);

      print(data);
      print("adasdasdsad");

      if (data['status'] == "success") {

        notificationList = (data['data'] as List)
            .map((e) => NotificationModel.fromJson(e))
            .toList();
      }

    } catch (e) {
      print(e);
    }

    isLoading = false;
    update();
  }

  Future<void> getUnreadCount(String userToken) async {

    try {

      final response = await http.get(
        Uri.parse("${ApiManager.baseUrl}/user/get_unread_notification_count"),
        headers: {
          "Authorization": "$userToken",
        },
      );

      final data = jsonDecode(response.body);

      if (data['status'] == "success") {
        unreadCount = data['data']['count'];
      }

      update();

    } catch (e) {
      print(e);
    }
  }

  Future<void> markAsRead(String userToken) async {

    try {

      await http.post(
        Uri.parse("${ApiManager.baseUrl}/user/mark_notifications_read"),
        headers: {
          "Authorization": "$userToken",
        },
      );

      unreadCount = 0;

      update();

    } catch (e) {
      print(e);
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
            // UIUtils.bottomToast(text: 'Error fetching Data', isError: true);
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
            // UIUtils.bottomToast(text: 'Error fetching Data', isError: true);
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
        // UIUtils.showInternetErrorToast();
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
            // UIUtils.bottomToast(text: 'Error fetching Data', isError: true);
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
        // UIUtils.showInternetErrorToast();
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
            // UIUtils.bottomToast(text: 'Error fetching Data', isError: true);
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
        // UIUtils.showInternetErrorToast();
      }
    });
  }
}