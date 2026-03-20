import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/bottom/cart_controller.dart';
import 'package:tailoredtiffin/controllers/bottom/home_controller.dart';
import 'package:tailoredtiffin/controllers/bottom/wish_controller.dart';
import 'package:tailoredtiffin/model/all_bread_model.dart';
import 'package:tailoredtiffin/model/all_meals_model.dart';
import 'package:tailoredtiffin/model/all_subji_model.dart';
import 'package:tailoredtiffin/model/cart_model.dart';
import 'package:tailoredtiffin/model/product.dart';
import 'package:tailoredtiffin/model/special_item_model.dart';
import 'package:tailoredtiffin/screens/product_detail_screen.dart';
import 'package:tailoredtiffin/widgets/rounded_icon.dart';

import '../utils/config.dart';

class ProductWidget extends StatelessWidget {
  final AllMeals product;
  final List<Subji> subjiList;
  final List<Bread> breadList;
  final List<SpecialItem> specialItemList;

  const ProductWidget({
    super.key,
    required this.product,
    required this.subjiList,
    required this.breadList,
    required this.specialItemList
  });

  @override
  Widget build(BuildContext context) {
    final cartCtrl = Get.find<CartController>();

    return GetBuilder<CartController>(
      id: 'cartList',
      builder: (_) {
        final bool isAdded = cartCtrl.cartList != null
            ? addedToCart(cartCtrl.cartList!)
            : false;

        return InkWell(
          onTap: (){
            if(product.isSpecialMeal == "1"){
              cartCtrl.openSpecialMealSelectionSheet(
                  product, specialItemList);
            } else {
              cartCtrl.openMealSelectionSheet(
                  product, subjiList, breadList);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: appCtrl.appTheme.textFieldColor,
              borderRadius: BorderRadius.all(
                Radius.circular(Dimensions.radius*1.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius*1.5),
                    topRight: Radius.circular(Dimensions.radius*1.5),
                  ),
                  child: Image.network(
                    "${ApiManager.imgUrl}${product.image}",
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: crossStart,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        product.mealsName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppCss.mulishBold14
                            .textColor(appCtrl.appTheme.textColor).copyWith(fontFamily: 'Poppins-SemiBold'),
                      ),
                      addVerticalSpace(Dimensions.heightSize * 0.05),
                      Text(
                        product.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppCss.mulishMedium12
                            .textColor(appCtrl.appTheme.secondaryText)
                            .copyWith(fontFamily: 'Poppins-Italic'),
                      ),
                      // Text(
                      //   '\u20b9${product.price}',
                      //   style: AppCss.mulishSemiBold14
                      //       .textColor(appCtrl.appTheme.primary),
                      // ),
                    ],
                  ),
                )
                //
                // /// PUSH BUTTON TO BOTTOM
                // const Spacer(),
                //
                // /// ADD TO CART BUTTON (BOTTOM)
                // PrimaryButtonWidget(
                //   onPressed: (){
                //     // if(isAdded){
                //     //   UIUtils.bottomToast(text: 'Already into cart', isError: true);
                //     // } else {
                //     //   cartCtrl.openMealSelectionSheet(product, subjiList, breadList);
                //     // }
                //     if(product.isSpecialMeal == "1"){
                //       cartCtrl.openSpecialMealSelectionSheet(
                //           product, specialItemList);
                //     } else {
                //       cartCtrl.openMealSelectionSheet(
                //           product, subjiList, breadList);
                //     }
                //   },
                //   smallButton: true,
                //   text: "Add to Cart",
                //   // text: isAdded ? "Added" : "Add to Cart",
                // ),
                // SizedBox(
                //   width: double.infinity,
                //   height: 36,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: isAdded
                //           ? appCtrl.appTheme.hintColor
                //           : appCtrl.appTheme.primary,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(6),
                //       ),
                //     ),
                //     onPressed: isAdded
                //         ? null
                //         : () {
                //       cartCtrl.addProductToCart(
                //         productId: product.mealsId!,
                //       );
                //       cartCtrl.update(['cartList']);
                //     },
                //     child: Text(
                //       isAdded ? "Added" : "Add to Cart",
                //       style: AppCss.mulishSemiBold12
                //           .textColor(appCtrl.appTheme.white),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool addedToCart(List<CartData> cartList) {
    return cartList.any(
          (item) => item.meal!.mealId == product.mealsId,
    );
  }
}

