import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hostelfinder/loginpages/signinpage.dart';
import 'package:hostelfinder/loginpages/signuppage.dart';

import 'package:hostelfinder/pages/homepage.dart';
import 'package:hostelfinder/pages/splashpage/aftersplashpage.dart';

import 'package:hostelfinder/utils/colorutils/colorutils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      transitionDuration: const Duration(milliseconds: 900),
      getPages: [
        GetPage(
          name: SignInPage.SIGN_IN_PAGE,
          page: () => SignInPage(),
        ),
        GetPage(
          name: SignUpPage.SIGN_UP_PAGE,
          page: () => SignUpPage(),
        ),
        GetPage(
          name: AfterSplashPage.AFTER_SPLASH_PAGE,
          page: () => AfterSplashPage(),
        ),
        GetPage(
          name: HostelLocatorHomePage.HOSTE_LOCATOR_HOME_PAGE,
          page: () => HostelLocatorHomePage(),
        ),
      ],
      title: 'Hostel Locator',
      theme: ThemeData(primaryColor: ColorUtils.YELLOW_COLOR),
      home: HostelLocatorHomePage(),
    );
  }
}
