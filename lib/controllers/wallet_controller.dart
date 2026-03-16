import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tailoredtiffin/model/pay_wallet_model.dart';
import 'package:tailoredtiffin/model/wallet_model.dart';

import '../api/api_manager.dart';
import '../model/response_model.dart';
import '../utils/connection_utils.dart';
import '../utils/prefs.dart';
import '../utils/ui_utils.dart';

class WalletController extends GetxController{

  String? authToken,userId;
  List<Transaction> walletList = <Transaction>[];
  bool? isLoading = false;
  String totalAmount = "0";
  late Razorpay _razorpay;
  String? currentOrderId,orderId;

  @override
  void onInit() {
    super.onInit();
    getPrefs();

    _razorpay = Razorpay();
    print(Razorpay.EVENT_PAYMENT_SUCCESS);
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
    getWalletHistory();
  }

  getWalletHistory(){
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();

        try{
          final WalletModel model = await ApiManager.fetchWalletHistory(authToken: authToken!);

          if(model.status == 'success' && model.data!=null) {
            totalAmount = model.data!.balance ?? "0";
            walletList = model.data!.transactions ?? [];

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

  payWallet() {
    // if(editGlobalKey.currentState!.validate())
    // {
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();
        try{

          print(totalAmount);
          print("dmksadkjsadkjsad");

          final PayWalletModel responseModel = await ApiManager.payWallet(
              authToken: authToken!,
              amount: double.parse(totalAmount)
          );

          print("Data Response ${responseModel.status}");
          if(responseModel.status == 'success') {
            isLoading = false;
            update();
            final razor = responseModel.data!.razorpay!;
            currentOrderId = responseModel.data!.razorpay!.orderId;

            _openRazorpay(
              key: razor.key!,
              orderId: razor.orderId!,
              amount: int.parse(razor.amount!), // in paise
              currency: razor.currency!,
            );

          }else{
            isLoading = false;
            update();
            UIUtils.bottomToast(text: responseModel.msg!, isError: true);
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
      'name': 'Satvik Bhojan',
      'description': 'Wallet Payment',
      'prefill': {
        'contact': '',
        'email': '',
      },
      'theme': {
        'color': '#2e6418',
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

  verifyPayment({String? paymentId,String? signature}) {
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();
        print("asdnsadnkjasndsadsadasd");
        print(paymentId);
        print(signature);
        try{

          print("This is call");
          final ResponseModel responseModel = await ApiManager.verifyPayment(
            paymentFor: "wallet_pending",
            walletAmount: double.parse(totalAmount),
            authToken: authToken!,
            orderId: 0,
            razorpayOrderId: currentOrderId!,
            razorpayPaymentId: paymentId!,
            razorpaySignature: signature!,
          );

          print(responseModel.status);
          print(responseModel.data);
          print("adnsahdghashjdasdasdas");

          if(responseModel.status == 'success') {
            isLoading = false;
            update();
            UIUtils.bottomToast(text: responseModel.msg!, isError: false);
            getWalletHistory();

          }else{
            isLoading = false;
            update();
            UIUtils.bottomToast(text: responseModel.msg!, isError: true);
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