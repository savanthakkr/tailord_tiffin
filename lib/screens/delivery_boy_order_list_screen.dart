import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tailoredtiffin/controllers/history_controller.dart';
import 'package:tailoredtiffin/model/order_model.dart';
import 'package:tailoredtiffin/screens/bottom/user_bottom_screen.dart';
import 'package:tailoredtiffin/screens/order_detail_screen.dart';
import 'package:tailoredtiffin/widgets/empty_layout.dart';
import 'package:tailoredtiffin/widgets/shimmer_layout.dart';

import '../controllers/delivery_boy_history_controller.dart';
import '../utils/config.dart';
import 'delivery_boy_order_details_screen.dart';
import 'delivery_route_map_screen.dart';

class DeliveryBoyOrderHistoryScreen extends StatefulWidget {
  const DeliveryBoyOrderHistoryScreen({super.key});

  @override
  State<DeliveryBoyOrderHistoryScreen> createState() => _DeliveryBoyOrderHistoryScreenState();
}

class _DeliveryBoyOrderHistoryScreenState extends State<DeliveryBoyOrderHistoryScreen> {
  var historyCtrl = Get.put(DeliveryBoyHistoryController());

  Future<bool> _onBackPressed() async{
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    Get.back();
    return false;
  }


  void _markDelivered(OrderData order) {

    // COD Order
    if(order.isPaid == "0") {

      Get.dialog(
        AlertDialog(
          title: const Text("COD Payment"),
          content: const Text("Has the customer paid the amount?"),
          actions: [

            TextButton(
              onPressed: () async {

                Get.back();

                await ApiManager.updateOrderStatus(
                  orderId: order.orderId!,
                  deliveryDate: order.deliveryDates!,
                  slot: order.slot!,
                  deliveryStatus: "delivered",
                  paymentStatus: "paid",
                );

                historyCtrl.getHistory();

              },
              child: const Text("Payment Received"),
            ),

            TextButton(
              onPressed: () async {

                Get.back();

                await ApiManager.updateOrderStatus(
                  orderId: order.orderId!,
                  deliveryDate: order.deliveryDates!,
                  slot: order.slot!,
                  deliveryStatus: "delivered",
                  paymentStatus: "cod",
                );

                historyCtrl.getHistory();

              },
              child: const Text("Not Paid"),
            ),
          ],
        ),
      );

    }

    // Already paid (Online)
    else {

      ApiManager.updateOrderStatus(
        orderId: order.orderId!,
        deliveryDate: order.deliveryDates!,
        slot: order.slot!,
        deliveryStatus: "delivered",
        paymentStatus: "paid",
      );

      historyCtrl.getHistory();

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: 'Order List',
        backEnable: true,
        centerTitle: true,
        bgColor: appCtrl.appTheme.white,
        leadingOnTap: () => _onBackPressed(),
      ),
      backgroundColor: appCtrl.appTheme.white,
      body: GetBuilder<DeliveryBoyHistoryController>(
        builder: (ctrl) {
          return Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      historyCtrl.getHistory(slot: "lunch");
                    },
                    child: const Text("Lunch"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.to(() => DeliveryRouteMapScreen(
                        orders: historyCtrl.orderList,
                      ));
                    },
                    icon: Icon(Icons.map),
                    label: Text("Show Route"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      historyCtrl.getHistory(slot: "dinner");
                    },
                    child: const Text("Dinner"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      historyCtrl.getHistory();
                    },
                    child: const Text("All"),
                  ),
                ],
              ),

              Expanded(
                child: historyCtrl.isLoading
                    ? const CommonShimmerLayout(hasBanner: false)
                    : historyCtrl.orderList.isNotEmpty
                    ? ListView.builder(
                  itemCount: historyCtrl.orderList.length,
                  itemBuilder: (context, index) {
                    return _orderItem(historyCtrl.orderList[index]);
                  },
                )
                    : EmptyLayout(
                  image: assets.bookPng,
                  title: 'Your order list is currently empty!',
                  subtitle: 'Start filling it up with your past purchases.',
                  btnText: '',
                  onBtnTap: () {},
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _orderItem(OrderData order) {
    Color color = (order.schedules != null &&
        order.schedules!.isNotEmpty &&
        order.schedules!.first.delivery_status == "pending")
        ? appCtrl.appTheme.errorColor
        : appCtrl.appTheme.primary;

    bool isDelivered =
        order.schedules != null &&
            order.schedules!.isNotEmpty &&
            order.schedules!.first.delivery_status == "delivered";

    String svgIcon = order.isPaid == '0'
        ? assets.closeSvg
        : order.isPaid == '1'
        ? assets.checkSvg
        : assets.truckSvg ;

    return InkWell(
      onTap: () {
        Get.to(()=> const DeliveryBoyOrderDetailScreen(),arguments: {'orderId': order.orderId});
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize*0.2),
        child: Card(
          elevation: 2,
          color: appCtrl.appTheme.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(Dimensions.radius),
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
                              Icon(Icons.check_circle_outline_rounded,color: appCtrl.appTheme.primary,size: 16,),
                              addHorizontalSpace(Dimensions.widthSize*0.2),
                              Text(
                                (order.schedules != null &&
                                    order.schedules!.isNotEmpty &&
                                    order.schedules!.first.delivery_status == "pending")
                                    ? "Pending"
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
                        Text(DateFormat('MMM dd,yyyy hh:mm a').format(order.createdAt!),
                          style: AppCss.mulishRegular12.textColor(
                              appCtrl.appTheme.secondaryText),),
                        addVerticalSpace(Dimensions.heightSize*0.15),
                        Text(
                          "${order.slot!.toUpperCase()} - ${DateFormat('MMM dd,yyyy').format(DateTime.parse(order.deliveryDates!))}",
                          style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.primary),
                        ),
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
                            order.items != null && order.items!.isNotEmpty
                                ? order.items!.first.meal!.name!
                                : "Meal",
                            style: AppCss.mulishExtraBold16.textColor(appCtrl.appTheme.textColor),
                          ),
                          Text(
                            "Total Items: ${order.items?.length ?? 0}",
                            style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.hintColor),
                          ),
                          addVerticalSpace(Dimensions.heightSize*0.2),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,color: appCtrl.appTheme.hintColor,),
                              addHorizontalSpace(Dimensions.widthSize*0.2),
                              Expanded(
                                child: Text(
                                  order.schedules != null && order.schedules!.isNotEmpty
                                      ? "${order.schedules!.first.fullAddress}, ${order.schedules!.first.city}"
                                      : "Address not available",
                                  style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.hintColor),
                                )
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Text("\u20b9 ${order.totalAmount!}",
                      style: AppCss.mulishSemiBold14.textColor(
                          appCtrl.appTheme.primary),),
                  ],
                ),
                Row(
                  children: [
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
                    addHorizontalSpace(Dimensions.widthSize),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: isDelivered
                            ? null
                            : () {
                          _markDelivered(order);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.widthSize,
                              vertical: Dimensions.heightSize * 0.8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: isDelivered
                                ? Colors.grey.shade300
                                : appCtrl.appTheme.deliveryBg,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delivery_dining,
                                color: isDelivered
                                    ? Colors.grey
                                    : appCtrl.appTheme.deliveryIcon,
                              ),
                              addHorizontalSpace(Dimensions.widthSize * 0.5),
                              Text(
                                isDelivered ? "Delivered" : "Mark Delivered",
                                style: AppCss.mulishSemiBold14.textColor(
                                  isDelivered
                                      ? Colors.grey
                                      : appCtrl.appTheme.deliveryIcon,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
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
      ),
    );
  }

}
