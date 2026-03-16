import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app_controller.dart';
import 'app_theme.dart';


//---This to switch theme from Switch button----
class ThemeService {
  var appCtrl = Get.isRegistered<AppController>()
      ? Get.find<AppController>()
      : Get.put(AppController());
  final _getStorage = GetStorage();
  final _storageKey = "isDarkMode";
  //-----Store the theme of our app--
  /// Get isDarkMode info from local storage and return ThemeMode
  ThemeMode get themeMode =>
      _loadThemeFromStorage() ? ThemeMode.dark : ThemeMode.light;
  //----If theme mode is equal to dark then we return True----
  //-----isDarkMode--is the field we will use in our switch---
  bool get isDarkMode => themeMode == ThemeMode.dark;

  /// Load isDArkMode from local storage and if it's empty, returns false (that means default theme is light)
  bool _loadThemeFromStorage() => _getStorage.read(_storageKey) ?? false;

  /// Get isDarkMode info from local storage and return AppTheme
  AppTheme get appTheme =>
      _loadThemeFromStorage() ? AppTheme.fromType(ThemeType.dark) : AppTheme.fromType(ThemeType.light);

  switchTheme(loadThemeFromStorage) async {
    if (loadThemeFromStorage) {
      Get.changeThemeMode(ThemeMode.dark);
      await appCtrl.updateTheme(AppTheme.fromType(ThemeType.dark));
      appCtrl.isTheme = true;
      _saveThemeToStorage(true);
      appCtrl.update();

      Get.forceAppUpdate();
    } else {
      Get.changeThemeMode(ThemeMode.light);
      await appCtrl.updateTheme(AppTheme.fromType(ThemeType.light));
      appCtrl.isTheme = false;
      _saveThemeToStorage(false);
      appCtrl.update();
      Get.forceAppUpdate();
    }
    //---notify material app to update UI----
    // notifyListeners();
    appCtrl.update();
  }

  //---implement ToggleTheme function----
  Future<void> toggleTheme(bool isOn) async {

    if(isOn)
      {
        await appCtrl.updateTheme(AppTheme.fromType(ThemeType.dark));
        Get.changeThemeMode(ThemeMode.dark);
        _saveThemeToStorage(true);
        appCtrl.isTheme = true;
        appCtrl.update();

        Get.forceAppUpdate();
      }
    else{
      await appCtrl.updateTheme(AppTheme.fromType(ThemeType.light));
      Get.changeThemeMode(ThemeMode.light);
      _saveThemeToStorage(false);
      appCtrl.isTheme=false;
      appCtrl.update();

      Get.forceAppUpdate();
    }

    appCtrl.update();
    //---notify material app to update UI----
    // notifyListeners();
  }

  _saveThemeToStorage(bool isDarkMode) =>
      _getStorage.write(_storageKey, isDarkMode);

}