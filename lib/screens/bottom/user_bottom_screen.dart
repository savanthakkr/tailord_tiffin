import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/bottom/bottom_bar_controller.dart';
import 'package:tailoredtiffin/controllers/bottom/cart_controller.dart';
import 'package:tailoredtiffin/screens/bottom/cart_screen.dart';
import 'package:tailoredtiffin/screens/bottom/help_screen.dart';
import 'package:tailoredtiffin/screens/bottom/notification_screen.dart';
import 'package:tailoredtiffin/screens/bottom/premium_screen.dart';
import 'package:tailoredtiffin/screens/bottom/profile_screen.dart';
import 'package:tailoredtiffin/screens/bottom/search_screen.dart';
import 'package:tailoredtiffin/screens/bottom/widget/profile_dialog.dart';
import 'package:tailoredtiffin/screens/order_history_screen.dart';
import 'package:tailoredtiffin/widgets/cart_count_widget.dart';
import '../../../utils/config.dart';
import '../../controllers/address_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../controllers/profile_controller.dart';
import '../address/address_list_screen.dart';
import 'drawer_widget.dart';
import '../../widgets/tab_common.dart';
import 'home_screen.dart';
import 'wishlist_screen.dart';

class UserBottomBar extends StatefulWidget {
  final int initialIndex;
  const UserBottomBar({super.key,this.initialIndex = 2,});

  @override
  State<UserBottomBar> createState() => _UserBottomBarState();
}

class _UserBottomBarState extends State<UserBottomBar> {
  var bottomCtrl = Get.put(BottomBarController(),permanent: true);

  late NotificationController notificationCtrl;

  @override
  void initState() {
    super.initState();

    bottomCtrl.selectedIndex = widget.initialIndex;

    notificationCtrl = Get.put(NotificationController(), permanent: true);

    notificationCtrl.getUnreadCount(
        Prefs.shared.getString(Prefs.authToken)!
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomBarController>(
      builder: (ctrl) {
        return PopScope(
          canPop: bottomCtrl.canPopNow,
          onPopInvokedWithResult: bottomCtrl.onPopInvoked,
          child: Scaffold(
            key: bottomCtrl.bottomKey,
            backgroundColor: appCtrl.appTheme.white,
            appBar: AppBar(
              leadingWidth: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 10,
              elevation: bottomCtrl.selectedIndex == 0 ? 0 : 0.5,
              shadowColor: appCtrl.appTheme.secondaryText,
              scrolledUnderElevation: 0,
              backgroundColor: appCtrl.appTheme.white,
              centerTitle: false,
              title: GetBuilder<AddressController>(
                builder: (addressCtrl) {
                  final address = addressCtrl.defaultAddress;
                  return InkWell(
                    onTap: () {
                      Get.to(() => const AddressListScreen());
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: appCtrl.appTheme.black,
                          ),

                          addHorizontalSpace(Dimensions.widthSize),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      address == null
                                          ? "Add Address"
                                          : address.addressTitle ?? "Address",
                                      style: AppCss.mulishBold14
                                          .textColor(appCtrl.appTheme.textColor),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: appCtrl.appTheme.primary,
                                    ),
                                  ],
                                ),

                                Text(
                                  address == null
                                      ? "Tap to add delivery address"
                                      : "${address.fullAddress}, ${address.landmark}, ${address.city}, ${address.pincode}, ${address.state}",
                                  style: AppCss.mulishLight12
                                      .textColor(appCtrl.appTheme.hintColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ),
                  );
                },
              ),
              leading: null,
              actions: [
                GetBuilder<CartController>(
                  id: 'cartCount',
                  builder: (cartController) {
                    return InkWell(
                      onTap: () => Get.to(const CartScreen()),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [

                          Icon(
                            Icons.shopping_cart_outlined,
                            color: appCtrl.appTheme.black,
                            size: 28,
                          ),

                          Positioned(
                            right: -4,
                            top: -4,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Center(
                                child: Text(
                                  cartController.cartCount.toString(),
                                  style: AppCss.mulishLight12.copyWith(color: appCtrl.appTheme.white,fontSize: Dimensions.nanoTextSize)
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
                addHorizontalSpace(Dimensions.widthSize),
                InkWell(
                  onTap: () => openProfileDialog(context),
                    child: Icon(Icons.person_rounded,color: appCtrl.appTheme.black,)),
                addHorizontalSpace(Dimensions.widthSize),
              ],
            ),
            // drawerEnableOpenDragGesture: false,
            // drawer: const DrawerWidget(),
            body:  bottomCtrl.selectedIndex == 0
                                ? const OrderHistoryScreen()
                                // : bottomCtrl.selectedIndex == 1
                                // ? const SearchScreen()
                                : bottomCtrl.selectedIndex == 1
                                ? const NotificationScreen()
                                : bottomCtrl.selectedIndex == 2
                                ? const HomeScreen()
                                : bottomCtrl.selectedIndex == 3
                                ? const PremiumScreen()
                                : bottomCtrl.selectedIndex == 4
                                ? const HelpScreen()
                                : Center(
                                  child: Text(
                                    '${bottomCtrl.selectedIndex}: Coming Soon',
                                    style: AppCss.mulishSemiBold16.textColor(appCtrl.appTheme.primary),
                                  ),
                                ),
            bottomNavigationBar: BottomAppBar(
              padding: EdgeInsets.zero,
              color: Colors.transparent,
              shape: AutomaticNotchedShape(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.radius*1.5))
                ),
              ),
              child: Card(
                elevation: 5,
                margin: EdgeInsets.zero,
                color: appCtrl.appTheme.textFieldColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: appCtrl.appTheme.borderColor,
                    width: 1,
                  )
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: mainMax,
                    children: <Widget>[
                      TabCommon(
                        onTap:() => bottomCtrl.onBottomTap(0),
                        index: 0,
                        selectedIndex:  bottomCtrl.selectedIndex,
                        image: assets.orderPng,
                        title: 'Orders',
                      ),
                      GetBuilder<NotificationController>(
                        builder: (notifyCtrl) {
                          return TabCommon(
                            onTap: () => bottomCtrl.onBottomTap(1),
                            index: 1,
                            selectedIndex: bottomCtrl.selectedIndex,
                            title: 'Notification',
                            image: assets.notificationPng,
                            badgeCount: notifyCtrl.unreadCount,
                          );
                        },
                      ),
                      TabCommon(
                        onTap:() => bottomCtrl.onBottomTap(2),
                        index: 2,
                        selectedIndex:  bottomCtrl.selectedIndex,
                        title: 'Home',
                        image: assets.homePng,
                        selectedImage: assets.logo_small,
                      ),
                      TabCommon(
                        onTap:() => bottomCtrl.onBottomTap(3),
                        index: 3,
                        selectedIndex:  bottomCtrl.selectedIndex,
                        title: 'Premium',
                        image: assets.premiumPng,
                      ),
                      TabCommon(
                        onTap:() => bottomCtrl.onBottomTap(4),
                        index: 4,
                        selectedIndex:  bottomCtrl.selectedIndex,
                        title: 'Help',
                        image: assets.helpPng,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  void openProfileDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Profile",
      barrierColor: Colors.black.withOpacity(0.45),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => const SizedBox(),
      transitionBuilder: (context, anim, _, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim.value),
          child: Opacity(
            opacity: anim.value,
            child: const ProfileDialog(),
          ),
        );
      },
    );
  }
}
