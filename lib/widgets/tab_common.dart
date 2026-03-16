import 'package:flutter/material.dart';
import '../utils/config.dart';
import '../utils/dimensions.dart';

class TabCommon extends StatelessWidget {
  final int? index, selectedIndex;
  final String? title;
  final String image;
  final String? selectedImage;
  final GestureTapCallback? onTap;
  final int badgeCount;

  const TabCommon({
    super.key,
    required this.title,
    required this.index,
    required this.image,
    this.selectedImage,
    required this.selectedIndex,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {

    final bool isSelected = selectedIndex == index;

    return Container(
      constraints: BoxConstraints(
        minWidth: Dimensions.marginSize * 2,
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Stack(
              clipBehavior: Clip.none,
              children: [

                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Image.asset(
                    /// 🔹 If selectedImage exists → change image
                    isSelected && selectedImage != null
                        ? selectedImage!
                        : image,

                    height: isSelected ? 40 : 25,
                    width: isSelected ? 40 : 25,

                    /// 🔹 Only apply color if selectedImage is null
                    color: selectedImage == null
                        ? (isSelected
                        ? (index! >= 3
                        ? Colors.red
                        : appCtrl.appTheme.primary)
                        : appCtrl.appTheme.unSelect)
                        : null,

                    colorBlendMode: BlendMode.srcIn,
                    fit: BoxFit.contain,
                  ),
                ),

                /// Badge
                if (badgeCount > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badgeCount > 9 ? "9+" : badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}