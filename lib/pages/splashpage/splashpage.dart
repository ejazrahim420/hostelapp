import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hostelfinder/custompaintermine/splashcustompaint.dart';
import 'package:hostelfinder/pages/homepage.dart';
import 'package:hostelfinder/pages/splashpage/aftersplashpage.dart';
import 'package:hostelfinder/utils/colorutils/colorutils.dart';

class SplashPage extends StatelessWidget {
  static const SPLASH_PAGE_ROUTE = '/splash';
  @override
  Widget build(BuildContext context) {
    moveToNextAfterDelay(context);
    return SafeArea(
      child: Material(
        color: ColorUtils.WHITE_COLOR,
        child: CustomPaint(
          painter: SplashCustomPaint(),
          child: Center(
            child: SizedBox(
              child: Image.asset(
                'assets/hostelfinallogo.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void moveToNextAfterDelay(BuildContext context) async {
    String goToPage = AfterSplashPage.AFTER_SPLASH_PAGE;
    if (FirebaseAuth.instance.currentUser != null) {
      goToPage = HostelLocatorHomePage.HOSTE_LOCATOR_HOME_PAGE;
    }
    await Future.delayed(const Duration(milliseconds: 1500));
    Get.offAndToNamed(goToPage);
  }
}
