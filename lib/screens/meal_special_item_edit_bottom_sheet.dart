import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/model/special_item_model.dart';

import '../app_theme/app_css.dart';
import '../controllers/bottom/cart_controller.dart';
import '../model/cart_model.dart';
import '../utils/config.dart';
import '../utils/dimensions.dart';
import '../utils/size.dart';

class MealSpecialItemEditBottomSheet extends StatelessWidget {
  final List<SpecialItem> specialItemList;
  final CartData cartItem;
  const MealSpecialItemEditBottomSheet({super.key,
    required this.specialItemList,
    required this.cartItem});

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
                  "Extra Items",
                  style: AppCss.mulishSemiBold14,
                ),
                addVerticalSpace(Dimensions.heightSize * 0.5),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: specialItemList.map((subji) {
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
                addVerticalSpace(Dimensions.heightSize*0.5),

                /// ===== SUBMIT BUTTON =====
                PrimaryButtonWidget(
                  text: "Update Cart",
                  onPressed: () {
                    final payload = cartCtrl.buildEditSpecialMealPayload(cartItem);
                    print("PayLoad $payload");
                    cartCtrl.updateMeals(payload: payload);
                    Get.back();
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
