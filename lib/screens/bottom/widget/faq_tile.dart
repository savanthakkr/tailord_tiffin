import 'package:flutter/material.dart';
import 'package:tailoredtiffin/utils/config.dart';

class FaqTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;

  const FaqTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            height: 20,
            width: 20,
            image,
            fit: BoxFit.cover,
          ),
          addHorizontalSpace(Dimensions.widthSize),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppCss.mulishSemiBold16.textColor(appCtrl.appTheme.textColor)),
                addVerticalSpace(Dimensions.heightSize*0.5),
                Text(subtitle,
                    style: AppCss.mulishRegular12.textColor(appCtrl.appTheme.hintColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}