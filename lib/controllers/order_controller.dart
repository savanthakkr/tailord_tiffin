import 'dart:math';

import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tailoredtiffin/controllers/bottom/cart_controller.dart';
import 'package:tailoredtiffin/model/address_model.dart';
import 'package:tailoredtiffin/model/create_payment_model.dart';
import 'package:tailoredtiffin/model/order_resp_model.dart';
import 'package:tailoredtiffin/model/verify_payment_model.dart';
import 'package:tailoredtiffin/screens/bottom/user_bottom_screen.dart';
import 'package:tailoredtiffin/screens/order/common_order_layout.dart';
import 'package:tailoredtiffin/screens/order_history_screen.dart';
import 'package:tailoredtiffin/widgets/empty_layout.dart';

import '../model/response_model.dart';
import '../screens/order/cc_avenue_payment.dart';
import '../utils/config.dart';

enum PaymentType { card, upi, postpaid, paylater, cod }

class OrderController extends GetxController{
  bool isLoading=false,isCod=false,isFixed=false,isLunch=true;
  String? authToken,userId;
  Address? selectedAddress;
  double mHeight=0,mWidth=0;
  List<DateTime> selectedDates = [];
  late Razorpay _razorpay;
  String? currentOrderId,orderId;
  double? orderAmount;
  bool isLunchActive = true;
  PaymentType selected = PaymentType.card;
  PaymentType current = PaymentType.card;

  bool isAfterCutoff() {
    final now = DateTime.now();
    return now.hour >= 18; // after 6 PM
  }

  void setDefaultAddress(List<Address> addressList) {
    for (var address in addressList) {
      if (address.isDefault == "1") {
        selectedAddress = address;
        break;
      }
    }
    update();
  }


  void initDefaultDeliveryDate() {
    final now = DateTime.now();

    if (now.hour >= 18) {
      // After 6 PM → tomorrow
      final tomorrow = now.add(const Duration(days: 1));

      selectedDates.clear();
      selectedDates.add(
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day),
      );
    } else {
      // Before 6 PM → today
      selectedDates.clear();
      selectedDates.add(
        DateTime(now.year, now.month, now.day),
      );
    }

    update();
  }

  void select(PaymentType type) {
    selected = type;
    current = selected;
    update();
  }

  void save() {
    current = selected;
    update();
  }

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
    updateMealTypeByTime();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  void getPrefs()
  {
    authToken = Prefs.shared.getString(Prefs.authToken);
    userId = Prefs.shared.getString(Prefs.userId);
  }

  void toggleDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);

    if (selectedDates.any((d) =>
    d.year == normalized.year &&
        d.month == normalized.month &&
        d.day == normalized.day)) {
      selectedDates.removeWhere((d) =>
      d.year == normalized.year &&
          d.month == normalized.month &&
          d.day == normalized.day);
    } else {
      selectedDates.add(normalized);
    }

    update();
  }

  /// Convert to API format
  List<String> get deliveryDateStrings {
    return selectedDates
        .map((d) =>
    "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}")
        .toList();
  }

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

  placeOrderMethod() {
    // if(editGlobalKey.currentState!.validate())
    // {
      ConnectionUtils.checkConnection().then((internet) async {
        if (internet) {
          isLoading = true;
          update();
          try{

            final OrderRespModel responseModel = await ApiManager.placeOrder(
                authToken: authToken!,
                addressId: int.parse(selectedAddress!.addressId!),
                delivery_dates: deliveryDateStrings,
                payment_type: current == PaymentType.cod ? 'cod' : current == PaymentType.card ? 'card' : current == PaymentType.upi ? 'upi' :
                current == PaymentType.postpaid ? 'postpaid' : 'pay_later',
                selection_mode: !isFixed ? 'flexible' : 'fixed',
                // selection_mode: 'fixed',
                slot: isLunchActive ? 'lunch' : 'dinner'
            );

            if(responseModel.status == 'success') {
              isLoading = false;
              update();
              if (current == PaymentType.cod || current == PaymentType.paylater) {
                var cartCtrl = Get.find<CartController>();
                cartCtrl.cartList?.clear();
                cartCtrl.payableAmount = "0";
                cartCtrl.cartCount = 0;
                cartCtrl.update(['cartList','cartCount']);
                Get.offAll(() => const CommonOrderLayout(isSuccess: true));
                return;
              }

              final razor = responseModel.data!.razorpay!;
              currentOrderId = responseModel.data!.razorpay!.orderId;
              orderId = responseModel.data!.orderId;
              orderAmount = double.parse(responseModel.data!.razorpay!.amount!)/100;

              createCcAvenuePayment();

              // _openRazorpay(
              //   key: razor.key!,
              //   orderId: razor.orderId!,
              //   amount: int.parse(razor.amount!), // in paise
              //   currency: razor.currency ?? "INR",
              // );

            }else{
              isLoading = false;
              update();
              UIUtils.bottomToast(text: responseModel.msg!, isError: true);
              Get.offAll(()=> const CommonOrderLayout(isSuccess: false));
            }

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
    // }
    // else{
    //   autoValidate = AutovalidateMode.onUserInteraction;
    //   update();
    // }
  }

  createCcAvenuePayment() {
    // if(editGlobalKey.currentState!.validate())
    // {
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();
        try{

          final CreatePaymentModel responseModel = await ApiManager.createPayment(
              authToken: authToken!,
              orderId: orderId!
          );

          if(responseModel.status!) {
            isLoading = false;
            update();
            final result = await Get.to(
                  () => CCAvenuePayment(
                encRequest: responseModel.encRequest!,
                accessCode: responseModel.accessCode!,
              ),
            );

            if (result == "success") {

              verifyCcAvenuePayment();

            } else {

              UIUtils.bottomToast(text: responseModel.message!, isError: true);
            }
          } else {
            isLoading = false;
            update();
            UIUtils.bottomToast(text: responseModel.message!, isError: true);
            Get.offAll(()=> const CommonOrderLayout(isSuccess: false));
          }

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
    // }
    // else{
    //   autoValidate = AutovalidateMode.onUserInteraction;
    //   update();
    // }
  }

  void _openRazorpay({
    required String key,
    required String orderId,
    required int amount,
    required String currency,
  }) {
    var options = {
      'key': key,
      'amount': amount,
      'currency': currency,
      'order_id': orderId,
      'name': 'Tailored Tiffin',
      'description': 'Tiffin Order Payment',
      'prefill': {
        'contact': '',
        'email': '',
      },
      'theme': {
        'color': '#4BB649',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      UIUtils.bottomToast(text: 'Unable to open payment', isError: true);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    verifyPayment(paymentId: response.paymentId,signature: response.signature);
    print("Data of razorpay ${response.paymentId} ${response.signature}");
  }

  verifyCcAvenuePayment() {
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();
        try{

          final VerifyPaymentModel responseModel = await ApiManager.verifyCcavenuePayment(
            authToken: authToken!,
            orderId: orderId!,
          );

          if(responseModel.status!) {
            isLoading = false;
            update();
            var cartCtrl = Get.find<CartController>();
            cartCtrl.cartList?.clear();
            cartCtrl.payableAmount = "0";
            cartCtrl.cartCount = 0;
            cartCtrl.update(['cartList','cartCount']);
            Get.offAll(() => const CommonOrderLayout(isSuccess: true));

          }else{
            isLoading = false;
            update();
            UIUtils.bottomToast(text: responseModel.message!, isError: true);
            var cartCtrl = Get.find<CartController>();
            cartCtrl.cartList?.clear();
            cartCtrl.payableAmount = "0";
            cartCtrl.cartCount = 0;
            cartCtrl.update(['cartList','cartCount']);
            Get.offAll(()=> const CommonOrderLayout(isSuccess: false));
          }

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
    // }
    // else{
    //   autoValidate = AutovalidateMode.onUserInteraction;
    //   update();
    // }
  }

  verifyPayment({String? paymentId,String? signature}) {
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();
        try{

          final ResponseModel responseModel = await ApiManager.verifyPayment(
              paymentFor: "order",
              walletAmount: orderAmount,
              authToken: authToken!,
              orderId: int.parse(orderId!),
              razorpayOrderId: currentOrderId!,
              razorpayPaymentId: paymentId!,
              razorpaySignature: signature!,
          );

          if(responseModel.status == 'success') {
            isLoading = false;
            update();
            var cartCtrl = Get.find<CartController>();
            cartCtrl.cartList?.clear();
            cartCtrl.payableAmount = "0";
            cartCtrl.cartCount = 0;
            cartCtrl.update(['cartList','cartCount']);
            Get.offAll(() => const CommonOrderLayout(isSuccess: true));

          }else{
            isLoading = false;
            update();
            UIUtils.bottomToast(text: responseModel.msg!, isError: true);
            var cartCtrl = Get.find<CartController>();
            cartCtrl.cartList?.clear();
            cartCtrl.payableAmount = "0";
            cartCtrl.cartCount = 0;
            cartCtrl.update(['cartList','cartCount']);
            Get.offAll(()=> const CommonOrderLayout(isSuccess: false));
          }

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
    // }
    // else{
    //   autoValidate = AutovalidateMode.onUserInteraction;
    //   update();
    // }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    UIUtils.bottomToast(
      text: response.message!,
      isError: true,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    UIUtils.bottomToast(
      text: 'External wallet selected',
      isError: false,
    );
  }

}