import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme/app_theme.dart';
import '../utils/prefs.dart';

class AppController extends GetxController{
  AppTheme _appTheme = AppTheme.fromType(ThemeType.light);

  AppTheme get appTheme => _appTheme;

  String priceSymbol = "\$";
  String mapApiKey = "AIzaSyAGeDjDX9-zYsH_VbEsAZ64qrd0VkF4eq4";
  String? authToken;
  bool isTheme = false;
  final storage = GetStorage();


  //update theme
  updateTheme(theme) {
    _appTheme = theme;
    Get.forceAppUpdate();
  }



}