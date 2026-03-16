import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tailoredtiffin/utils/config.dart';
import 'package:tailoredtiffin/widgets/empty_layout.dart';
import 'package:tailoredtiffin/widgets/shimmer_layout.dart';

import '../controllers/delivery_boy_order_details_controller.dart';
import '../model/delivery_boy_order_details_model.dart' show Schedule, Item, Subji, ExtraItem;

class DeliveryBoyOrderDetailScreen extends StatefulWidget {
  const DeliveryBoyOrderDetailScreen({super.key});

  @override
  State<DeliveryBoyOrderDetailScreen> createState() => _DeliveryBoyOrderDetailScreenState();
}

class _DeliveryBoyOrderDetailScreenState extends State<DeliveryBoyOrderDetailScreen> {
  var orderCtrl = Get.put(DeliveryBoyOrderDetailController());

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
        child: GetBuilder<DeliveryBoyOrderDetailController>(
          builder: (controller) {
            return Scaffold(
              backgroundColor: appCtrl.appTheme.white,
              appBar: CommonAppbar(
                title: 'Order Details',
                backEnable: true,
                centerTitle: true,
                bgColor: appCtrl.appTheme.white,
                leadingOnTap: () => _onBackPressed(),
              ),
              body: orderCtrl.isLoading
                  ? CommonShimmerLayout()
                  : orderCtrl.orderData != null
                  ? ListView(
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.heightSize,horizontal: Dimensions.widthSize
                ),
                children: [

                  //total
                  Row(
                    mainAxisAlignment: mainSpaceBet,
                    children: [
                      Text('Paid Total',style: AppCss.mulishSemiBold15.textColor(appCtrl.appTheme.primary),),
                      addHorizontalSpace(Dimensions.widthSize),
                      Text('\u20b9${orderCtrl.orderData!.order!.totalAmount}',
                        style: AppCss.mulishSemiBold15.textColor(appCtrl.appTheme.primary),),
                    ],
                  ),

                  //status
                  Row(
                    crossAxisAlignment: crossStart,
                    mainAxisAlignment: mainSpaceBet,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text('Order Status',
                          style: AppCss.mulishMedium15.textColor(appCtrl.appTheme.primary),),
                      ),
                      addHorizontalSpace(Dimensions.widthSize),
                      Expanded(
                        flex: 5,
                        child: //status
                        Row(
                          crossAxisAlignment: crossCenter,
                          mainAxisAlignment: mainEnd,
                          children: [
                            Text(orderCtrl.orderData!.order!.status!.toLowerCase() == 'active' ? "Active" : "In-Active",
                              style: AppCss.mulishRegular14.textColor(orderCtrl.getStatusColor()),),
                            // addHorizontalSpace(Dimensions.widthSize*0.2),
                            // SvgPicture.asset(orderCtrl.getStatusIcon(),height: 18,width: 18,)
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: crossStart,
                    mainAxisAlignment: mainSpaceBet,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text('Payment Status',
                          style: AppCss.mulishMedium15.textColor(appCtrl.appTheme.primary),),
                      ),
                      addHorizontalSpace(Dimensions.widthSize),
                      Expanded(
                        flex: 5,
                        child: //status
                        Row(
                          crossAxisAlignment: crossCenter,
                          mainAxisAlignment: mainEnd,
                          children: [
                            Text(orderCtrl.orderData!.order!.isPaid == '0' ? "Pay Later" : "Paid",
                              style: AppCss.mulishRegular14.textColor(orderCtrl.getPaymentColor()),),
                            // addHorizontalSpace(Dimensions.widthSize*0.2),
                            // SvgPicture.asset(orderCtrl.getStatusIcon(),height: 18,width: 18,)
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: crossStart,
                    mainAxisAlignment: mainSpaceBet,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text('Order Date',
                          style: AppCss.mulishMedium15.textColor(appCtrl.appTheme.primary),),
                      ),
                      addHorizontalSpace(Dimensions.widthSize),
                      Expanded(
                        flex: 5,
                        child: //status
                        Row(
                          crossAxisAlignment: crossCenter,
                          mainAxisAlignment: mainEnd,
                          children: [
                            Text(DateFormat('MMM dd,yyyy').format(orderCtrl.orderData!.order!.createdAt!),
                              style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.hintColor),),
                            // addHorizontalSpace(Dimensions.widthSize*0.2),
                            // SvgPicture.asset(orderCtrl.getStatusIcon(),height: 18,width: 18,)
                          ],
                        ),
                      ),
                    ],
                  ),

                  addVerticalSpace(Dimensions.heightSize*0.5),
                  for(int i=0 ; i<orderCtrl.orderData!.schedules!.length ; i++)
                    _scheduleItem(orderCtrl.orderData!.schedules![i]),
                  addVerticalSpace(Dimensions.heightSize*0.5),
                  _divider(),
                  //cart items
                  for(int i=0 ; i<orderCtrl.orderData!.items!.length ; i++)
                    _cartItem(orderCtrl.orderData!.items![i]),

                  addVerticalSpace(Dimensions.heightSize),

                ],
              ) : EmptyLayout(
                image: assets.orderFailurePng,
                title: 'Sorry! Data not found!!',
                subtitle: 'Something went wrong! Please try again later',
                btnText: 'Try Again',
                onBtnTap: () => orderCtrl.getDetails()
                ,),
              // bottomNavigationBar: PrimaryButtonWidget(
              //     onPressed:() => orderCtrl.placeOrderMethod(),
              //     text: 'Proceed to checkout'
              // ).marginSymmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize),
            );
          },
        )
    );
  }

  _divider()
  {
    return Divider(
      color: appCtrl.appTheme.hintColor,
      thickness: 0.5,
      height: Dimensions.heightSize,
    );
  }

  _titleWidget(String title) {
    return Text(title,
      style: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.secondaryText),
    ).marginSymmetric(vertical: Dimensions.heightSize*0.5,horizontal: Dimensions.widthSize);
  }

  Widget _scheduleItem(Schedule product) {
    return IntrinsicHeight(
        child: Column(
          crossAxisAlignment: crossStart,
          mainAxisAlignment: mainCenter,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(product.slot!.toUpperCase(),
                    style: AppCss.mulishMedium15.textColor(appCtrl.appTheme.textColor),),
                ),
                Text(DateFormat('MMM dd,yyyy').format(product.deliveryDate!),
                  style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.secondaryText),),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(product.fullAddress!,
                    style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.secondaryText),
                  ),
                ),
                Text(product.status!,
                  style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.secondaryText),),
              ],
            )
          ],
        )
    ).marginOnly(top: Dimensions.heightSize*0.5);
  }

  Widget _cartItem(Item product) {
    return IntrinsicHeight(
        child: Column(
          crossAxisAlignment: crossStart,
          mainAxisAlignment: mainCenter,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(product.meal!.name!,
                    style: AppCss.mulishMedium15.textColor(appCtrl.appTheme.secondaryText),),
                ),
                Text('\u20b9${product.price}',
                  style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.primary),),
              ],
            ),
            Row(
              mainAxisAlignment: mainSpaceBet,
              children: [
                Text('Quantity: ${product.quantity}',
                  style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.hintColor),
                ),
                Text('Total Subji: ${product.meal!.subjiCount}',
                  style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.hintColor),
                ),
                Text('Total Bread: ${product.meal!.breadCount}',
                  style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.hintColor),
                )
              ],
            ),
            addVerticalSpace(Dimensions.heightSize*0.5),
            product.selectedItems!.subjis!.isNotEmpty ? Text(
              "Selected Subji",
              style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.primary),
            ) : Container(),
            product.selectedItems!.subjis!.isNotEmpty ? addVerticalSpace(Dimensions.heightSize*0.2) : Container(),
            for(int i=0 ; i<product.selectedItems!.subjis!.length ; i++)
              _subjiItem(product.selectedItems!.subjis![i]),
            addVerticalSpace(Dimensions.heightSize*0.5),
            product.selectedItems!.bread != null ? Text(
              "Selected Bread",
              style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.primary),
            ) : Container(),
            product.selectedItems!.bread != null ? addVerticalSpace(Dimensions.heightSize*0.2) : Container(),
            product.selectedItems!.bread != null ? Row(
              children: [
                Expanded(
                  child: Text(product.selectedItems!.bread!.name!,
                    style: AppCss.mulishMedium15.textColor(appCtrl.appTheme.secondaryText),),
                ),
                Text('\u20b9${product.selectedItems!.bread!.price}',
                  style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.primary),),
              ],
            ) : Container(),
            addVerticalSpace(Dimensions.heightSize*0.5),
            product.extraItems!.isNotEmpty ? Text(
              "Extra Items",
              style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.primary),
            ) : Container(),
            product.extraItems!.isNotEmpty ? addVerticalSpace(Dimensions.heightSize*0.2) : Container(),
            for(int i=0 ; i<product.extraItems!.length ; i++)
              _extraItem(product.extraItems![i]),

          ],
        )
    ).marginOnly(top: Dimensions.heightSize*0.5);
  }

  Widget _subjiItem(Subji product) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: crossStart,
        mainAxisAlignment: mainCenter,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(product.name!,
                  style: AppCss.mulishMedium15.textColor(appCtrl.appTheme.secondaryText),),
              ),
              Text('\u20b9${product.price}',
                style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.primary),),
            ],
          ),
        ],
      ),
    );
  }

  Widget _extraItem(ExtraItem product) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: crossStart,
        mainAxisAlignment: mainCenter,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(product.name!,
                  style: AppCss.mulishMedium15.textColor(appCtrl.appTheme.secondaryText),),
              ),
              Text('${product.quantity!} x \u20b9${product.price}',
                style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.primary),),
            ],
          ),
        ],
      ),
    );
  }

}
