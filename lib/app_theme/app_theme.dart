import 'package:flutter/material.dart';

enum ThemeType {
  light,
  dark,
}


class AppTheme {
  static ThemeType defaultTheme = ThemeType.light;


  //Theme Colors
  bool isDark;
  Color primary;
  Color secondaryText;
  Color primaryYellow;
  Color saleGreen;
  Color primaryLight;
  Color black;
  Color white;
  Color sameWhite;
  Color sameBlack;
  Color textColor;
  Color hintColor;
  Color cardColor;
  Color errorColor;
  Color textFieldColor;
  Color borderColor;
  Color btnSecondary;
  Color shimmerBase;
  Color shimmerHighlight;
  Color ratingYellow;
  Color splashBg;
  Color unSelect;
  Color orderBg;
  Color orderIcon;
  Color deliveryBg;
  Color deliveryIcon;
  Color paymentBg;
  Color paymentIcon;
  Color helpBg;
  Color helpIcon;
  Color logoutColor;
  Color logoutBg;

  /// Default constructor
  AppTheme({
    required this.isDark,
    required this.primary,
    required this.secondaryText,
    required this.primaryYellow,
    required this.saleGreen,
    required this.primaryLight,
    required this.black,
    required this.white,
    required this.sameWhite,
    required this.sameBlack,
    required this.textColor,
    required this.hintColor,
    required this.cardColor,
    required this.errorColor,
    required this.textFieldColor,
    required this.borderColor,
    required this.btnSecondary,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.ratingYellow,
    required this.splashBg,
    required this.unSelect,
    required this.orderBg,
    required this.orderIcon,
    required this.deliveryBg,
    required this.deliveryIcon,
    required this.paymentBg,
    required this.paymentIcon,
    required this.helpBg,
    required this.helpIcon,
    required this.logoutColor,
    required this.logoutBg,
  });

  /// fromType factory constructor
  factory AppTheme.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return AppTheme(
          isDark: false,
          primary: const Color(0xFF4BB649),
          secondaryText: const Color(0xFF60708E),
          primaryYellow: const Color(0xffF5C102),
          saleGreen: const Color(0xFF51BA74),
          primaryLight: const Color(0x0d2a9da0),
          black: Colors.black,
          white: Colors.white,
          sameWhite: Colors.white,
          sameBlack: Colors.black,
          textColor: const Color(0xFF193364),
          hintColor: const Color(0xFF7D99BA),
          cardColor: const Color(0xFFF2F7FC),
          errorColor: const Color(0xffFF4343),
          textFieldColor: const Color(0xFFF6F6F8),
          borderColor: const Color(0xFFE8EFF4),
          btnSecondary: const Color(0xFFDBE3F5),
          shimmerBase: const Color(0xFFD8D5D5),
          shimmerHighlight: const Color(0xFFECECEC),
          ratingYellow: const Color(0xFFfdc500),
          splashBg: const Color(0xFF1C6163),
          unSelect: const Color(0xFF807f80),
          orderBg: const Color(0xFFE2F2FD),
          orderIcon: const Color(0xFF2196F3),
          deliveryBg: const Color(0xFFE7F5E9),
          deliveryIcon: const Color(0xFF4EAF52),
          paymentBg: const Color(0xFFFFF4E0),
          paymentIcon: const Color(0xFFFF9800),
          helpBg: const Color(0xFFF4E4F5),
          helpIcon: const Color(0xFF9F2EB2),
          logoutColor: const Color(0xFFF2425A),
          logoutBg: const Color(0xFFFEF0F2),
        );

      case ThemeType.dark:
        return AppTheme(
          isDark: true,
          primary: const Color(0xFF2e6418),
          secondaryText: const Color(0xFF60708E),
          primaryYellow: const Color(0xffF5C102),
          saleGreen: const Color(0xFF51BA74),
          primaryLight: const Color(0x0d2a9da0),
          black: Colors.white,
          white: const Color(0xFF1D1D1A),
          sameWhite: Colors.white,
          sameBlack: Colors.black,
          textColor: const Color(0xffB0B0B0),
          hintColor: const Color(0xFF7D99BA),
          cardColor: const Color(0xFF121212),
          errorColor: const Color(0xffFF4343),
          textFieldColor: const Color(0xFF2B2B2B),
          borderColor: const Color(0xffE8EFF4),
          btnSecondary: const Color(0xFF2E2E2E),
          shimmerBase: const Color(0xFF2B2B2B),
          shimmerHighlight: const Color(0xFF8C8C8C),
          ratingYellow: const Color(0xFFfdc500),
          splashBg: const Color(0xFF1C6163),
          unSelect: const Color(0xFF807f80),
          orderBg: const Color(0xFFE2F2FD),
          orderIcon: const Color(0xFF2196F3),
          deliveryBg: const Color(0xFFE7F5E9),
          deliveryIcon: const Color(0xFF4EAF52),
          paymentBg: const Color(0xFFFFF4E0),
          paymentIcon: const Color(0xFFFF9800),
          helpBg: const Color(0xFFF4E4F5),
          helpIcon: const Color(0xFF9F2EB2),
          logoutColor: const Color(0xFFF2425A),
          logoutBg: const Color(0xFFFEF0F2),
        );
    }
  }

  ThemeData get themeData {
    var t = ThemeData.from(
      textTheme: (isDark ? ThemeData.dark() : ThemeData.light()).textTheme,
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        secondary: primaryYellow,
        surface: white,
        onSurfaceVariant: black,
        onSurface: black,
        shadow: textFieldColor,
        onError: textColor,
        onPrimary: hintColor,
        onSecondary: hintColor,
        error: errorColor,
      ),
    );
    return t.copyWith(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Colors.transparent, cursorColor: primary),
      buttonTheme: ButtonThemeData(buttonColor: primary),
      highlightColor: primary,
    );
  }


  // static Future<ThemeMode> loadTheme() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isDark = prefs.getBool(Prefs.isDark) ?? false;
  //   return isDark ? ThemeMode.dark : ThemeMode.light;
  // }
}
