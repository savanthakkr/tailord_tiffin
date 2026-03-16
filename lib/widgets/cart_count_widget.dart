import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/bottom/bottom_bar_controller.dart';

import '../controllers/bottom/cart_controller.dart';
import '../utils/config.dart';

class CartCountWidget extends StatelessWidget {
  const CartCountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var cartCtrl = Get.find<CartController>();

    return GetBuilder<CartController>(
      id: 'cartList',
      builder: (ctrl) {
        return InkWell(
          onTap: () {
            var bottomCtrl = Get.find<BottomBarController>();
            bottomCtrl.onBottomTap(1);
            if (Get.previousRoute != "") {
              Get.back();   // closes current page
            }
          },
          child: SizedBox(
            height: 35,
            width: 35,
            child: Stack(
              children: [
                SvgPicture.asset(
                  assets.bagSvg,
                  height: 28,
                  width: 28,
                  colorFilter: ColorFilter.mode(appCtrl.appTheme.primary, BlendMode.srcATop),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appCtrl.appTheme.errorColor
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      cartCtrl.cartList != null ? '${cartCtrl.cartList!.length}' : '0',
                      style: AppCss.mulishMedium10.textColor(appCtrl.appTheme.white),
                    ),
                  ),
                )
              ],
            ),
          ).marginSymmetric(horizontal: Dimensions.widthSize),
        );
      }
    );
  }
}
