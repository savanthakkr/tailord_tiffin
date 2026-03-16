import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailoredtiffin/app_theme/text_style_extensions.dart';

import '../utils/dimensions.dart';

class AppCss {

  static TextStyle get poppins => GoogleFonts.poppins();

  //encode sans
  static TextStyle encodeSans = TextStyle(
    fontFamily: GoogleFonts.poppins().fontFamily,
    letterSpacing: 0,
    height: 1,
  );

  //inter font
  static TextStyle inter = TextStyle(
    fontFamily: GoogleFonts.poppins().fontFamily,
    letterSpacing: 0,
    height: 1,
  );
  //mulish font
  static TextStyle mulish = TextStyle(
    fontFamily: GoogleFonts.poppins().fontFamily,
    // letterSpacing: 0,
    // height: 1,
  );

  static TextStyle get introHeading => mulish.bold.size(Dimensions.extraLargeTextSize);
  static TextStyle get introText => mulish.regular.size(Dimensions.mediumTextSize);

  static TextStyle get sansRegular14 => encodeSans.regular.size(Dimensions.regularTextSize);
  static TextStyle get sansSemiBold16 => encodeSans.semiBold.size(Dimensions.mediumTextSize);
  static TextStyle get sansBold18 => encodeSans.extraBold.size(Dimensions.defaultTextSize);
  static TextStyle get sansExtraBold60 => encodeSans.extraThickBold.size(Dimensions.maxTextSize);
  static TextStyle get sansExtraBold40 => encodeSans.extraThickBold.size(Dimensions.ultraLargeTextSize);

//Text Style mulish extra bold
  static TextStyle get mulishExtraBold24 => mulish.extraThickBold.size(Dimensions.extraLargeTextSize);
  static TextStyle get mulishExtraBold20 => mulish.extraThickBold.size(Dimensions.largeTextSize);
  static TextStyle get mulishExtraBold18 => mulish.extraThickBold.size(Dimensions.defaultTextSize);
  static TextStyle get mulishExtraBold16 => mulish.extraThickBold.size(Dimensions.mediumTextSize);
  

  //Text Style mulish bold
  // static TextStyle get mulishblack28 => mulish.black.size(FontSizes.f28);
  // static TextStyle get mulishblack24 => mulish.black.size(FontSizes.f24);
  // static TextStyle get mulishblack20 => mulish.black.size(Dimensions.largeTextSize);
  // static TextStyle get mulishblack18 => mulish.black.size(Dimensions.defaultTextSize);
  // static TextStyle get mulishblack16 => mulish.black.size(Dimensions.mediumTextSize);
  // static TextStyle get mulishblack14 => mulish.black.size(Dimensions.regularTextSize);


  //Text Style mulish bold
  static TextStyle get mulishExtraBold15 => mulish.extraBold.size(Dimensions.smallTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishExtraBold14 => mulish.extraBold.size(Dimensions.regularTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishExtraBold12 => mulish.extraBold.size(Dimensions.smallestTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);

  //Text Style semi mulish bold
  static TextStyle get mulishBold24 => mulish.bold.size(Dimensions.extraLargeTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishBold20 => mulish.bold.size(Dimensions.largeTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishBold18 => mulish.bold.size(Dimensions.defaultTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishBold16 => mulish.bold.size(Dimensions.mediumTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishBold15 => mulish.bold.size(Dimensions.smallTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishBold14 => mulish.bold.size(Dimensions.regularTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishBold12 => mulish.bold.size(Dimensions.smallestTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishBold10 => mulish.bold.size(Dimensions.nanoTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);

  static TextStyle get mulishSemiBold24=> mulish.semiBold.size(Dimensions.extraLargeTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  // static TextStyle get mulishSemiBold22=> mulish.semiBold.size();
  static TextStyle get mulishSemiBold20=> mulish.semiBold.size(Dimensions.largeTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishSemiBold18=> mulish.semiBold.size(Dimensions.defaultTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishSemiBold16=> mulish.semiBold.size(Dimensions.mediumTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishSemiBold15=> mulish.semiBold.size(Dimensions.smallTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishSemiBold14 =>
      mulish.semiBold
          .size(Dimensions.regularTextSize)
          .copyWith(fontFamily: 'Poppins');
  static TextStyle get mulishSemiBold13=> mulish.semiBold.size(Dimensions.listTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishSemiBold12=> mulish.semiBold.size(Dimensions.smallestTextSize)..copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishSemiBold10=> mulish.semiBold.size(Dimensions.nanoTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);


  //Text Style mulish medium
  static TextStyle get mulishMedium20 => GoogleFonts.poppins(
      fontSize: Dimensions.largeTextSize,fontWeight: FontWeight.w500
  );
  static TextStyle get mulishMedium18 => GoogleFonts.poppins(
      fontSize: Dimensions.defaultTextSize,fontWeight: FontWeight.w500
  );
  static TextStyle get mulishMedium16 => GoogleFonts.poppins(
      fontSize: Dimensions.mediumTextSize,fontWeight: FontWeight.w500
  );
  static TextStyle get mulishMedium15 => GoogleFonts.poppins(
    fontSize: Dimensions.smallTextSize,fontWeight: FontWeight.w500
  );
  static TextStyle get mulishMedium14 => GoogleFonts.poppins(
      fontSize: Dimensions.regularTextSize,fontWeight: FontWeight.w500
  );
  static TextStyle get mulishMedium12 => GoogleFonts.poppins(
      fontSize: Dimensions.smallestTextSize,fontWeight: FontWeight.w500
  );
  static TextStyle get mulishMedium13 => GoogleFonts.poppins(
      fontSize: Dimensions.listTextSize,fontWeight: FontWeight.w500
  );
  static TextStyle get mulishMedium10 => GoogleFonts.poppins(
      fontSize: Dimensions.nanoTextSize,fontWeight: FontWeight.w500
  );

  //Text Style mulish regular
  static TextStyle get mulishRegular18 => mulish.regular.size(Dimensions.defaultTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishRegular16 => mulish.regular.size(Dimensions.mediumTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishRegular14 => mulish.regular.size(Dimensions.regularTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishRegular12 => mulish.regular.size(Dimensions.smallestTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishRegular15 => mulish.regular.size(Dimensions.smallTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);


  static TextStyle get mulishLight16 => mulish.light.size(Dimensions.mediumTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishLight14 => mulish.light.size(Dimensions.regularTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishLight13 => mulish.light.size(Dimensions.listTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishLight12 => mulish.light.size(Dimensions.smallestTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);

  static TextStyle get mulishExtraLight14 => mulish.extraLight.size(Dimensions.regularTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle get mulishExtraLight12 => mulish.extraLight.size(Dimensions.smallestTextSize).copyWith(fontFamily: GoogleFonts.poppins().fontFamily);

}
