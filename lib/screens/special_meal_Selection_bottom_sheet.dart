import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tailoredtiffin/model/special_item_model.dart';

import '../app_theme/app_css.dart';
import '../controllers/bottom/cart_controller.dart';
import '../model/all_meals_model.dart';
import '../utils/config.dart';
import '../utils/dimensions.dart';
import '../utils/size.dart';

class SpecialMealSelectionBottomSheet extends StatelessWidget {
  final AllMeals meal;
  final List<SpecialItem> subjiList;

  const SpecialMealSelectionBottomSheet({
    super.key,
    required this.meal,
    required this.subjiList,
  });

  @override
  Widget build(BuildContext context) {
    final cartCtrl = Get.find<CartController>();

    return GetBuilder<CartController>(
      id: 'mealSelection',
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  meal.mealsName!,
                  style: AppCss.mulishSemiBold16,
                ),
                addVerticalSpace(Dimensions.heightSize * 1.5),
                Text(
                  "Select 1 Special Item",
                  style: AppCss.mulishSemiBold14,
                ),
                addVerticalSpace(Dimensions.heightSize * 0.6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: subjiList.map((subji) {

                    final id = int.parse(subji.specialItemId.toString());
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
                addVerticalSpace(Dimensions.heightSize * 1.5),
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
                          int.parse(subji.specialItemId.toString());
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

                addVerticalSpace(Dimensions.heightSize * 2),

                /// ===== SUBMIT BUTTON =====
                PrimaryButtonWidget(
                  text: "Add to Cart",
                  onPressed: () {
                    if (cartCtrl.isSpecialMealSelectionValid) {
                      final payload =
                      cartCtrl.buildSpecialMealPayload(meal);
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
              ],
            ),
          ),
        );
      },
    );
  }
}
