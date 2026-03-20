import 'package:flutter/material.dart';

import '../../../utils/config.dart';

class CommonInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconBgColor;
  final Color? iconColor;

  const CommonInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconBgColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: appCtrl.appTheme.white,
        borderRadius: BorderRadius.circular(Dimensions.radius*1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: iconBgColor ?? appCtrl.appTheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor ?? appCtrl.appTheme.primary,
              size: 22,
            ),
          ),
          addHorizontalSpace(Dimensions.widthSize*1.5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppCss.mulishSemiBold14
                      .textColor(appCtrl.appTheme.textColor),
                ),
                addVerticalSpace(Dimensions.heightSize*0.5),
                Text(
                  subtitle,
                  style: AppCss.mulishMedium12
                      .textColor(appCtrl.appTheme.secondaryText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}