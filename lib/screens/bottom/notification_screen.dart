import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/screens/meal_customize_popup.dart';
import 'package:tailoredtiffin/utils/config.dart';
import 'package:tailoredtiffin/widgets/rounded_icon.dart';
import '../../controllers/notification_controller.dart';
import '../../utils/prefs.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  late NotificationController notificationCtrl;

  String? authToken,userId;

  @override
  void initState() {
    super.initState();

    notificationCtrl = Get.find<NotificationController>();

    authToken = Prefs.shared.getString(Prefs.authToken);
    userId = Prefs.shared.getString(Prefs.userId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationCtrl.getNotifications(authToken!);
      notificationCtrl.markAsRead(authToken!);
    });
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<NotificationController>(
      builder: (ctrl) {

        if (ctrl.isLoading) {
          return Center(child: CircularProgressIndicator(color: appCtrl.appTheme.primary,));
        }

        if (ctrl.notificationList.isEmpty) {
          return const Center(child: Text("No Notifications"));
        }

        return Column(
          children: [
            addVerticalSpace(Dimensions.heightSize),
            Row(
              children: [
                RoundedIconWidget(
                  color: appCtrl.appTheme.deliveryBg,
                  iconColor: appCtrl.appTheme.deliveryIcon,
                  svgAsset: assets.notificationSvg,
                  padding: 5,
                  height: 40,
                ),
                addHorizontalSpace(Dimensions.widthSize*2),
                Expanded(
                  child: Text(
                    "Notifications",
                    style: AppCss.mulishBold18.textColor(appCtrl.appTheme.textColor),
                  ),
                ),
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: appCtrl.appTheme.primary,
                    shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Text(
                      ctrl.notificationList.length.toString(),
                      style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                addHorizontalSpace(Dimensions.widthSize*0.5),
                RoundedIconWidget(
                  color: appCtrl.appTheme.logoutBg,
                  iconColor: appCtrl.appTheme.logoutColor,
                  svgAsset: assets.deleteSvg,
                  padding: 6,
                  height: 30,
                ),
              ],
            ).marginSymmetric(horizontal: 15),
            addVerticalSpace(Dimensions.heightSize),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: ctrl.notificationList.length,
                itemBuilder: (context, index) {

                  final notification = ctrl.notificationList[index];

                  return InkWell(
                    onTap: (){
                      Get.dialog(
                        MealCustomizePopup(),
                        barrierDismissible: true,
                      );
                    },
                    child: Card(
                      elevation: 2,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radius),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                        child: Row(
                          children: [
                            RoundedIconWidget(
                              color: appCtrl.appTheme.deliveryBg,
                              iconColor: appCtrl.appTheme.deliveryIcon,
                              svgAsset: assets.emailSvg,
                              padding: 8,
                              height: 40,
                            ),
                            addHorizontalSpace(Dimensions.widthSize),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.title ?? "",
                                    style: AppCss.mulishBold14.textColor(appCtrl.appTheme.textColor),
                                  ),
                                  addVerticalSpace(Dimensions.heightSize*0.3),
                                  Text(
                                    notification.message ?? "",
                                    style: AppCss.mulishMedium12.textColor(appCtrl.appTheme.secondaryText),
                                  ),
                                  addVerticalSpace(Dimensions.heightSize*0.3),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time,color: appCtrl.appTheme.secondaryText,size: 16,),
                                      addHorizontalSpace(Dimensions.widthSize*0.5),
                                      Text(
                                        notification.createdAt ?? "",
                                        style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.secondaryText),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            addHorizontalSpace(Dimensions.widthSize),
                            Icon(Icons.arrow_forward_ios_rounded,color: appCtrl.appTheme.secondaryText,size: 20,)
                          ],
                        ),
                      )
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}