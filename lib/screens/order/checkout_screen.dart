import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/bottom/cart_controller.dart';
import 'package:tailoredtiffin/controllers/order_controller.dart';
import 'package:tailoredtiffin/screens/address/add_address_screen.dart';
import 'package:tailoredtiffin/utils/config.dart';

import '../../controllers/address_controller.dart';
import '../../model/cart_model.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  var orderCtrl = Get.find<OrderController>();
  var cartCtrl = Get.find<CartController>();

  Future<bool> _onBackPressed() async{
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    Get.back();
    return false;
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
                backgroundColor: appCtrl.appTheme.white,
                appBar: CommonAppbar(
                  title: 'Checkout',
                  backEnable: true,
                  centerTitle: true,
                  bgColor: appCtrl.appTheme.white,
                  leadingOnTap: () => _onBackPressed(),
                ),
                body: cartCtrl.isLoading ? Center(child: CircularProgressIndicator(color: appCtrl.appTheme.primary,),) : ListView(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.heightSize,horizontal: 0
                  ),
                  children: [

                    //total
                    Row(
                      mainAxisAlignment: mainSpaceBet,
                      children: [
                        Text('My order',style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.primary),),
                        addHorizontalSpace(Dimensions.widthSize),
                        Text('\u20b9${cartCtrl.payableAmount}',style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.primary),),
                      ],
                    ).paddingSymmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize*0.5),

                    //cart items
                    Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: LinearBorder.none,
                      color: appCtrl.appTheme.btnSecondary,
                      child: Column(
                        children: [
                          for(int i=0 ; i<cartCtrl.cartList!.length ; i++)
                            _cartItem(cartCtrl.cartList![i]),
                        ],
                      ),
                    ),

                    addVerticalSpace(Dimensions.heightSize),

                    //delivery address
                    _titleWidget('Shipping & payment info'.toUpperCase()),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radius),
                        side: BorderSide(color: appCtrl.appTheme.borderColor)
                      ),
                      margin: EdgeInsets.symmetric(horizontal: Dimensions.widthSize,vertical: 0),
                      color: appCtrl.appTheme.white,
                      child: Column(
                        children: [
                          Text(orderCtrl.selectedAddress !=null
                              ? '${orderCtrl.selectedAddress!.fullAddress},${orderCtrl.selectedAddress!.landmark},'
                              '${orderCtrl.selectedAddress!.city},${orderCtrl.selectedAddress!.state},${orderCtrl.selectedAddress!.pincode}'
                              : 'Enter your address',
                            softWrap: true,
                            style: AppCss.mulishMedium13.textColor(appCtrl.appTheme.primary),
                          ).paddingSymmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize*0.5),
                          Row(
                            children: [
                              _titleWidget('Payment Type'.toUpperCase()),
                              Text(
                                orderCtrl.isCod ? 'COD' : 'Online',
                                style: AppCss.mulishMedium13.textColor(appCtrl.appTheme.primary),
                              ),
                            ],
                          )
                        ],
                      ),
                    )

                  ],
                ),
                bottomNavigationBar: PrimaryButtonWidget(
                    onPressed:() => orderCtrl.placeOrderMethod(),
                    text: 'Proceed to checkout'
                ).marginSymmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize),
              );
            },
        )
    );
  }

  _titleWidget(String title) {
    return Text(title,
      style: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.secondaryText),
    ).marginSymmetric(vertical: Dimensions.heightSize*0.5,horizontal: Dimensions.widthSize);
  }

  Widget _cartItem(CartData product) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: crossStart,
        mainAxisAlignment: mainSpaceBet,
        children: [
          Expanded(
            flex: 5,
            child: Text(product.meal!.name!,
              style: AppCss.mulishMedium15.textColor(appCtrl.appTheme.secondaryText),),
          ),
          addHorizontalSpace(Dimensions.widthSize),
          Expanded(
            flex: 5,
            child: Text('1 x \u20b9${product.totalPrice}',
              style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.hintColor),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize*0.5);
  }

}
