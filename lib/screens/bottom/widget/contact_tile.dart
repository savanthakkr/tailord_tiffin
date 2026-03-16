import 'package:flutter/material.dart';
import 'package:tailoredtiffin/utils/config.dart';

class ContactTile extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback? onTap;

  const ContactTile({
    super.key,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.actionText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appCtrl.appTheme.white,
          borderRadius: BorderRadius.circular(Dimensions.radius),
          boxShadow: [
            BoxShadow(
              blurRadius: Dimensions.radius,
              color: Colors.black.withOpacity(.12),
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            addHorizontalSpace(Dimensions.widthSize),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppCss.mulishMedium16.textColor(appCtrl.appTheme.textColor)),
                  addVerticalSpace(Dimensions.heightSize*0.3),
                  Text(subtitle,
                      style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.hintColor)),
                  addVerticalSpace(Dimensions.heightSize*0.5),
                  Text(actionText,
                      style: AppCss.mulishMedium14.textColor(iconColor)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: appCtrl.appTheme.hintColor)
          ],
        ),
      ),
    );
  }
}