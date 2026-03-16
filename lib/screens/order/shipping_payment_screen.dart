import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/bottom/cart_controller.dart';
import 'package:tailoredtiffin/controllers/order_controller.dart';
import 'package:tailoredtiffin/screens/address/add_address_screen.dart';
import 'package:tailoredtiffin/screens/order/checkout_screen.dart';
import 'package:tailoredtiffin/utils/config.dart';

import '../../controllers/address_controller.dart';
import '../../widgets/shimmer_layout.dart';


class ShippingPaymentScreen extends StatefulWidget {
  const ShippingPaymentScreen({super.key});

  @override
  State<ShippingPaymentScreen> createState() => _ShippingPaymentScreenState();
}

class _ShippingPaymentScreenState extends State<ShippingPaymentScreen> {
  var orderCtrl = Get.put(OrderController());
  var addressCtrl = Get.find<AddressController>();
  String? allow_pay_later;

  Future<bool> _onBackPressed() async{
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    Get.back();
    return false;
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  void getPrefs()
  {
    allow_pay_later = Prefs.shared.getString(Prefs.allowPayLater);
    print(allow_pay_later);
    print("ndjhsajdhasdsadas");
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
          if (context.mounted) {
            _onBackPressed();
          }
        },
        child: GetBuilder<OrderController>(
            builder: (controller) {
              return Scaffold(
                appBar: CommonAppbar(
                  title: 'Payment Methods',
                  backEnable: true,
                  centerTitle: true,
                  bgColor: appCtrl.appTheme.white,
                  leadingOnTap: () => _onBackPressed(),
                ),
                body: controller.isLoading ? const CommonShimmerLayout(hasBanner: false,) : ListView(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.heightSize,horizontal: Dimensions.widthSize
                  ),
                  children: [
                    _currentMethod(controller),
                    addVerticalSpace(Dimensions.heightSize*2),
                    Text(
                      "Available Payment Methods",
                      style: AppCss.mulishBold18.textColor(appCtrl.appTheme.textColor),
                    ),
                    addVerticalSpace(Dimensions.heightSize*0.2),
                    Text(
                      "Choose your preferred payment method for orders.",
                      style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.secondaryText),
                    ),
                    addVerticalSpace(Dimensions.heightSize*1.2),
                    _tile(controller, PaymentType.card),
                    _tile(controller, PaymentType.upi),
                    _tile(controller, PaymentType.postpaid),
                    _tile(controller, PaymentType.paylater),
                    _tile(controller, PaymentType.cod),
                    addVerticalSpace(Dimensions.heightSize*1.8),
                    _infoBox(),
                  ],
                ),
                bottomNavigationBar: PrimaryButtonWidget(
                    onPressed: () {
                      if(orderCtrl.selectedAddress == null){
                        UIUtils.bottomToast(text: 'Please select address', isError: true);
                      } else if(orderCtrl.selectedDates.isEmpty){
                        UIUtils.bottomToast(text: 'Please select at-least one date', isError: true);
                      }  else {
                        orderCtrl.save();
                        orderCtrl.placeOrderMethod();
                      }
                    },
                    text: 'Proceed to checkout'
                ).marginSymmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize),
              );
            },
        )
    );
  }

  Widget _currentMethod(OrderController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Current Payment Method",
            style: AppCss.mulishBold18.textColor(appCtrl.appTheme.textColor)),
        addVerticalSpace(Dimensions.heightSize),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: appCtrl.appTheme.deliveryBg,
            borderRadius: BorderRadius.circular(Dimensions.radius),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: appCtrl.appTheme.deliveryIcon),
              addHorizontalSpace(Dimensions.widthSize),
              Text(_title(ctrl.current),
                  style: AppCss.mulishBold14.textColor(appCtrl.appTheme.primary)),
            ],
          ),
        )
      ],
    );
  }

  Widget _saveButton(OrderController ctrl) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      color: Colors.white,
      child: SafeArea(
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: ctrl.save,
            child: const Text("Save Payment Method",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }

  Widget _tile(OrderController ctrl, PaymentType type) {

    final selected = ctrl.selected == type;

    return GestureDetector(
      onTap: () => ctrl.select(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? appCtrl.appTheme.deliveryBg : appCtrl.appTheme.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? appCtrl.appTheme.primary : appCtrl.appTheme.borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: selected ? appCtrl.appTheme.primary : appCtrl.appTheme.borderColor,
                shape: BoxShape.circle,
              ),
              child: Icon(_icon(type),
                  color: selected ? appCtrl.appTheme.white : appCtrl.appTheme.secondaryText),
            ),
            addHorizontalSpace(Dimensions.widthSize),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_title(type),
                      style: AppCss.mulishBold14.textColor(appCtrl.appTheme.textColor)),
                  addVerticalSpace(Dimensions.heightSize*0.4),
                  Text(_subtitle(type),
                      style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.secondaryText)),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? appCtrl.appTheme.primary : appCtrl.appTheme.secondaryText,
            )
          ],
        ),
      ),
    );
  }

  Widget _infoBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: appCtrl.appTheme.deliveryBg,
        borderRadius: BorderRadius.circular(Dimensions.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: appCtrl.appTheme.primary),
              addHorizontalSpace(Dimensions.widthSize),
              Text("Payment Information",
                  style: AppCss.mulishBold14.textColor(appCtrl.appTheme.textColor)),
            ],
          ),
          addVerticalSpace(Dimensions.heightSize),
          Text("• Card/UPI: Secure online payment options",style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.textColor),),
          Text("• All transactions are secure and encrypted",style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.textColor),),
          Text("• You can change your payment method anytime",style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.textColor),),
        ],
      ),
    );
  }

  IconData _icon(PaymentType t) {
    switch (t) {
      case PaymentType.card: return Icons.credit_card;
      case PaymentType.upi: return Icons.phone_android;
      case PaymentType.postpaid: return Icons.calendar_month;
      case PaymentType.paylater: return Icons.payments;
      case PaymentType.cod: return Icons.payments_outlined;
    }
  }

  String _title(PaymentType t) {
    switch (t) {
      case PaymentType.card: return "Credit/Debit Card";
      case PaymentType.upi: return "UPI Payment";
      case PaymentType.postpaid: return "Postpaid (Premium)";
      case PaymentType.paylater: return "Pay Later";
      case PaymentType.cod: return "Cash on Delivery";
    }
  }

  String _subtitle(PaymentType t) {
    switch (t) {
      case PaymentType.card: return "Pay securely with your credit or debit card";
      case PaymentType.upi: return "Pay instantly using UPI apps like GPay, PhonePe, Paytm";
      case PaymentType.postpaid: return "Subscribe to access postpaid billing";
      case PaymentType.paylater: return "Order now and pay later as per your billing cycle";
      case PaymentType.cod: return "Pay with cash when your order is delivered";
    }
  }

  _titleWidget(String title) {
    return Text(title,
      style: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.secondaryText),
    ).marginSymmetric(vertical: Dimensions.heightSize*0.5);
  }

  _addressSheet()
  {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      showDragHandle: true,
      backgroundColor: appCtrl.appTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      constraints: BoxConstraints(
        minHeight: 100,
        maxHeight: orderCtrl.mHeight*0.5
      ),
      builder: (context) {
        return GetBuilder<AddressController>(
          builder: (ctrl) {
            return ListView(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.heightSize,horizontal: Dimensions.widthSize),
              children: [

                _titleWidget('Saved Address'.toUpperCase()),
                for(int i=0 ; i<addressCtrl.addressList.length ; i++)
                  CheckboxListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius),
                      side: BorderSide(color: appCtrl.appTheme.borderColor)
                    ),
                    value: addressCtrl.addressList[i] == orderCtrl.selectedAddress,
                    onChanged: (value) {
                      orderCtrl.selectedAddress = addressCtrl.addressList[i];
                      orderCtrl.update();
                      Navigator.of(context).pop();
                    },
                    title: Text('${addressCtrl.addressList[i].fullAddress},${addressCtrl.addressList[i].landmark},'
                        '${addressCtrl.addressList[i].city},${addressCtrl.addressList[i].state},'
                        '${addressCtrl.addressList[i].pincode}',
                      style: AppCss.mulishMedium14.textColor(
                          appCtrl.appTheme.primary),
                      softWrap: true,),
                  ),

                addVerticalSpace(Dimensions.heightSize),

                PrimaryButtonWidget(
                    onPressed: () {
                      addressCtrl.clearAddressFields();
                      Get.to(()=> const AddAddressScreen());
                    },
                    text: '+ New Address')
              ],
            );
          }
        );
      },
    );
  }

  Future<void> _pickDeliveryDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),

      /// 🎨 THEME OVERRIDE
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: appCtrl.appTheme.primary,      // header & selected date
              onPrimary: appCtrl.appTheme.white,       // text on primary
              onSurface: appCtrl.appTheme.textColor,   // normal text
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: appCtrl.appTheme.primary, // OK / CANCEL
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      orderCtrl.toggleDate(picked);
    }
  }


}
