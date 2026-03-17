import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/order_detail_controller.dart';
import '../utils/config.dart';

class OrderDetailPopup extends StatefulWidget {
  final String orderId;
  const OrderDetailPopup({super.key, required this.orderId});

  @override
  State<OrderDetailPopup> createState() => _OrderDetailPopupState();
}

class _OrderDetailPopupState extends State<OrderDetailPopup> {
  late OrderDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(OrderDetailController());
    controller.init(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: appCtrl.appTheme.white,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: appCtrl.appTheme.primary,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order Details",
                      style: AppCss.mulishBold16.textColor(Colors.white)),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, color: Colors.white),
                  )
                ],
              ),
            ),
            Expanded(
              child: GetBuilder<OrderDetailController>(
                builder: (ctrl) {
                  if (ctrl.isLoading) {
                    return Center(child: CircularProgressIndicator(color: appCtrl.appTheme.primary,));
                  }

                  if (ctrl.orderData == null) {
                    return const Center(child: Text("No Data"));
                  }

                  final order = ctrl.orderData!.order!;
                  final schedualData = ctrl.orderData!.schedules!;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("#TT-${order.orderId}",style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.textColor),),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: appCtrl.appTheme.paymentIcon,
                                borderRadius: BorderRadius.circular(Dimensions.radius*20),
                              ),
                              child: Text("CONFIRMED",
                                  style: AppCss.mulishBold12.textColor(appCtrl.appTheme.white)),
                            )
                          ],
                        ),
                        addVerticalSpace(Dimensions.heightSize*0.5),
                        Divider(color: appCtrl.appTheme.borderColor,),
                        addVerticalSpace(Dimensions.heightSize*0.5),
                        _row(title: "Order Placed:",value: DateFormat("MMMM dd, yyyy 'at' hh:mm a").format(order.createdAt!),
                            titleStyle: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.secondaryText),
                            textStyle: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.textColor),
                        ),

                        _row(title: "Delivery Date:",value: "${schedualData.first.slot!.toUpperCase()} -${DateFormat("EEEE, MMMM dd, yyyy").format(schedualData.first.deliveryDate!)}",
                          titleStyle: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.secondaryText),
                          textStyle: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.textColor),
                        ),
                        addVerticalSpace(Dimensions.heightSize*0.5),
                        Divider(color: appCtrl.appTheme.borderColor,),
                        addVerticalSpace(Dimensions.heightSize),
                        Text(
                          "Items Ordered",
                          style: AppCss.mulishBold16.textColor(appCtrl.appTheme.textColor),
                        ),
                        addVerticalSpace(Dimensions.heightSize*1.3),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ctrl.orderData!.items!.length,
                          itemBuilder: (context, index) {
                            final item = ctrl.orderData!.items![index];
                            final subjiNames = item.selectedItems!.subjis!
                                .map((e) => e.name)
                                .join(", ");
                            String extraNames = "";
                            if(item.extraItems != null && item.extraItems!.isNotEmpty) {
                              extraNames = item.extraItems!
                                  .map((e) => e.name)
                                  .join(", ");
                            }
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  assets.dummyImage,
                                  height: 70,
                                  width: 70,
                                ),
                                addHorizontalSpace(Dimensions.widthSize*0.6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.meal!.name!,
                                              style: AppCss.mulishBold14.textColor(appCtrl.appTheme.textColor),
                                            ),
                                          ),
                                          addHorizontalSpace(Dimensions.widthSize*0.5),
                                          Text(
                                            "\u20b9 ${item.price!}",
                                            style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.primary),
                                          )
                                        ],
                                      ),
                                      Text(
                                        "\u20b9 ${item.price} x ${item.quantity}",
                                        style: AppCss.mulishMedium12.textColor(appCtrl.appTheme.secondaryText),
                                      ),
                                      addVerticalSpace(Dimensions.heightSize*0.5),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.radius),
                                          color: appCtrl.appTheme.deliveryBg,
                                        ),
                                        margin: EdgeInsets.only(right: Dimensions.widthSize*5),
                                        padding: const EdgeInsets.all(6),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Includes",
                                              style: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.primary),
                                            ),
                                            addVerticalSpace(Dimensions.heightSize*0.1),
                                            Text(
                                              "$subjiNames, ${item.meal!.breadCount} ${item.selectedItems!.bread}, $extraNames",
                                              style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.deliveryIcon),
                                            )
                                          ],
                                        )
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                        addVerticalSpace(Dimensions.heightSize*0.5),
                        Divider(color: appCtrl.appTheme.borderColor,),
                        addVerticalSpace(Dimensions.heightSize),
                        Text(
                          "Order Summary",
                          style: AppCss.mulishBold16.textColor(appCtrl.appTheme.textColor),
                        ),
                        addVerticalSpace(Dimensions.heightSize),
                        Text(
                          "Complete Meal Breakdown",
                          style: AppCss.mulishBold14.textColor(appCtrl.appTheme.textColor),
                        ),
                        addVerticalSpace(Dimensions.heightSize*0.5),
                        _row(title: "Base Meal Price",value: "\u20b9 ${order.totalAmount}",
                          titleStyle: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.secondaryText),
                          textStyle: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.textColor),
                        ),
                        addVerticalSpace(Dimensions.heightSize*0.5),
                        Divider(color: appCtrl.appTheme.borderColor,),
                        _row(title: "Item Total",value: "\u20b9 ${order.totalAmount}",
                          titleStyle: AppCss.mulishSemiBold13.textColor(appCtrl.appTheme.textColor),
                          textStyle: AppCss.mulishSemiBold13.textColor(appCtrl.appTheme.primary),
                        ),
                        addVerticalSpace(Dimensions.heightSize*1.3),
                        _row(title: "Subtotal",value: "\u20b9 ${order.totalAmount}",
                          titleStyle: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.secondaryText),
                          textStyle: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.textColor),
                        ),
                        _row(title: "Delivery Fee",value: "Free",
                          titleStyle: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.secondaryText),
                          textStyle: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.textColor),
                        ),
                        addVerticalSpace(Dimensions.heightSize*0.5),
                        Divider(color: appCtrl.appTheme.borderColor,),
                        _row(title: "Total Amount",value: "\u20b9 ${order.totalAmount}",
                          titleStyle: AppCss.mulishSemiBold13.textColor(appCtrl.appTheme.textColor),
                          textStyle: AppCss.mulishSemiBold13.textColor(appCtrl.appTheme.primary),
                        ),
                        _row(title: "Payment Method",value: "${order.payment_type!.toUpperCase()}",
                          titleStyle: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.secondaryText),
                          textStyle: AppCss.mulishSemiBold13.textColor(appCtrl.appTheme.textColor),
                        ),
                        _row(title: "Payment Status",value: "PostPaid",
                          titleStyle: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.secondaryText),
                          textStyle: AppCss.mulishSemiBold13.textColor(appCtrl.appTheme.helpIcon),
                        ),
                        addVerticalSpace(Dimensions.heightSize*0.5),
                        Divider(color: appCtrl.appTheme.borderColor,),
                        addVerticalSpace(Dimensions.heightSize*0.5),
                        Text(
                          "Delivery Address",
                          style: AppCss.mulishBold16.textColor(appCtrl.appTheme.textColor),
                        ),
                        addVerticalSpace(Dimensions.heightSize),
                        Row(
                          children: [
                            SvgPicture.asset(assets.locationSvg,color: appCtrl.appTheme.primary,height: 20,width: 20,),
                            addHorizontalSpace(Dimensions.widthSize),
                            Text(
                              "${ctrl.orderData!.schedules!.first.fullAddress}",
                              style: AppCss.mulishMedium12.textColor(appCtrl.appTheme.textColor),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row({String? title, String? value,TextStyle? titleStyle, TextStyle? textStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title!,style: titleStyle,textAlign: TextAlign.right,),
          addHorizontalSpace(Dimensions.widthSize*2.5),
          Flexible(
            child: title == "Payment Status" ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
              decoration: BoxDecoration(
                color: appCtrl.appTheme.helpBg,
                borderRadius: BorderRadius.circular(Dimensions.radius),
              ),
              child: Text(
                value!,
                style: textStyle
              ),
            ) : Text(value!,
                textAlign: TextAlign.right,
                style: textStyle,),
          ),
        ],
      ),
    );
  }
}