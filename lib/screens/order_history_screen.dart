import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tailoredtiffin/controllers/history_controller.dart';
import 'package:tailoredtiffin/model/order_model.dart';
import 'package:tailoredtiffin/screens/bottom/user_bottom_screen.dart';
import 'package:tailoredtiffin/screens/order_detail_screen.dart';
import 'package:tailoredtiffin/widgets/empty_layout.dart';
import 'package:tailoredtiffin/widgets/rounded_icon.dart';
import 'package:tailoredtiffin/widgets/shimmer_layout.dart';

import '../utils/config.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  var historyCtrl = Get.put(HistoryController());

  Future<bool> _onBackPressed() async{
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    if(Get.previousRoute!="") {
      Get.back();
    }
    else{
      Get.offAll(()=> const UserBottomBar());
    }
    return false;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appCtrl.appTheme.white,
      body: GetBuilder<HistoryController>(
        builder: (ctrl) {
          return historyCtrl.isLoading
              ? const CommonShimmerLayout(hasBanner: false)
              : historyCtrl.orderList.isNotEmpty
              ? Column(
                children: [
                  addVerticalSpace(Dimensions.heightSize*3),
                  RoundedIconWidget(
                      height: 60,
                      color: appCtrl.appTheme.primary,
                      iconColor: appCtrl.appTheme.white,
                      padding: Dimensions.defaultPaddingSize*1.5,
                      svgAsset: assets.orderHistorySvg),
                  addVerticalSpace(Dimensions.heightSize),
                  Text(
                    "Order History",
                    style: AppCss.mulishMedium20.textColor(appCtrl.appTheme.textColor),
                  ),
                  addVerticalSpace(Dimensions.heightSize*0.1),
                  Text(
                    "Your delicious journey with us",
                    style: AppCss.mulishMedium12.textColor(appCtrl.appTheme.secondaryText),
                  ),
                  addVerticalSpace(Dimensions.heightSize*2.5),
                  orderTypeSelector(
                    selected: ctrl.orderType,
                    onChanged: ctrl.setOrderType,
                  ).marginSymmetric(horizontal: 15),
                  addVerticalSpace(Dimensions.heightSize),
                  Expanded(
                    child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: historyCtrl.orderList.length,
                                itemBuilder: (context, index) {
                    return _orderItem(historyCtrl.orderList[index]);
                                },
                              ),
                  ),
                ],
              )
              : EmptyLayout(
            image: assets.bookPng,
            title: 'Your order history is currently empty!',
            subtitle:
            'Start filling it up with your past purchases.',
            btnText: 'Shop Now',
            onBtnTap: () {
              Get.offAll(() => const UserBottomBar());
            },
          );
        },
      ),
    );
  }

  Widget _orderItem(OrderData order) {
    Color color = (order.schedules != null &&
        order.schedules!.isNotEmpty &&
        order.schedules!.first.status == "scheduled")
        ? appCtrl.appTheme.paymentIcon
        : appCtrl.appTheme.primary;

    String svgIcon = order.isPaid == '0'
        ? assets.closeSvg
        : order.isPaid == '1'
        ? assets.checkSvg
        : assets.truckSvg ;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize*0.2),
      child: Card(
        elevation: 2,
        color: appCtrl.appTheme.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(Dimensions.radius*1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: crossStart,
            children: [
              Row(
                mainAxisAlignment: mainSpaceBet,
                children: [
                  Text('#TT-${order.orderId}',
                    style: AppCss.mulishBold14.textColor(
                        appCtrl.appTheme.textColor),),
                  addHorizontalSpace(Dimensions.widthSize*0.5),
                  Row(
                    crossAxisAlignment: crossCenter,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize*0.35),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: order.status!.toLowerCase() == "active" ? appCtrl.appTheme.deliveryBg : appCtrl.appTheme.paymentBg,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline_rounded,color: color,size: 16,),
                            addHorizontalSpace(Dimensions.widthSize*0.2),
                            Text(
                              (order.schedules != null &&
                                  order.schedules!.isNotEmpty &&
                                  order.schedules!.first.status == "scheduled")
                                  ? "Confirmed"
                                  : "Delivered",
                              style: AppCss.mulishRegular12.textColor(color),
                            ),
                          ],
                        ),
                      )

                      // addHorizontalSpace(Dimensions.widthSize*0.2),
                      // SvgPicture.asset(svgIcon,height: 18,width: 18,)
                    ],
                  ),
                ],
              ),
              addVerticalSpace(Dimensions.heightSize*0.3),
              Row(
                mainAxisAlignment: mainSpaceBet,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Orderd: ${DateFormat('MMM dd,yyyy hh:mm a').format(order.createdAt!)}",
                        style: AppCss.mulishRegular12.textColor(
                            appCtrl.appTheme.secondaryText),),
                      addVerticalSpace(Dimensions.heightSize*0.3),
                      Text("${order.slot!.toUpperCase()} - ${DateFormat('MMM dd yyyy').format(order.createdAt!)}",
                        style: AppCss.mulishMedium12.textColor(
                            appCtrl.appTheme.primary),),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize*0.35),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: order.isPaid == '0' ? appCtrl.appTheme.logoutBg : appCtrl.appTheme.deliveryBg,
                    ),
                    child: Text(order.isPaid == '0' ? "Not Paid" : "Paid",
                      style: AppCss.mulishSemiBold12.textColor(
                          order.isPaid == '0' ? appCtrl.appTheme.logoutColor : appCtrl.appTheme.deliveryIcon),),
                  ),
                ],
              ),
              addVerticalSpace(Dimensions.heightSize*1.3),
              Row(
                children: [
                  Image.asset(
                    assets.dummyImage,
                    height: 80,
                    width: 80,
                  ),
                  addHorizontalSpace(Dimensions.widthSize),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.items!.first.meal!.name ?? "",
                          style: AppCss.mulishBold14.textColor(appCtrl.appTheme.textColor),
                        ),
                        addVerticalSpace(Dimensions.heightSize*0.7),
                        Text(
                            "Total Items: ${order.items!.length}",
                          style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.hintColor),
                        ),
                        addVerticalSpace(Dimensions.heightSize*0.2),
                        Row(
                          children: [
                            SvgPicture.asset(
                              assets.locationSvg,
                              height: 16,
                              width: 16,
                              color: appCtrl.appTheme.hintColor,
                            ),
                            addHorizontalSpace(Dimensions.widthSize*0.4),
                            Expanded(
                              child: Text(
                                "${order.schedules!.first.addressTitle}, ${order.schedules!.first.fullAddress}, ${order.schedules!.first.city}",
                                style: AppCss.mulishMedium12.textColor(appCtrl.appTheme.hintColor),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Text("\u20b9 ${order.totalAmount!}",
                    style: AppCss.mulishMedium16.textColor(
                        appCtrl.appTheme.primary),),
                ],
              ),
              addVerticalSpace(Dimensions.heightSize*1.5),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){
                        historyCtrl.showOrderDetailPopup(order.orderId!);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize*0.8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: appCtrl.appTheme.deliveryBg
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.visibility_outlined,color: appCtrl.appTheme.deliveryIcon,),
                            addHorizontalSpace(Dimensions.widthSize*0.5),
                            Text(
                              "View Details",
                              style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.deliveryIcon),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  addHorizontalSpace(Dimensions.widthSize),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize*0.8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: appCtrl.appTheme.deliveryBg
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.repeat_rounded,color: appCtrl.appTheme.deliveryIcon,),
                          addHorizontalSpace(Dimensions.widthSize*0.5),
                          Text(
                            "Reorder",
                            style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.deliveryIcon),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )

              // addVerticalSpace(Dimensions.heightSize*0.3),
              // Divider(color: appCtrl.appTheme.shimmerHighlight,),
              // addVerticalSpace(Dimensions.heightSize*0.3),
              // Row(
              //   mainAxisAlignment: mainSpaceBet,
              //   children: [
              //     Text("Order Type",
              //       style: AppCss.mulishMedium14.textColor(
              //           appCtrl.appTheme.textColor),),
              //     addHorizontalSpace(Dimensions.widthSize*0.5),
              //     Text(order.orderType!.toUpperCase(),
              //       style: AppCss.mulishSemiBold12.textColor(
              //           appCtrl.appTheme.primary),),
              //   ],
              // ),
              // addVerticalSpace(Dimensions.heightSize*0.2),
              // Row(
              //   mainAxisAlignment: mainSpaceBet,
              //   children: [
              //     Text("Order Slot",
              //       style: AppCss.mulishMedium14.textColor(
              //           appCtrl.appTheme.textColor),),
              //     addHorizontalSpace(Dimensions.widthSize*0.5),
              //     Text(order.slot!.toUpperCase(),
              //       style: AppCss.mulishSemiBold12.textColor(
              //           appCtrl.appTheme.primary),),
              //   ],
              // ),
              // addVerticalSpace(Dimensions.heightSize*0.2),
              // Row(
              //   mainAxisAlignment: mainSpaceBet,
              //   children: [
              //     Text("Payment Status",
              //       style: AppCss.mulishMedium14.textColor(
              //           appCtrl.appTheme.textColor),),
              //     addHorizontalSpace(Dimensions.widthSize*0.5),
              //     Text(order.isPaid == '0' ? "Pay Later" : "Paid",
              //       style: AppCss.mulishSemiBold12.textColor(
              //           order.isPaid == '0' ? appCtrl.appTheme.errorColor : appCtrl.appTheme.saleGreen),),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderTypeSelector({
    required OrderType selected,
    required Function(OrderType) onChanged,
  }) {
    Widget buildItem(String title, OrderType type) {
      bool isSelected = selected == type;

      return GestureDetector(
        onTap: () => onChanged(type),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? appCtrl.appTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: appCtrl.appTheme.primary,
            ),
          ),
          child: Text(
            title,
            style: AppCss.mulishMedium13.textColor(
              isSelected ? Colors.white : appCtrl.appTheme.primary,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildItem("All Orders", OrderType.all),
        const SizedBox(width: 10),
        buildItem("Delivered", OrderType.delivered),
        const SizedBox(width: 10),
        buildItem("Confirmed", OrderType.confirmed),
      ],
    );
  }

}
