import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/order_controller.dart';
import 'package:tailoredtiffin/screens/order_history_screen.dart';
import 'package:tailoredtiffin/utils/config.dart';

import '../../controllers/bottom/bottom_bar_controller.dart';
import '../../controllers/history_controller.dart';
import '../../widgets/empty_layout.dart';
import '../bottom/user_bottom_screen.dart';

class CommonOrderLayout extends StatelessWidget {
  final bool isSuccess;
  const CommonOrderLayout({super.key,required this.isSuccess});

  Future<bool> _onBackPressed() async{
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    Get.offAll(()=> const UserBottomBar());
    return false;
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
        child: GetBuilder<OrderController>(
          builder: (ctrl) {
            return Scaffold(
              backgroundColor: appCtrl.appTheme.white,
              body: isSuccess
              ? EmptyLayout(
                image: assets.orderSuccessPng,
                title: 'Thank you for your order!',
                subtitle: 'Your order will be delivered on time. Thank you!',
                btnText: 'View Orders',
                onBtnTap: () async {

                  final historyCtrl = Get.find<HistoryController>();

                  await historyCtrl.getHistory();

                  Get.offAll(() => const UserBottomBar(initialIndex: 0));
                },
                secondaryBtnText: 'Continue Shopping',
                onSecondaryBtnTap: () {
                  Get.offAll(()=> const UserBottomBar(initialIndex: 2,));
                },
              )
              : EmptyLayout(
                image: assets.orderSuccessPng,
                title: 'Sorry! Your order has failed!',
                subtitle: 'Something went wrong. Please try again to continue your order.',
                btnText: 'try again',
                onBtnTap: () => ctrl.placeOrderMethod(),
                secondaryBtnText: 'go to home',
                onSecondaryBtnTap: () {
                  Get.offAll(()=> const UserBottomBar(initialIndex: 0,));
                },
              ),
            );
          }
        )
    );
  }
}
