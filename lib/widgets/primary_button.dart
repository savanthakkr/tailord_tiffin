import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/config.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double width;
  final double height;
  final double radius;
  final bool isLoading;
  final bool smallButton;

  const PrimaryButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.width = 0,
    this.height = 50,
    this.radius = 10,
    this.isLoading = false,
    this.smallButton = false,
    this.borderColor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: smallButton ? 35 : height,
      width: width != 0 ? width : MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          elevation: 1,
          backgroundColor: backgroundColor ?? appCtrl.appTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
            side: borderColor!=null ? BorderSide(
              width: smallButton ? 1 : 2,
              color: borderColor!,
            ) : BorderSide.none,
          ),
        ),
        child: Center(
          child: isLoading ? CircularProgressIndicator(
            color: textColor ?? appCtrl.appTheme.sameWhite,
          )
              : Text(
            text,
            textAlign: TextAlign.center,
            style: smallButton ? GoogleFonts.poppins(
              color: textColor ?? appCtrl.appTheme.white,
              fontSize: Dimensions.smallestTextSize,
              fontWeight: FontWeight.w500,
            ) :
            GoogleFonts.poppins(
              color: textColor ?? appCtrl.appTheme.white,
              fontSize: Dimensions.mediumTextSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
