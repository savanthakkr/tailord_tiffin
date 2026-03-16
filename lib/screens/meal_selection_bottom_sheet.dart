import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/bottom/cart_controller.dart';
import 'package:tailoredtiffin/utils/config.dart';

import '../app_theme/app_css.dart';
import '../model/all_bread_model.dart';
import '../model/all_meals_model.dart';
import '../model/all_subji_model.dart';
import '../utils/size.dart';

class MealSelectionBottomSheet extends StatelessWidget {
  final AllMeals meal;
  final List<Subji> subjiList;
  final List<Bread> breadList;

  const MealSelectionBottomSheet({
    super.key,
    required this.meal,
    required this.subjiList,
    required this.breadList,
  });

  @override
  Widget build(BuildContext context) {
    final cartCtrl = Get.find<CartController>();

    print("Value of meal type ${cartCtrl.isLunchActive}");

    return GetBuilder<CartController>(
      id: 'mealSelection',
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: Get.back,
                child: Icon(Icons.cancel_outlined,color: appCtrl.appTheme.white,size: 35,),
              ),
            ),
            addVerticalSpace(Dimensions.heightSize*0.3),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF3E3E0),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Dimensions.radius * 1.8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Dimensions.radius),
                                ),
                                color: appCtrl.appTheme.white,
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Image.asset(
                                          assets.dummyImage,
                                          height: 200,
                                        ),
                                      ),
                                      addVerticalSpace(Dimensions.heightSize*0.5),
                                      Text(
                                        meal.mealsName!,
                                        style: AppCss.mulishBold18.textColor(appCtrl.appTheme.textColor),
                                      ),
                                      Text(
                                        meal.description!,
                                        style: AppCss.mulishLight12.textColor(appCtrl.appTheme.secondaryText),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              addVerticalSpace(Dimensions.heightSize*0.5),
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
                                              padding: EdgeInsets.symmetric(vertical: cartCtrl.isLunchActive ? Dimensions.heightSize : Dimensions.heightSize*0.5),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(Dimensions.radius),
                                                color: cartCtrl.isLunchActive ? appCtrl.appTheme.primary : Colors.transparent,
                                                border: Border.all(
                                                  color: cartCtrl.isLunchActive ? appCtrl.appTheme.primary : appCtrl.appTheme.borderColor,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Lunch",
                                                    style: cartCtrl.isLunchActive ? AppCss.mulishBold14.textColor(appCtrl.appTheme.white) : AppCss.mulishMedium12.textColor(appCtrl.appTheme.secondaryText),
                                                  ),
                                                  cartCtrl.isLunchActive ? Container() : addVerticalSpace(Dimensions.heightSize*0.2),
                                                  cartCtrl.isLunchActive ? Container() : Text(
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
                                              padding: EdgeInsets.symmetric(vertical: cartCtrl.isLunchActive ? Dimensions.heightSize*0.5 : Dimensions.heightSize),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(Dimensions.radius),
                                                color: cartCtrl.isLunchActive ? Colors.transparent : appCtrl.appTheme.primary,
                                                border: Border.all(
                                                  color: cartCtrl.isLunchActive ? appCtrl.appTheme.borderColor : appCtrl.appTheme.primary,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Dinner",
                                                    style: cartCtrl.isLunchActive ? AppCss.mulishMedium12.textColor(appCtrl.appTheme.secondaryText) : AppCss.mulishBold14.textColor(appCtrl.appTheme.white),
                                                  ),
                                                  cartCtrl.isLunchActive ? addVerticalSpace(Dimensions.heightSize*0.2) : Container(),
                                                  cartCtrl.isLunchActive ? Text(
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
                              addVerticalSpace(Dimensions.heightSize*0.5),
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
                                        "Choice of Sabjis",
                                        style: AppCss.mulishBold18.textColor(appCtrl.appTheme.textColor),
                                      ),
                                      Text(
                                        "Select up to ${cartCtrl.subjiLimit} option",
                                        style: AppCss.mulishLight12.textColor(appCtrl.appTheme.secondaryText),
                                      ),
                                      addVerticalSpace(Dimensions.heightSize * 0.6),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: subjiList.map((subji) {

                                          final id = int.parse(subji.subjiId.toString());
                                          final qty = cartCtrl.getSubjiQty(id);

                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: appCtrl.appTheme.primary.withOpacity(0.08),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [

                                                Text(
                                                  subji.name!,
                                                  style: AppCss.mulishMedium12,
                                                ),

                                                addHorizontalSpace(6),

                                                InkWell(
                                                  onTap: qty > 0
                                                      ? () => cartCtrl.removeSubji(id)
                                                      : null,
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 16,
                                                    color: qty > 0
                                                        ? appCtrl.appTheme.primary
                                                        : appCtrl.appTheme.hintColor,
                                                  ),
                                                ),

                                                addHorizontalSpace(6),

                                                Text(
                                                  qty.toString(),
                                                  style: AppCss.mulishSemiBold12,
                                                ),

                                                addHorizontalSpace(6),

                                                InkWell(
                                                  onTap: () => cartCtrl.addSubji(id),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 16,
                                                    color: appCtrl.appTheme.primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              addVerticalSpace(Dimensions.heightSize*0.5),
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
                                        "Choice of Bread:",
                                        style: AppCss.mulishBold18.textColor(appCtrl.appTheme.textColor),
                                      ),
                                      addVerticalSpace(Dimensions.heightSize * 0.6),
                                      Wrap(
                                        spacing: 5,
                                        children: breadList.map((bread) {
                                          final id = int.parse(bread.breadId.toString());

                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Radio<int>(
                                                visualDensity: VisualDensity.compact,
                                                materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                                activeColor: appCtrl.appTheme.primary,
                                                value: id,
                                                groupValue: cartCtrl.selectedBreadId,
                                                onChanged: (val) =>
                                                    cartCtrl.selectBread(val!),
                                              ),
                                              Text(
                                                "${bread.name!}",
                                                style: AppCss.mulishMedium12,
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              addVerticalSpace(Dimensions.heightSize*0.5),
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
                                        "Choice of Extra Items:",
                                        style: AppCss.mulishBold18.textColor(appCtrl.appTheme.textColor),
                                      ),
                                      addVerticalSpace(Dimensions.heightSize * 0.6),
                                      if (!cartCtrl.showExtraItems)
                                        TextButton(
                                          onPressed: cartCtrl.toggleExtraItems,
                                          child: Text(
                                            "+ Add Extra Items",
                                            style: AppCss.mulishSemiBold14
                                                .textColor(appCtrl.appTheme.primary),
                                          ),
                                        )
                                      else
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Extra Items",
                                                  style: AppCss.mulishSemiBold14,
                                                ),
                                                TextButton(
                                                  onPressed: cartCtrl.toggleExtraItems,
                                                  child: Text(
                                                    "Close",
                                                    style: AppCss.mulishMedium12
                                                        .textColor(appCtrl.appTheme.primary),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Wrap(
                                              spacing: 4,
                                              runSpacing: 4,
                                              children: subjiList.map((subji) {
                                                final id =
                                                int.parse(subji.subjiId.toString());
                                                final qty = cartCtrl.getExtraQty(id);

                                                return Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 10, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(20),
                                                    color: appCtrl.appTheme.primary
                                                        .withOpacity(0.08),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        subji.name!,
                                                        style: AppCss.mulishMedium12,
                                                      ),
                                                      addVerticalSpace(Dimensions.heightSize * 0.6),
                                                      InkWell(
                                                        onTap: qty > 0
                                                            ? () => cartCtrl
                                                            .removeExtraItem(id)
                                                            : null,
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 16,
                                                          color: qty > 0
                                                              ? appCtrl.appTheme.primary
                                                              : appCtrl.appTheme.hintColor,
                                                        ),
                                                      ),
                                                      addHorizontalSpace(Dimensions.widthSize * 0.4),
                                                      Text(
                                                        qty.toString(),
                                                        style: AppCss.mulishSemiBold12,
                                                      ),
                                                      addHorizontalSpace(Dimensions.widthSize * 0.4),
                                                      InkWell(
                                                        onTap: () =>
                                                            cartCtrl.addExtraItem(id),
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 16,
                                                          color: appCtrl.appTheme.primary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            addVerticalSpace(Dimensions.heightSize*0.5),
                                            Wrap(
                                              spacing: 4,
                                              runSpacing: 4,
                                              children: breadList.map((subji) {
                                                final id =
                                                int.parse(subji.breadId.toString());
                                                final qty = cartCtrl.getExtraQty(id);

                                                return Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 10, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(20),
                                                    color: appCtrl.appTheme.primary
                                                        .withOpacity(0.08),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        subji.name!,
                                                        style: AppCss.mulishMedium12,
                                                      ),
                                                      addVerticalSpace(Dimensions.heightSize * 0.6),
                                                      InkWell(
                                                        onTap: qty > 0
                                                            ? () => cartCtrl
                                                            .removeExtraItem(id)
                                                            : null,
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 16,
                                                          color: qty > 0
                                                              ? appCtrl.appTheme.primary
                                                              : appCtrl.appTheme.hintColor,
                                                        ),
                                                      ),
                                                      addHorizontalSpace(Dimensions.widthSize * 0.4),
                                                      Text(
                                                        qty.toString(),
                                                        style: AppCss.mulishSemiBold12,
                                                      ),
                                                      addHorizontalSpace(Dimensions.widthSize * 0.4),
                                                      InkWell(
                                                        onTap: () =>
                                                            cartCtrl.addExtraItem(id),
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 16,
                                                          color: appCtrl.appTheme.primary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),

                              addVerticalSpace(Dimensions.heightSize * 2),

                              /// ===== SUBMIT BUTTON =====
                              // PrimaryButtonWidget(
                              //   text: "Add to Cart",
                              //   onPressed: () {
                              //     if (cartCtrl.isMealSelectionValid) {
                              //       final payload =
                              //       cartCtrl.buildMealPayload(meal);
                              //       print("CART PAYLOAD => $payload");
                              //       cartCtrl.addMealstoCart(mealPayload: payload);
                              //       Get.back();
                              //     } else {
                              //       UIUtils.bottomToast(
                              //         text: "Please complete your selection",
                              //         isError: true,
                              //       );
                              //     }
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _bottomBar(cartCtrl),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _bottomBar(CartController cartCtrl) {

    double totalPrice = cartCtrl.calculateMealTotal(meal);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xffEAEAEA))),
      ),
      child: Row(
        children: [

          /// TOTAL PRICE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total",
                  style: AppCss.mulishLight12
                      .textColor(appCtrl.appTheme.secondaryText),
                ),
                Text(
                  "₹${totalPrice.toStringAsFixed(2)}",
                  style: AppCss.mulishBold18
                      .textColor(appCtrl.appTheme.primary),
                ),
              ],
            ),
          ),

          /// ADD TO CART BUTTON
          Expanded(
            flex: 2,
            child: PrimaryButtonWidget(
              text: "Add to Cart",
              backgroundColor: appCtrl.appTheme.logoutColor,
              onPressed: () {

                if (cartCtrl.isMealSelectionValid) {

                  final payload = cartCtrl.buildMealPayload(meal);

                  print("CART PAYLOAD => $payload");

                  cartCtrl.addMealstoCart(mealPayload: payload);

                  Get.back();

                } else {

                  UIUtils.bottomToast(
                    text: "Please complete your selection",
                    isError: true,
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
