import 'dart:developer';

import 'package:get_storage/get_storage.dart';

class Prefs{
  static const String selectedLanguage = "SELECTED_LANGUAGE";
  static const String selectedCountryCode = "SELECTED_COUNTRY_CODE";

  static String userId = "userId";
  static String allowPayLater = "allowPayLater";
  static String authToken = "authToken";
  static String name = "name";
  static String email = "email";
  static String phone = "phone";
  static String id_deliveryboy = "id_deliveryboy";
  static String country = "country";
  static String gender = "gender";
  static String age = "age";
  static String isLoggedIn = "isLoggedIn";
  static String isIntroSeen = "isIntroSeen";
  static String isDark = "isDark";
  static const String LANGUAGE = "LANGUAGE";

  // ------------------ SINGLETON -----------------------
  static final Prefs _preference = Prefs._internal();

  factory Prefs() {
    return _preference;
  }

  Prefs._internal();

  static Prefs get shared => _preference;

  static GetStorage? _pref;

  /* make connection with preference only once in application */
  Future<GetStorage?> instance() async {
    if (_pref != null) return _pref;
    await GetStorage.init().then((value) {
      if (value) {
        _pref = GetStorage();
      }
    }).catchError((onError) {
      _pref = null;
    });
    return _pref;
  }

  String? getString(String key) {
    return _pref!.read(key);
  }

  Future<void> setString(String key, String value) {
    return _pref!.write(key, value);
  }

  bool? getBool(String key) {
    return _pref!.read(key);
  }

  Future<void> setBool(String key, bool value) {
    return _pref!.write(key, value);
  }

  static onSetLanguage(int language) async => await _pref?.write(LANGUAGE, language);

  static int get language {
    final value = _pref?.read(LANGUAGE);
    log("Language: >>>>>$value");
    log("Language: >>>>>int.tryParse(value?.toString() ?? '') ?? 0${int.tryParse(value?.toString() ?? '') ?? 0}");
    // Safely parse to int or return a default value
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  Future<void> clearAll() async {
    await _pref?.erase();
  }

  Future<void> clearUserSession() async {
    await _pref?.remove(Prefs.authToken);
    await _pref?.remove(Prefs.userId);
    await _pref?.remove(Prefs.name);
    await _pref?.remove(Prefs.email);
    await _pref?.remove(Prefs.phone);
    await _pref?.remove(Prefs.isLoggedIn);
    await _pref?.remove(Prefs.allowPayLater);
  }
}