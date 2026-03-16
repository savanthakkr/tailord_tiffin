import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/model/add_cart_model.dart';
import 'package:tailoredtiffin/model/all_bread_model.dart';
import 'package:tailoredtiffin/model/all_subji_model.dart';
import 'package:tailoredtiffin/model/cart_total_model.dart';
import 'package:tailoredtiffin/model/product.dart';
import 'package:tailoredtiffin/model/special_item_model.dart';
import 'package:tailoredtiffin/screens/bottom/cart_screen.dart';
import 'package:tailoredtiffin/screens/special_meal_Selection_bottom_sheet.dart';

import '../../model/all_meals_model.dart';
import '../../model/cart_model.dart';
import '../../model/response_model.dart';
import '../../screens/meal_selection_bottom_sheet.dart';
import '../../utils/config.dart';


class CartController extends GetxController{

  bool isLoading=false,totalLoading=false,updatingCart = false;
  double mHeight=0,mWidth=0;
  List<CartData>? cartList;
  String? authToken,originalTotal,offerPrice,payableAmount,userId;
  var promoController = TextEditingController();
  GlobalKey<FormState> promoGlobalKey = GlobalKey<FormState>();

  int subjiLimit = 0;
  int breadLimit = 0;
  Map<int, int> selectedSubjiQty = {};
  int? selectedBreadId;
  List<Map<String, dynamic>> extraItems = [];
  bool showExtraItems = false;
  List<Subji> allSubjiList = <Subji>[];
  List<Bread> allBreadList = <Bread>[];
  List<SpecialItem> allSpecialItem = <SpecialItem>[];
  bool isLunchActive = true;
  int cartCount = 0;

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

  void getPrefs() async {
    authToken = Prefs.shared.getString(Prefs.authToken);
    userId = Prefs.shared.getString(Prefs.userId);
    await getCart();
    await getSubji();
    await getBread();
    await getSpecialItem();
    // print("Token $authToken");
  }

  void onRefresh() {
    getCart();
  }

  getCart(){
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update(['cartList','cartCount']);

        try{
          final CartModel model = await ApiManager.getCart(authToken: authToken!);

          if(model.status == 'success' && model.data!=null) {

            cartList = model.data! ?? [];
            cartCount = cartList!.length;
            getCartTotal();

          }else{
            UIUtils.bottomToast(text: 'Error fetching Data', isError: true);
          }

          isLoading = false;
          update(['cartList','cartCount']);
        }
        on Exception catch(_,e){
          isLoading = false;
          update(['cartList','cartCount']);
        }
      }
      else {
        // No-Internet Case
        UIUtils.showInternetErrorToast();
      }
    });
  }

  double calculateMealTotal(AllMeals meal) {
    double mealPrice = double.tryParse(meal.price.toString()) ?? 0;

    double extraTotal = 0;

    for (var item in extraItems) {
      double price = double.tryParse(item['price'].toString()) ?? 0;
      int qty = item['quantity'] ?? 0;

      extraTotal += price * qty;
    }

    return mealPrice + extraTotal;
  }

  getCartTotal() {
    double totalAmount = 0;
    for (var item in cartList!) {
      final price = double.tryParse(item.totalPrice.toString()) ?? 0;
      totalAmount += price;
    }
    payableAmount = totalAmount.toStringAsFixed(2);
    update();
  }

  // getCartTotal(){
  //   ConnectionUtils.checkConnection().then((internet) async {
  //     if (internet) {
  //       totalLoading = true;
  //       update(['cartList']);
  //
  //       try{
  //         final CartTotalModel model = await ApiManager.getCartTotal(authToken: authToken!);
  //
  //         if(model.status == 'success' && model.data!=null) {
  //
  //           originalTotal = model.data!.originalTotal ?? '0';
  //           offerPrice = model.data!.totalOfferDiscount ?? '0';
  //           payableAmount = model.data!.finalPayable ?? '0';
  //
  //         }else{
  //           UIUtils.bottomToast(text: 'Error fetching Data', isError: true);
  //         }
  //
  //         totalLoading = false;
  //         update(['cartList']);
  //       }
  //       on Exception catch(_,e){
  //         totalLoading = false;
  //         update(['cartList']);
  //       }
  //     }
  //     else {
  //       // No-Internet Case
  //       UIUtils.showInternetErrorToast();
  //     }
  //   });
  // }

  void updateMealTypeByTime() {
    final now = DateTime.now();

    final today10am = DateTime(now.year, now.month, now.day, 10);
    final today5pm = DateTime(now.year, now.month, now.day, 18);

    // 10am - 5pm => Dinner
    if (now.isAfter(today10am) && now.isBefore(today5pm)) {
      isLunchActive = false;
    }
    // 5pm - midnight OR midnight - 10am => Lunch
    else {
      isLunchActive = true;
    }

    update(['mealSelection']);
  }

  void initMealSelection(AllMeals meal) {
    selectedSubjiQty.clear();
    selectedBreadId = null;
    extraItems.clear();

    subjiLimit = int.parse(meal.selectionRules!.subjiCount!);
    breadLimit = int.parse(meal.selectionRules!.breadCount!);

    /// ⭐ Auto select bread if only one option exists
    if (allBreadList.length == 1) {
      selectedBreadId = int.tryParse(allBreadList.first.breadId.toString());
    }

    update(['mealSelection']);
  }


  int getSubjiQty(int id) {
    return selectedSubjiQty[id] ?? 0;
  }

  int get totalSelectedSubji {
    return selectedSubjiQty.values.fold(0, (a, b) => a + b);
  }

  double _getExtraItemPrice(int itemId) {

    for (var subji in allSubjiList) {
      if (int.parse(subji.subjiId!) == itemId) {
        return double.tryParse(subji.price ?? "0") ?? 0;
      }
    }

    for (var bread in allBreadList) {
      if (int.parse(bread.breadId!) == itemId) {
        return double.tryParse(bread.price ?? "0") ?? 0;
      }
    }

    return 0;
  }

  void initEditMealSelection(CartData cartItem) {

    selectedSubjiQty.clear();

    if (cartItem.selectedItems?.subjis != null) {
      for (var s in cartItem.selectedItems!.subjis!) {

        int id = int.parse(s.subjiId!);

        selectedSubjiQty[id] = (selectedSubjiQty[id] ?? 0) + 1;
      }
    }

    selectedBreadId = int.tryParse(
        cartItem.selectedItems?.bread?.breadId ?? "");

    extraItems.clear();

    if (cartItem.extraItems != null) {
      for (var e in cartItem.extraItems!) {

        int itemId = int.parse(e.item_id!);
        int qty = int.parse(e.quantity!);

        double price = _getExtraItemPrice(itemId);

        extraItems.add({
          "item_id": itemId,
          "quantity": qty,
          "price": price,
        });
      }
    }

    update(['mealSelection']);
  }

  void addSubji(int id) {

    if (totalSelectedSubji >= subjiLimit) {
      Get.snackbar(
        "Limit reached",
        "You can select only $subjiLimit sabjis",
      );
      return;
    }

    selectedSubjiQty[id] = (selectedSubjiQty[id] ?? 0) + 1;

    update(['mealSelection']);
  }

  void removeSubji(int id) {

    if (!selectedSubjiQty.containsKey(id)) return;

    if (selectedSubjiQty[id]! > 1) {
      selectedSubjiQty[id] = selectedSubjiQty[id]! - 1;
    } else {
      selectedSubjiQty.remove(id);
    }

    update(['mealSelection']);
  }

  void selectBread(int id) {
    selectedBreadId = id;
    update(['mealSelection']);
  }

  bool get isMealSelectionValid =>
      totalSelectedSubji == subjiLimit &&
          selectedBreadId != null;

  bool get isSpecialMealSelectionValid =>
      totalSelectedSubji == subjiLimit;

  Map<String, dynamic> buildMealPayload(AllMeals meal) {
    return {
      "meal_id": meal.mealsId,
      "meal_price": meal.price,
      "meal_quantity": 1,
      "selected_items": {
        "bread_id": selectedBreadId,
        "subji_ids": buildSubjiList(),
      },
      "extra_items": extraItems,
    };
  }


  List<int> buildSubjiList() {

    List<int> result = [];

    selectedSubjiQty.forEach((id, qty) {

      for (int i = 0; i < qty; i++) {
        result.add(id);
      }

    });

    return result;
  }

  Map<String, dynamic> buildSpecialMealPayload(AllMeals meal) {
    return {
      "meal_id": meal.mealsId,
      "meal_quantity": 1,
      "selected_items": {
        "special_item_id": buildSubjiList(),
      },
      "extra_items": extraItems,
    };
  }

  void openMealSelectionSheet(
      AllMeals meal,
      List<Subji> subjiList,
      List<Bread> breadList,
      ) {
    initMealSelection(meal);
    updateMealTypeByTime();

    Get.bottomSheet(
      FractionallySizedBox(
        heightFactor: 0.82,
        child: MealSelectionBottomSheet(
          meal: meal,
          subjiList: subjiList,
          breadList: breadList,
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // void openMealSelectionSheet(
  //     AllMeals meal,
  //     List<Subji> subjiList,
  //     List<Bread> breadList,
  //     ) {
  //   initMealSelection(meal);
  //   Get.bottomSheet(
  //     MealSelectionBottomSheet(
  //       meal: meal,
  //       subjiList: subjiList,
  //       breadList: breadList,
  //     ),
  //     isScrollControlled: true,
  //     backgroundColor: appCtrl.appTheme.white,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(Dimensions.radius),
  //       ),
  //     ),
  //   );
  // }

  void openSpecialMealSelectionSheet(
      AllMeals meal,
      List<SpecialItem> subjiList,
      ) {
    initMealSelection(meal);
    updateMealTypeByTime();
    Get.bottomSheet(
      SpecialMealSelectionBottomSheet(
        meal: meal,
        subjiList: subjiList,
      ),
      isScrollControlled: true,
      backgroundColor: appCtrl.appTheme.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius),
        ),
      ),
    );
  }

  void toggleExtraItems() {
    showExtraItems = !showExtraItems;
    update(['mealSelection']);
  }

  void addExtraItem(int itemId) {
    final index =
    extraItems.indexWhere((Map<String, dynamic> e) => e['item_id'] == itemId);

    if (index == -1) {
      double price = _getExtraItemPrice(itemId);

      extraItems.add({
        "item_id": itemId,
        "quantity": 1,
        "price": price,
      });
    } else {
      extraItems[index]['quantity'] =
          (extraItems[index]['quantity'] ?? 1) + 1;
    }

    update(['mealSelection']);
  }

  void decreaseExtraItem(int itemId) {
    final index =
    extraItems.indexWhere((Map<String, dynamic> e) => e['item_id'] == itemId);

    if (index != -1) {
      final qty = extraItems[index]['quantity'] ?? 1;
      if (qty > 1) {
        extraItems[index]['quantity'] = qty - 1;
      } else {
        extraItems.removeAt(index);
      }
    }

    update(['mealSelection']);
  }

  bool isExtraSelected(int itemId) {
    return extraItems.any((e) => e['item_id'] == itemId);
  }

  int extraQty(int itemId) {
    final item =
    extraItems.firstWhereOrNull((Map<String, dynamic> e) => e['item_id'] == itemId);
    return item?['quantity'] ?? 0;
  }

  int getExtraQty(int itemId) {
    final index = extraItems.indexWhere(
          (e) => e['item_id'] == itemId,
    );

    if (index == -1) return 0;
    return extraItems[index]['quantity'] ?? 0;
  }

  void removeExtraItem(int itemId) {
    final index = extraItems.indexWhere(
          (e) => e['item_id'] == itemId,
    );

    if (index != -1) {
      extraItems.removeAt(index);
      update(['mealSelection']);
    }
  }

  addMealstoCart({required Map<String, dynamic> mealPayload})
  {
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        updatingCart = true;
        update();
        try{

          final AddCartModel responseModel = await ApiManager.addToCart(
              authToken: authToken!,
            mealPayload: mealPayload
          );
          // showProgressDialouge("Login",context);

          if(responseModel.status == 'success') {

            updatingCart = false;
            update(['cartList']);
            onRefresh();
            UIUtils.bottomToast(text: responseModel.msg!, isError: false);
            Get.to(const CartScreen());
          }else{

            updatingCart = false;
            update(['cartList']);
            onRefresh();
            UIUtils.bottomToast(text: responseModel.msg!, isError: true);
          }

        }
        on Exception catch(_,e){
          updatingCart = false;
          update();
        }
      }
      else {
        // No-Internet Case
        UIUtils.showInternetErrorToast();
      }
    });
  }

  updateMeals({required Map<String, dynamic> payload,})
  {
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        updatingCart = true;
        update();
        try{

          final AddCartModel responseModel = await ApiManager.updateCart(
              authToken: authToken!,
              mealPayload: payload);
          // showProgressDialouge("Login",context);

          if(responseModel.status == 'success') {

            updatingCart = false;
            update(['cartList']);
            onRefresh();
            UIUtils.bottomToast(text: responseModel.msg!, isError: false);

          }else{

            updatingCart = false;
            update(['cartList']);
            UIUtils.bottomToast(text: responseModel.msg!, isError: true);
          }

        }
        on Exception catch(_,e){
          updatingCart = false;
          update();
        }
      }
      else {
        // No-Internet Case
        UIUtils.showInternetErrorToast();
      }
    });
  }

  removeCart({required String cartId})
  {
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        updatingCart = true;
        update();
        try{

          final ResponseModel responseModel = await ApiManager.removeCart(
              authToken: authToken!,
              cartId: int.parse(cartId));
          // showProgressDialouge("Login",context);

          if(responseModel.status == 'success') {

            updatingCart = false;
            update(['cartList']);
            onRefresh();
            UIUtils.bottomToast(text: responseModel.msg!, isError: false);

          }else{

            updatingCart = false;
            update(['cartList']);
            UIUtils.bottomToast(text: responseModel.msg!, isError: true);
          }

        }
        on Exception catch(_,e){
          updatingCart = false;
          update();
        }
      }
      else {
        // No-Internet Case
        UIUtils.showInternetErrorToast();
      }
    });
  }

  void initEditExtraItems(CartData cartItem) {
    extraItems.clear();
    showExtraItems = true;

    // ONLY load extra items
    if (cartItem.extraItems != null) {
      for (var e in cartItem.extraItems!) {

        int itemId = int.parse(e.item_id!);
        int qty = int.parse(e.quantity!);

        double price = _getExtraItemPrice(itemId);

        extraItems.add({
          "item_id": itemId,
          "quantity": qty,
          "price": price,
        });
      }
    }

    update(['mealSelection']);
  }

  Map<String, dynamic> buildEditMealPayload(CartData cartItem) {
    return {
      "cart_id": cartItem.cartId,
      "meal_quantity": 1,
      "selected_items": {
        "bread_id": cartItem.selectedItems?.bread?.breadId,
        "subji_ids": cartItem.selectedItems?.subjis
            ?.map((e) => e.subjiId)
            .toList() ??
            [],
      },
      "extra_items": extraItems,
    };
  }

  Map<String, dynamic> buildEditSpecialMealPayload(CartData cartItem) {
    return {
      "cart_id": cartItem.cartId,
      "meal_quantity": 1,
      "selected_items": {
        "special_item_id": cartItem.selectedItems?.specialMeal?.special_item_id,
      },
      "extra_items": extraItems,
    };
  }


  bool addedToCart(AllMeals? product) {
    if(product!=null && cartList!=null)
      {
        for(int i=0 ; i < cartList!.length ; i++)
        {
          if(product.mealsId == cartList![i].meal!.mealId)
          {
            return true;
          }
        }
        return false;
      }
    return false;
  }

  CartData? getCartProduct(AllMeals? product) {
    if(product!=null && cartList!=null)
    {
      for(int i=0 ; i < cartList!.length ; i++)
      {
        if(product.mealsId == cartList![i].meal!.mealId)
        {
          return cartList![i];
        }
      }
      return null;
    }
    return null;
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

  getSpecialItem(){
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

}