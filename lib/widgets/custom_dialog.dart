import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/config.dart';


class CustomDialog extends StatelessWidget {
  final String text;
  final String buttonText;
  final Function()? onTap;

  const CustomDialog({super.key, required this.text, required this.buttonText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      backgroundColor: appCtrl.appTheme.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: appCtrl.appTheme.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  child: Text(
                    text,
                    style: AppCss.sansSemiBold16.textColor(appCtrl.appTheme.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.7),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              'Cancel',
                              style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 48,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: onTap,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              buttonText,
                              style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.primary),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          addVerticalSpace(Dimensions.heightSize),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: SizedBox(
              height: 32,
              width: 32,
              child: Icon(Icons.close_rounded,color: appCtrl.appTheme.textColor,),
            ),
          ),
        ],
      ),
    );
  }
}
