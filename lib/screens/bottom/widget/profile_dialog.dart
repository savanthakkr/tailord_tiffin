import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/screens/address/address_list_screen.dart';
import 'package:tailoredtiffin/screens/bottom/user_bottom_screen.dart';
import 'package:tailoredtiffin/utils/config.dart';

import '../../../controllers/bottom/bottom_bar_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../utils/validation_utils.dart';
import '../../../widgets/text_field_common.dart';
import '../../delivery_boy_order_list_screen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {

    // var profileCtrl = Get.find<ProfileController>();
    String deliveryBoyStatus = Prefs.shared.getString(Prefs.id_deliveryboy) ?? "0";

    print(deliveryBoyStatus);
    print("sdkjsakjdhksjdhksajd");

    return GetBuilder<ProfileController>(
      builder: (profileCtrl) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                  decoration: BoxDecoration(
                    color: const Color(0xffF3F6F2),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 30,
                        color: Colors.black.withOpacity(.25),
                        offset: const Offset(0, 15),
                      )
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: profileCtrl.regGlobalKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: appCtrl.appTheme.primary,
                            ),
                            child: const Icon(Icons.person_rounded, color: Colors.white, size: 40),
                          ),
                          addVerticalSpace(Dimensions.heightSize),
                          Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: profileCtrl.isEditName
                                      ? TextFieldCommon(
                                    controller: profileCtrl.nameController,
                                    labelText: 'name'.toUpperCase(),
                                    hintText: 'Enter name',
                                    validator: (value) => nameValidator(value,"Enter Name"),): Text(
                                    profileCtrl.nameController.text,
                                    style: AppCss.mulishSemiBold20
                                        .textColor(appCtrl.appTheme.textColor),
                                  ),
                                ),
                              ),
                              addHorizontalSpace(Dimensions.widthSize),
                              InkWell(
                                onTap: profileCtrl.toggleNameEdit,
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircleAvatar(
                                    radius: Dimensions.radius*2,
                                    backgroundColor: appCtrl.appTheme.deliveryBg,
                                    child: Icon(Icons.edit_rounded,size: 16, color: appCtrl.appTheme.deliveryIcon),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          addVerticalSpace(profileCtrl.isEditName ? Dimensions.heightSize : Dimensions.heightSize*0.3),
                          Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: profileCtrl.isEditEmail
                                      ? TextFieldCommon(
                                    controller: profileCtrl.emailController,
                                    labelText: 'Email'.toUpperCase(),
                                    hintText: 'Enter email',
                                    validator: (value) => emailValidator(value),
                                  )
                                      : Text(
                                    profileCtrl.emailController.text,
                                    style: AppCss.mulishRegular14
                                        .textColor(appCtrl.appTheme.hintColor),
                                  )
                                ),
                              ),
                              addHorizontalSpace(Dimensions.widthSize),
                              InkWell(
                                onTap: profileCtrl.toggleEmailEdit,
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircleAvatar(
                                    radius: Dimensions.radius*2,
                                    backgroundColor: appCtrl.appTheme.deliveryBg,
                                    child: Icon(Icons.edit_rounded,size: 16, color: appCtrl.appTheme.deliveryIcon),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          addVerticalSpace(profileCtrl.isEditEmail ? Dimensions.heightSize : Dimensions.heightSize*0),
                          Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    profileCtrl.userPhone ?? "",
                                    style: AppCss.mulishRegular14.textColor(appCtrl.appTheme.hintColor),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30,width: 30,),
                            ],
                          ),
                          if(profileCtrl.isEditName || profileCtrl.isEditEmail)
                            addVerticalSpace(Dimensions.heightSize*2),
                          if(profileCtrl.isEditName || profileCtrl.isEditEmail)
                            PrimaryButtonWidget(
                              text: 'Save Changes',
                              isLoading: profileCtrl.isLoading,
                              onPressed: () => profileCtrl.updateInfoMethod(),
                            ),
                          addVerticalSpace(Dimensions.heightSize*2),
                          Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radius*4),
                              color: appCtrl.appTheme.primary
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star_rounded, color: appCtrl.appTheme.white),
                                addHorizontalSpace(Dimensions.widthSize),
                                Text(
                                  "Become Verified",
                                  style: AppCss.mulishBold14.textColor(appCtrl.appTheme.white),
                                ),
                                addHorizontalSpace(Dimensions.widthSize),
                                Icon(Icons.arrow_forward_rounded, color: appCtrl.appTheme.white)
                              ],
                            ),
                          ),
                          addVerticalSpace(Dimensions.heightSize*2),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Quick Actions",
                              style: AppCss.mulishBold16.textColor(appCtrl.appTheme.textColor),
                            ),
                          ),
                          addVerticalSpace(Dimensions.heightSize),
                          _tile(
                            Icons.shopping_bag_outlined,
                            "My Orders",
                            "View your order history",
                            appCtrl.appTheme.orderBg,
                            appCtrl.appTheme.orderIcon,
                                () {
                              Get.back();
                              Get.find<BottomBarController>().onBottomTap(0);
                            },
                          ),
                          _tile(Icons.location_on_outlined, "Delivery Address",
                              "Manage your addresses", appCtrl.appTheme.deliveryBg, appCtrl.appTheme.deliveryIcon, (){
                                Get.back();
                                Get.to(()=> const AddressListScreen());
                              }
                          ),
                          _tile(Icons.credit_card_outlined, "Payment Methods",
                              "Cards, UPI & wallet", appCtrl.appTheme.paymentBg, appCtrl.appTheme.paymentIcon,(){
                                Get.back();
                              }),
                          if(deliveryBoyStatus == "1") _tile(Icons.bookmark_border, "Order List",
                              "Order List", appCtrl.appTheme.paymentBg, appCtrl.appTheme.paymentIcon,(){
                                Get.back();
                                Get.to(()=> const DeliveryBoyOrderHistoryScreen());

                              }),
                          _tile(Icons.help_outline_rounded, "Help & Support",
                              "Get assistance anytime", appCtrl.appTheme.helpBg, appCtrl.appTheme.helpIcon, (){
                                Get.back();
                              }),
                          addVerticalSpace(Dimensions.heightSize),
                          InkWell(
                            onTap: profileCtrl.showLogoutDialog,
                            child: Container(
                              height: 60,
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radius),
                                  color: appCtrl.appTheme.logoutColor
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.logout_rounded, color: appCtrl.appTheme.white),
                                    addHorizontalSpace(Dimensions.widthSize),
                                    Text(
                                      "Logout",
                                      style: AppCss.mulishBold14.textColor(appCtrl.appTheme.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 30,
                  top: 90,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: appCtrl.appTheme.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(.2),
                          )
                        ],
                      ),
                      child: const Icon(Icons.close),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  static Widget _tile(IconData icon, String title, String sub, Color bgColor, Color iconColor,VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14,),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: Dimensions.radius*2,
              backgroundColor: bgColor,
              child: Icon(icon, color: iconColor),
            ),
            addHorizontalSpace(Dimensions.widthSize*1.2),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppCss.mulishSemiBold16.textColor(appCtrl.appTheme.textColor)),
                    Text(sub, style: AppCss.mulishRegular14.textColor(appCtrl.appTheme.hintColor)),
                  ]),
            ),
             Icon(Icons.chevron_right_rounded,color: appCtrl.appTheme.hintColor,)
          ],
        ),
      ),
    );
  }
}