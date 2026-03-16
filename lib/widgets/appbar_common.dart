import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/config.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GestureTapCallback? leadingOnTap;
  final double elavation;
  final List<Widget>? actions;
  final Color? bgColor;
  final Color? textColor ;
  final bool centerTitle;
  final bool backEnable;
  final bool isBoldText;

  const CommonAppbar(
      {
        super.key,
        required this.title,
        this.leadingOnTap,
        this.elavation = 0,
        this.actions,
        this.bgColor,
        this.textColor,
        this.centerTitle = false,
        this.backEnable = false,
        this.isBoldText = false
      });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor ?? appCtrl.appTheme.cardColor,
      scrolledUnderElevation: elavation,
      elevation: elavation,
      centerTitle: centerTitle,
      // shadowColor: appCtrl.appTheme.black,
      surfaceTintColor: Colors.transparent,
      leadingWidth: 30,
      toolbarHeight: kToolbarHeight*1.5,
      title: Text(title,
        style: GoogleFonts.poppins(
          color: textColor ?? appCtrl.appTheme.black,
          fontSize:  (isBoldText && !backEnable) ? Dimensions.defaultTextSize : Dimensions.mediumTextSize,
          fontWeight: isBoldText ? FontWeight.w700 : FontWeight.w500,
        ),),
      leading: backEnable ?  InkWell(
        onTap: leadingOnTap,
        child: Icon(Icons.arrow_back_ios_new,color: textColor,size: Dimensions.iconSizeDefault,),
      ): null,
      automaticallyImplyLeading: false,
      actions: actions,
    );
  }

  @override
  // implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
