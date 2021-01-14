import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hostelfinder/loginpages/signinpage.dart';
import 'package:hostelfinder/loginpages/signuppage.dart';

import 'package:hostelfinder/utils/colorutils/colorutils.dart';
import 'package:hostelfinder/utils/sizingutil/sizingutil.dart';

class AfterSplashPage extends StatelessWidget {
  static const AFTER_SPLASH_PAGE = '/aftersplash';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              flex: 55,
              child: Center(
                child: SizedBox(
                  child: Image.asset(
                    'assets/hostelfinallogo.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 45,
              child: Hero(
                tag: SignInPage.HERO_TAG_TO_SIGN_UP,
                child: LayoutBuilder(
                  builder: (context, constraints) => Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight:
                            Radius.circular(SizingUtil.CARD_BORDER_RADIUS),
                        topLeft: Radius.circular(SizingUtil.CARD_BORDER_RADIUS),
                      ),
                      color: ColorUtils.YELLOW_COLOR,
                    ),
                    child: SizedBox(
                      width: constraints.maxWidth * 0.9,
                      height: constraints.maxHeight * 0.75,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 20,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  'Welcome',
                                  style: GoogleFonts.sourceSansPro(
                                      fontWeight: FontWeight.bold,
                                      color: ColorUtils.BLACK_COLOR,
                                      fontSize: 26,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                            ),
                          ),
                          Spacer(
                            flex: 5,
                          ),

                          //Despction Area
                          Expanded(
                            flex: 35,
                            child: Text(
                              'The Best Hostel Finder App For Students.It Help to find hostel also provide reviwes and other detail Information',
                              style: GoogleFonts.sourceSansPro(
                                  fontWeight: FontWeight.bold,
                                  color: ColorUtils.BLACK_COLOR,
                                  fontSize: 16,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                          Spacer(
                            flex: 10,
                          ),
                          //Buttons Area
                          Expanded(
                            flex: 30,
                            child: LayoutBuilder(
                              builder: (context, constraints) => SizedBox(
                                width: constraints.maxWidth,
                                height: constraints.maxHeight,
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      MaterialButton(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              SizingUtil.BUTTON_BORDER_RADIUS),
                                        ),
                                        color: ColorUtils.BLACK_COLOR,
                                        minWidth: constraints.maxWidth * 0.4,
                                        height: constraints.maxHeight * 0.9,
                                        onPressed: () {
                                          //Goto SIGN_IN_PAGE Page
                                          Get.toNamed(SignInPage.SIGN_IN_PAGE);
                                        },
                                        child: Text('Sign In',
                                            style: GoogleFonts.openSans(
                                                color: ColorUtils.WHITE_COLOR,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.none)),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      MaterialButton(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              SizingUtil.BUTTON_BORDER_RADIUS),
                                        ),
                                        color: ColorUtils.WHITE_COLOR,
                                        minWidth: constraints.maxWidth * 0.4,
                                        height: constraints.maxHeight * 0.9,
                                        onPressed: () {
                                          //Goto SignUp Page
                                          Get.toNamed(SignUpPage.SIGN_UP_PAGE,
                                              arguments: true);
                                        },
                                        child: Text('Sign Up',
                                            style: GoogleFonts.openSans(
                                                color: ColorUtils.BLACK_COLOR,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.none)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
