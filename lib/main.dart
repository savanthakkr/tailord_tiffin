import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/screens/splash_screen.dart';
import 'package:tailoredtiffin/utils/firebase_service.dart';
import 'package:tailoredtiffin/utils/prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  /// Initialize Shared Preference
  await Prefs().instance();

  if(Platform.isAndroid){
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyA_dZOTQ2-uSMELsSolwOGuQqRU0J_G65k",
            authDomain: "tailordtiffin.firebaseapp.com",
            projectId: "tailordtiffin",
            storageBucket: "tailordtiffin.firebasestorage.app",
            messagingSenderId: "608771285346",
            appId: "1:608771285346:web:b43ce7ed8f49e6c3bb4c3b",
            measurementId: "G-DTB3G69FR7"
        )
    );
  } else {
    await Firebase.initializeApp();
  }

  await FirebaseServices.initializeFirebase();

  final RemoteMessage? _message = await FirebaseServices.firebaseMessaging.getInitialMessage();
  if(_message != null) {
    // saveNotification(_message);
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  String userId = "";

  if(message.data['userId'] == null){
    userId = "";
  } else {
    userId = message.data['userId'];
  }
  // InsertReportData(message.notification!.title!, message.notification!.body!,userId);
  // NotificationManager notificationManager = NotificationManager();
  // notificationManager.showNotificationWithNoBody(message);

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    lockScreenPortrait();
    lockStatusBarColor();

    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          child: const GetMaterialApp(
            // themeMode: ThemeService().themeMode,
            // theme: AppTheme.fromType(ThemeType.light).themeData,
            // darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
            // fallbackLocale: const Locale(Constants.languageEn, Constants.countryCodeEn),
            defaultTransition: Transition.fadeIn,
            home: SplashScreen(),
            title: 'Tailored Tiffin',
            // getPages: appRoute.getPages,
            debugShowCheckedModeBanner: false,
            supportedLocales: [
              Locale("en"), /// THIS IS FOR COUNTRY CODE PICKER
            ],
            localizationsDelegates: [
              CountryLocalizations.delegate, /// THIS IS FOR COUNTRY CODE PICKER
            ],
          ),
          builder: (context, widget) {
            ScreenUtil.init(context);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
              child: widget!,
            );
          },
        );
      },
    );
  }

  lockScreenPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void lockStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light
    ));
  }
}

