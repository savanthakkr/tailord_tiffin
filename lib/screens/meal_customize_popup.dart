import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import '../utils/config.dart';

class MealCustomizePopup extends StatelessWidget {
  final controller = Get.put(NotificationController());

  MealCustomizePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 10,
      backgroundColor: appCtrl.appTheme.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: GetBuilder<NotificationController>(
          builder: (ctrl) {

            final selectedMeal = ctrl.allMealList.firstWhereOrNull(
                    (e) => int.parse(e.mealsId!) == ctrl.selectedMealId);

            return Column(
              children: [

                /// HEADER
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.highlight_remove_rounded,color: appCtrl.appTheme.textColor,),
                  ),
                ),
                Image.asset(
                  assets.popupImagePng,
                  height: 130,
                  width: 130,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// 🔹 MEAL DROPDOWN
                        _customDropdown(
                          title: selectedMeal?.mealsName ?? "Choose Meal",
                          isExpanded: ctrl.mealExpanded,
                          onTap: () {
                            ctrl.mealExpanded = !ctrl.mealExpanded;
                            ctrl.update();
                          },
                        ),

                        if (ctrl.mealExpanded)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [BoxShadow(color: Colors.black12)],
                            ),
                            child: Column(
                              children: ctrl.allMealList.map((meal) {
                                return RadioListTile<int>(
                                  value: int.parse(meal.mealsId!),
                                  groupValue: ctrl.selectedMealId,
                                  onChanged: (val) => ctrl.selectMeal(val!),
                                  title: Text(meal.mealsName ?? ""),
                                );
                              }).toList(),
                            ),
                          ),

                        /// 🔹 SUBJI
                        _sectionTitle("Choose Subji (${ctrl.subjiLimit})"),
                        Wrap(
                          children: ctrl.allSubjiList.map((subji) {
                            int id = int.parse(subji.subjiId!);
                            int qty = ctrl.subjiQty[id] ?? 0;

                            return Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: qty > 0
                                    ? appCtrl.appTheme.primary.withOpacity(0.1)
                                    : Colors.white,
                                border: Border.all(color: appCtrl.appTheme.primary),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  /// NAME
                                  Text(
                                    subji.name ?? "",
                                    style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.primary)
                                  ),
                                  addHorizontalSpace(Dimensions.widthSize*0.5),

                                  /// MINUS
                                  if (qty > 0)
                                    GestureDetector(
                                      onTap: () => ctrl.decrementSubji(id),
                                      child: Icon(Icons.remove_rounded,color: appCtrl.appTheme.textColor, size: 16),
                                    ),

                                  if (qty > 0)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: Text("$qty",style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.textColor),),
                                    ),

                                  /// ADD
                                  GestureDetector(
                                    onTap: () => ctrl.incrementSubji(id),
                                    child: Icon(Icons.add_rounded, color: appCtrl.appTheme.textColor, size: 16),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        /// 🔹 BREAD
                        _sectionTitle("Choose Bread"),
                        Wrap(
                          children: ctrl.allBreadList.map((bread) {
                            int id = int.parse(bread.breadId!);
                            bool isSelected = ctrl.selectedBreadId == id;

                            return GestureDetector(
                              onTap: () => ctrl.selectBread(id),
                              child: Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? appCtrl.appTheme.primary
                                      : Colors.white,
                                  border: Border.all(
                                      color: appCtrl.appTheme.primary),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  bread.name ?? "",
                                  style: AppCss.mulishRegular12.textColor(isSelected ? appCtrl.appTheme.white : appCtrl.appTheme.primary),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        /// 🔹 EXTRA ITEMS
                        _sectionTitle("Extra Items"),
                        Column(
                          children: ctrl.allSpecialItem.map((item) {
                            int id = int.parse(item.specialItemId!);
                            int qty = ctrl.extraQty[id] ?? 0;

                            return Row(
                              children: [
                                Expanded(child: Text(item.name ?? "",style: AppCss.mulishMedium12.textColor(appCtrl.appTheme.textColor),)),
                                IconButton(
                                  icon: Icon(Icons.remove_rounded,color: appCtrl.appTheme.textColor,size: 18,),
                                  onPressed: () => ctrl.decrementExtra(id),
                                ),
                                Text("$qty",style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.textColor),),
                                IconButton(
                                  icon: Icon(Icons.add_rounded,color: appCtrl.appTheme.textColor,size: 18,),
                                  onPressed: () => ctrl.incrementExtra(id),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                /// 🔻 BOTTOM
                Divider(color: appCtrl.appTheme.borderColor,),
                addVerticalSpace(Dimensions.heightSize*0.5),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: appCtrl.appTheme.deliveryBg,
                        border: Border.all(color: appCtrl.appTheme.deliveryIcon),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_rounded,color: appCtrl.appTheme.textColor,),
                            onPressed: ctrl.decrementQty,
                          ),
                          Text("${ctrl.quantity}",style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.textColor),),
                          IconButton(
                            icon: Icon(Icons.add_rounded,color: appCtrl.appTheme.textColor,),
                            onPressed: ctrl.incrementQty,
                          ),
                        ],
                      ),
                    ),
                    addHorizontalSpace(Dimensions.widthSize),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius),
                            color: appCtrl.appTheme.logoutColor,
                          ),
                          child: Text("Order ₹${ctrl.totalPrice.toStringAsFixed(0)}",style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.white),textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _customDropdown({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6)
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.textColor),),
            Icon(isExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down)
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title,
          style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.textColor)),
    );
  }
}