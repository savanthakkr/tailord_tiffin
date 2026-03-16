import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/bottom/bottom_bar_controller.dart';
import 'package:tailoredtiffin/controllers/bottom/cart_controller.dart';
import 'package:tailoredtiffin/model/cart_model.dart';
import 'package:tailoredtiffin/screens/bottom/user_bottom_screen.dart';
import 'package:tailoredtiffin/screens/meal_edit_selection_bottom_sheet.dart';
import 'package:tailoredtiffin/screens/meal_special_item_edit_bottom_sheet.dart';
import 'package:tailoredtiffin/screens/order/shipping_payment_screen.dart';
import 'package:tailoredtiffin/utils/config.dart';
import 'package:tailoredtiffin/utils/validation_utils.dart';
import 'package:tailoredtiffin/widgets/empty_layout.dart';
import 'package:tailoredtiffin/widgets/shimmer_layout.dart';
import 'package:tailoredtiffin/widgets/text_field_common.dart';

import '../../controllers/address_controller.dart';
import '../../controllers/order_controller.dart';
import '../address/add_address_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var cartCtrl = Get.find<CartController>();
  var orderCtrl = Get.put(OrderController());
  var addressCtrl = Get.find<AddressController>();

  Future<bool> _onBackPressed() async{
    Get.back();
    return false;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderCtrl.initDefaultDeliveryDate();

      final defaultAddress = addressCtrl.defaultAddress;

      if (defaultAddress != null) {
        orderCtrl.selectedAddress = defaultAddress;
        orderCtrl.update();
      }
    });
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
      child: GetBuilder<CartController>(
        id: "cartList",
          builder: (controller) {
            return Scaffold(
              appBar: CommonAppbar(
                title: 'Cart',
                backEnable: true,
                centerTitle: true,
                bgColor: appCtrl.appTheme.white,
                leadingOnTap: () => _onBackPressed(),
              ),
              body: controller.isLoading
                  ? const CommonShimmerLayout(hasBanner: false,)
                  : controller.cartList!=null && controller.cartList!.isNotEmpty
                  ? Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize),
                          children: [
                            for(int i=0 ; i<controller.cartList!.length ; i++)
                              _cartItem(controller.cartList![i]),
                            addVerticalSpace(Dimensions.heightSize),
                            Text(
                              "Shipping Info",
                              style: AppCss.mulishBold18.textColor(appCtrl.appTheme.textColor),
                            ),
                            addVerticalSpace(Dimensions.heightSize),
                            GetBuilder<OrderController>(
                              builder: (orderCtrl) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.radius),
                                      ),
                                      color: appCtrl.appTheme.white,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Delivery Address",
                                              style: AppCss.mulishBold18.textColor(appCtrl.appTheme.textColor),
                                            ),
                                            addVerticalSpace(Dimensions.heightSize*0.5),
                                            Row(
                                              mainAxisAlignment: mainSpaceBet,
                                              children: [
                                                Expanded(
                                                  flex: 8,
                                                  child: Text(orderCtrl.selectedAddress !=null
                                                      ? '${orderCtrl.selectedAddress!.fullAddress},${orderCtrl.selectedAddress!.landmark},'
                                                      '${orderCtrl.selectedAddress!.city},${orderCtrl.selectedAddress!.state},${orderCtrl.selectedAddress!.pincode}'
                                                      : 'Select your address',
                                                    softWrap: true,
                                                    style: AppCss.mulishMedium12.textColor(appCtrl.appTheme.textColor),
                                                  ),
                                                ),
                                                addHorizontalSpace(Dimensions.widthSize*0.5),
                                                InkWell(
                                                  onTap: () {
                                                    _addressSheet();
                                                  },
                                                  child: Text(
                                                    orderCtrl.selectedAddress != null
                                                        ? 'Change'.toUpperCase()
                                                        : 'Select'.toUpperCase(),
                                                    style: AppCss.mulishBold12.textColor(appCtrl.appTheme.primary),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    addVerticalSpace(Dimensions.heightSize),
                                    Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.radius),
                                      ),
                                      color: appCtrl.appTheme.white,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Delivery Dates",
                                                    style: AppCss.mulishBold18.textColor(appCtrl.appTheme.textColor),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: orderCtrl.isAfterCutoff()
                                                      ? null
                                                      : () => _pickDeliveryDate(context),
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: appCtrl.appTheme.deliveryBg
                                                    ),
                                                    child: Icon(Icons.calendar_month,color: appCtrl.appTheme.deliveryIcon,),
                                                  ),
                                                )
                                              ],
                                            ),
                                            addVerticalSpace(Dimensions.heightSize*0.5),
                                            if (orderCtrl.selectedDates.isNotEmpty)
                                              Wrap(
                                                spacing: 5,
                                                runSpacing: 5,
                                                children: orderCtrl.selectedDates.map((date) {
                                                  final label = "${date.day}-${date.month}-${date.year}";

                                                  return Chip(
                                                    label: Text(
                                                      label,
                                                      style: AppCss.mulishRegular12
                                                          .textColor(appCtrl.appTheme.textColor),
                                                    ),
                                                    backgroundColor: appCtrl.appTheme.white, // light primary bg
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                      side: BorderSide(
                                                        color: appCtrl.appTheme.primary, // primary border
                                                        width: 1,
                                                      ),
                                                    ),
                                                    deleteIcon: Icon(
                                                      Icons.close,
                                                      size: 18,
                                                      color: appCtrl.appTheme.primary,
                                                    ),
                                                    onDeleted: () => orderCtrl.toggleDate(date),
                                                  );
                                                }).toList(),
                                              )
                                            else
                                              Text(
                                                "No delivery dates selected",
                                                style: AppCss.mulishMedium12
                                                    .textColor(appCtrl.appTheme.secondaryText),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    addVerticalSpace(Dimensions.heightSize),
                                    Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.radius),
                                      ),
                                      color: appCtrl.appTheme.white,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Meal Type",
                                              style: AppCss.mulishBold18.textColor(appCtrl.appTheme.textColor),
                                            ),
                                            addVerticalSpace(Dimensions.heightSize*0.7),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: orderCtrl.isLunchActive ? Dimensions.heightSize : Dimensions.heightSize*0.5),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(Dimensions.radius),
                                                      color: orderCtrl.isLunchActive ? appCtrl.appTheme.primary : Colors.transparent,
                                                      border: Border.all(
                                                        color: orderCtrl.isLunchActive ? appCtrl.appTheme.primary : appCtrl.appTheme.borderColor,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Lunch",
                                                          style: orderCtrl.isLunchActive ? AppCss.mulishBold14.textColor(appCtrl.appTheme.white) : AppCss.mulishMedium12.textColor(appCtrl.appTheme.secondaryText),
                                                        ),
                                                        orderCtrl.isLunchActive ? Container() : addVerticalSpace(Dimensions.heightSize*0.2),
                                                        orderCtrl.isLunchActive ? Container() : Text(
                                                          "Closed",
                                                          style: AppCss.mulishLight12.textColor(appCtrl.appTheme.secondaryText),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                addHorizontalSpace(Dimensions.widthSize),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: orderCtrl.isLunchActive ? Dimensions.heightSize*0.5 : Dimensions.heightSize),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(Dimensions.radius),
                                                      color: orderCtrl.isLunchActive ? Colors.transparent : appCtrl.appTheme.primary,
                                                      border: Border.all(
                                                        color: orderCtrl.isLunchActive ? appCtrl.appTheme.borderColor : appCtrl.appTheme.primary,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Dinner",
                                                          style: orderCtrl.isLunchActive ? AppCss.mulishMedium12.textColor(appCtrl.appTheme.secondaryText) : AppCss.mulishBold14.textColor(appCtrl.appTheme.white),
                                                        ),
                                                        orderCtrl.isLunchActive ? addVerticalSpace(Dimensions.heightSize*0.2) : Container(),
                                                        orderCtrl.isLunchActive ? Text(
                                                          "Closed",
                                                          style: AppCss.mulishLight12.textColor(appCtrl.appTheme.secondaryText),
                                                        ) : Container()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    addVerticalSpace(Dimensions.heightSize),
                                    Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.radius),
                                      ),
                                      color: appCtrl.appTheme.white,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Tiffin Selection Mode",
                                              style: AppCss.mulishBold18.textColor(appCtrl.appTheme.textColor),
                                            ),
                                            // CheckboxListTile(
                                            //   dense: true,
                                            //   contentPadding: EdgeInsets.zero,
                                            //   title: Text(
                                            //     'Fixed',
                                            //     style: AppCss.mulishMedium13.textColor(appCtrl.appTheme.primary),
                                            //   ),
                                            //   value: orderCtrl.isFixed,
                                            //   onChanged: (bool? value) {
                                            //     orderCtrl.isFixed = value!;
                                            //     orderCtrl.update();
                                            //   },
                                            //   checkColor: appCtrl.appTheme.white,
                                            //   activeColor: appCtrl.appTheme.primary,
                                            // ),
                                            CheckboxListTile(
                                              dense: true,
                                              contentPadding: EdgeInsets.zero,
                                              title: Text(
                                                'Flexible',
                                                style: AppCss.mulishMedium13.textColor(appCtrl.appTheme.primary),
                                              ),
                                              value: !orderCtrl.isFixed,
                                              onChanged: (bool? value) {
                                                orderCtrl.isFixed = value!;
                                                orderCtrl.update();
                                              },
                                              checkColor: appCtrl.appTheme.white,
                                              activeColor: appCtrl.appTheme.primary,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: appCtrl.appTheme.white,
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text('Total : ',style: AppCss.mulishBold16.textColor(appCtrl.appTheme.textColor),),
                                  addHorizontalSpace(Dimensions.widthSize*0.2),
                                  Text('\u20b9${cartCtrl.payableAmount}',style: AppCss.mulishBold16.textColor(appCtrl.appTheme.primary),),
                                ],
                              ),
                            ),
                            addHorizontalSpace(Dimensions.widthSize),
                            InkWell(
                              onTap: (){
                                if(orderCtrl.selectedAddress == null){
                                  UIUtils.bottomToast(text: 'Please select address', isError: true);
                                } else if(orderCtrl.selectedDates.isEmpty){
                                  UIUtils.bottomToast(text: 'Please select at-least one date', isError: true);
                                } else {
                                  Get.to(() => const ShippingPaymentScreen());
                                }
                              },
                              child: Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radius),
                                  color: appCtrl.appTheme.logoutColor
                                ),
                                child: Center(
                                  child: Text(
                                    "Shipping & Payment Info",
                                    style: AppCss.mulishBold14.textColor(appCtrl.appTheme.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
              : EmptyLayout(image: assets.cartPng,
                  title: 'Your Cart Is Empty!',
                  subtitle: 'Looks like you haven\'t made\nyour order yet.',
                  btnText: 'shop now',
                  onBtnTap: () {
                    var bottomCtrl = Get.find<BottomBarController>();
                    bottomCtrl.onBottomTap(0);
                  },
              ),
            );
          },
      ),
    );
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

  _titleWidget(String title) {
    return Text(title,
      style: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.secondaryText),
    ).marginSymmetric(vertical: Dimensions.heightSize*0.5);
  }

  void _showMultipleDateDialog(DateTime latestDate) {
    Get.dialog(
      AlertDialog(
        title: Text(
          "Multiple Delivery Dates",
          style: AppCss.mulishSemiBold16
              .textColor(appCtrl.appTheme.textColor),
        ),
        content: Text(
          "You have selected multiple delivery dates. If subji is different on those days, the same tiffin order will be placed.\n\nAre you okay with this?",
          style: AppCss.mulishMedium13
              .textColor(appCtrl.appTheme.secondaryText),
        ),
        actions: [

          /// NO BUTTON
          TextButton(
            onPressed: () {
              Get.back();

              /// keep only latest date
              orderCtrl.selectedDates.clear();
              orderCtrl.selectedDates.add(latestDate);

              orderCtrl.update();
            },
            child: Text(
              "No",
              style: AppCss.mulishBold14
                  .textColor(appCtrl.appTheme.textColor),
            ),
          ),

          /// YES BUTTON
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "Yes",
              style: AppCss.mulishBold14
                  .textColor(appCtrl.appTheme.primary),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _pickDeliveryDate(BuildContext context) async {

    if (orderCtrl.isAfterCutoff()) {
      UIUtils.bottomToast(
        text: "Orders after 6 PM will be delivered tomorrow",
        isError: true,
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );

    if (picked != null) {
      orderCtrl.toggleDate(picked);

      if (orderCtrl.selectedDates.length > 1) {
        _showMultipleDateDialog(picked);
      }
    }
  }

  _divider()
  {
    return Divider(
      color: appCtrl.appTheme.borderColor,
      thickness: 0.5,
      height: Dimensions.heightSize,
    );
  }

  Widget _cartItem(CartData product) {
    return IntrinsicHeight(
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius),
        ),
        color: appCtrl.appTheme.white,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: crossStart,
            children: [
              Row(
                children: [
                  Image.asset(
                    assets.dummyImage,
                    height: 55,
                  ),
                  addHorizontalSpace(Dimensions.widthSize),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.meal!.name!,
                          style: AppCss.mulishBold14.textColor(appCtrl.appTheme.textColor),),
                        Text('\u20b9${product.meal!.price}',
                          style: AppCss.mulishSemiBold13.textColor(appCtrl.appTheme.primary),),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          cartCtrl.initEditExtraItems(product);
                          if(product.meal!.structure!.is_special_meal == "1"){
                            Get.bottomSheet(
                              MealSpecialItemEditBottomSheet(
                                specialItemList: cartCtrl.allSpecialItem,
                                cartItem: product,
                              ),
                              isScrollControlled: true,
                              backgroundColor: appCtrl.appTheme.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(Dimensions.radius),
                                ),
                              ),
                            );
                          } else {
                            cartCtrl.initEditMealSelection(product);
                            Get.bottomSheet(
                              MealEditSelectionBottomSheet(
                                subjiList: cartCtrl.allSubjiList,
                                breadList: cartCtrl.allBreadList,
                                cartItem: product,
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
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: appCtrl.appTheme.deliveryBg
                          ),
                          child: Icon(
                            Icons.edit_outlined,color: appCtrl.appTheme.deliveryIcon,
                          ),
                        ),
                      ),
                      addHorizontalSpace(Dimensions.widthSize),
                      InkWell(
                        onTap: (){
                          cartCtrl.removeCart(cartId: product.cartId!);
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: appCtrl.appTheme.logoutBg
                          ),
                          child: Icon(
                            Icons.delete_outline_rounded,color: appCtrl.appTheme.logoutColor,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              addVerticalSpace(Dimensions.heightSize*0.2),
              Text('Including in Meal',
                style: AppCss.mulishSemiBold16.textColor(appCtrl.appTheme.textColor),),
              addVerticalSpace(Dimensions.heightSize*0.2),
              product.selectedItems != null && product.selectedItems!.specialMeal != null ? Row(
                children: [
                  Expanded(
                    child: Text(product.selectedItems!.specialMeal!.name!,
                      style: AppCss.mulishMedium15.textColor(appCtrl.appTheme.secondaryText),),
                  ),
                  addHorizontalSpace(Dimensions.widthSize*0.5),
                  Text('\u20b9${product.selectedItems!.specialMeal!.price}',
                    style: AppCss.mulishSemiBold13.textColor(appCtrl.appTheme.primary),),
                ],
              ) : Container(),
              product.selectedItems != null && product.selectedItems!.bread != null ? Row(
                children: [
                  Expanded(
                    child: Text(product.selectedItems!.bread!.name!,
                      style: AppCss.mulishMedium15.textColor(appCtrl.appTheme.secondaryText),),
                  ),
                  // addHorizontalSpace(Dimensions.widthSize*0.5),
                  // Text('\u20b9${product.selectedItems!.bread!.price}',
                  //   style: AppCss.mulishSemiBold13.textColor(appCtrl.appTheme.primary),),
                ],
              ) : Container(),
              if(product.selectedItems != null && product.selectedItems!.subjis!.isNotEmpty)
                for(int i=0 ; i<product.selectedItems!.subjis!.length ; i++)
                  Row(
                    children: [
                      Expanded(
                        child: Text(product.selectedItems!.subjis![i].name!,
                          style: AppCss.mulishMedium15.textColor(appCtrl.appTheme.secondaryText),),
                      ),
                      // addHorizontalSpace(Dimensions.widthSize*0.5),
                      // Text('\u20b9${product.selectedItems!.subjis![i].price!}',
                      //   style: AppCss.mulishSemiBold13.textColor(appCtrl.appTheme.primary),),
                    ],
                  ),
              product.extraItems!.isNotEmpty ? Text('Extra Meals',
                style: AppCss.mulishSemiBold16.textColor(appCtrl.appTheme.textColor),) : Container(),
              product.extraItems!.isNotEmpty ? addVerticalSpace(Dimensions.heightSize*0.2) : Container(),
              for(int i=0 ; i<product.extraItems!.length ; i++)
                Row(
                  children: [
                    Expanded(
                      child: Text(product.extraItems![i].name!,
                        style: AppCss.mulishMedium15.textColor(appCtrl.appTheme.secondaryText),),
                    ),
                    addHorizontalSpace(Dimensions.widthSize*0.5),
                    Text('${product.extraItems![i].quantity!} * \u20b9${product.extraItems![i].price!} = \u20b9${product.extraItems![i].subtotal!}',
                      style: AppCss.mulishSemiBold13.textColor(appCtrl.appTheme.primary),),
                  ],
                ),
              addVerticalSpace(Dimensions.heightSize*1.5),
            ],
          ),
        ),
      )
    ).marginOnly(top: Dimensions.heightSize);
  }
}
