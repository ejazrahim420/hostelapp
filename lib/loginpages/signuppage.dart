import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostelfinder/loginpages/logincontrollers/signupcontroller.dart';
import 'package:hostelfinder/loginpages/loginwidgets/googlebutton.dart';

import 'package:hostelfinder/loginpages/loginwidgets/loginbuttons.dart';
import 'package:hostelfinder/loginpages/loginwidgets/logintextfields.dart';
import 'package:hostelfinder/loginpages/signinpage.dart';
import 'package:hostelfinder/modalclasses/signinresultm.dart';

import 'package:hostelfinder/pages/homepage.dart';

import 'package:hostelfinder/utils/colorutils/colorutils.dart';
import 'package:hostelfinder/utils/sizingutil/sizingutil.dart';
import 'package:hostelfinder/utils/utilmethods/utilmethods.dart';

import 'loginwidgets/loginheader.dart';

class SignUpPage extends StatelessWidget {
  static const SIGN_UP_PAGE = '/signup';
  final controller =
      Get.put<SignUpController>(SignUpController(), permanent: false);
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).viewInsets.bottom);
    if (Get.arguments != null) {
      controller.isArgumentsHave = true;
      print('have Argument');
    }

    return Material(
      color: ColorUtils.YELLOW_COLOR,
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top,
            ),
            //Header One Here
            Expanded(
              flex: 20,
              child: LoginHeader(
                isSignUpPage: true,
                titleText: 'Sign Up',
                onBackIconPressed: () => Get.back(),
              ),
            ),
            Expanded(
              flex: 80,
              child: Hero(
                tag: SignInPage.HERO_TAG_TO_SIGN_UP,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(SizingUtil.CARD_BORDER_RADIUS),
                      topLeft: Radius.circular(SizingUtil.CARD_BORDER_RADIUS),
                    ),
                    color: Colors.white,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) => Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          left: 10,
                          right: 10),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: Column(
                            children: [
                              //Header Two Here

                              Expanded(
                                child: Column(
                                  children: [
                                    Spacer(
                                      flex: 10,
                                    ),
                                    //Text Fields Area

                                    LoginTextFields(
                                      hintText: 'Your Name',
                                      tec: controller.tecName,
                                      multiValidator: MultiValidator([
                                        RequiredValidator(
                                            errorText: 'name is required'),
                                      ]),
                                    ),
                                    SizedBox(height: SizingUtil.TEXT_FIELD_GAP),
                                    LoginTextFields(
                                      hintText: 'Your E-mail',
                                      tec: controller.tecEmail,
                                      multiValidator: MultiValidator([
                                        RequiredValidator(
                                            errorText: 'name is required'),
                                        EmailValidator(
                                            errorText:
                                                'enter a valid email address'),
                                      ]),
                                    ),
                                    SizedBox(height: SizingUtil.TEXT_FIELD_GAP),
                                    GetX<SignUpController>(
                                      builder: (controller) => LoginTextFields(
                                        showEye: true,
                                        onEyeTap:
                                            controller.obsecurePasswordMethod,
                                        obsecureText:
                                            controller.obsecurePassword.value,
                                        hintText: 'Password',
                                        tec: controller.tecPassword,
                                        multiValidator: MultiValidator([
                                          RequiredValidator(
                                              errorText:
                                                  'password is required'),
                                          MinLengthValidator(6,
                                              errorText:
                                                  'password must be at least 6 digits long'),
                                        ]),
                                      ),
                                    ),
                                    SizedBox(height: SizingUtil.TEXT_FIELD_GAP),
                                    ValueBuilder<String>(
                                      builder: (value, updateFn) => SizedBox(
                                        height: 65,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                SizingUtil
                                                    .TEXTFIELD_BORDER_RADIUS),
                                          ),
                                          color: ColorUtils.WHITE_COLOR,
                                          shadowColor: ColorUtils.SHADOW_COLOR,
                                          elevation: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 4),
                                            child: GetX<SignUpController>(
                                              builder: (controller) => Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      obscureText: controller
                                                          .obsecureConfirmPassword
                                                          .value,
                                                      onChanged: updateFn,
                                                      validator: (val) =>
                                                          MatchValidator(
                                                                  errorText:
                                                                      'passwords do not match')
                                                              .validateMatch(
                                                                  val,
                                                                  controller
                                                                      .tecPassword
                                                                      .text),
                                                      cursorColor: ColorUtils
                                                          .YELLOW_COLOR,
                                                      style: GoogleFonts
                                                          .sourceSansPro(
                                                              color: ColorUtils
                                                                  .HEADING_BLACK,
                                                              fontSize: 18),
                                                      controller: controller
                                                          .tecConfirmPassword,
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              'Confirm Password',
                                                          hintStyle: GoogleFonts
                                                              .sourceSansPro(
                                                                  color: ColorUtils
                                                                      .HEADING_GREY,
                                                                  fontSize: 18),
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 8),
                                                          border:
                                                              InputBorder.none),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: GestureDetector(
                                                        onTap: controller
                                                            .obsecureConfirmPasswordMethod,
                                                        child: controller
                                                                .obsecureConfirmPassword
                                                                .value
                                                            ? Icon(Icons
                                                                .remove_red_eye)
                                                            : Icon(
                                                                Icons
                                                                    .remove_red_eye,
                                                                color: ColorUtils
                                                                    .YELLOW_COLOR,
                                                              )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // if you need to call something outside the builder method.
                                      onUpdate: (value) =>
                                          print("Value updated: $value"),
                                    ),
                                    Spacer(
                                      flex: 8,
                                    ),

                                    //Button Foooters
                                    Expanded(
                                      flex: 68,
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 45,
                                              child: LayoutBuilder(
                                                builder:
                                                    (context, constraints) =>
                                                        LoginButtons(
                                                  constraints: constraints,
                                                  backgroundColor:
                                                      ColorUtils.YELLOW_COLOR,
                                                  buttonPressed: () async {
                                                    // if (FirebaseAuth.instance
                                                    //         .currentUser !=
                                                    //     null) {
                                                    //   FirebaseAuth.instance
                                                    //       .signOut();
                                                    // }
                                                    // onLoginButtonPressed(
                                                    //     context);
                                                    if (controller
                                                        .isArgumentsHave) {
                                                      onLoginButtonPressed(
                                                          context, true);
                                                      print(
                                                          'arguments not null ********');
                                                    } else {
                                                      onLoginButtonPressed(
                                                          context, false);
                                                    }
                                                  },
                                                  text: 'Register',
                                                  textColor:
                                                      ColorUtils.WHITE_COLOR,
                                                ),
                                              ),
                                            ),
                                            Spacer(
                                              flex: 10,
                                            ),
                                            Expanded(
                                              flex: 45,
                                              child: LayoutBuilder(
                                                builder:
                                                    (context, constraints) =>
                                                        GoogleButton(
                                                  constraints: constraints,
                                                  onGoogleButtonPressed: () =>
                                                      onGoogleButtonPressed(
                                                          context),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),

                                    Spacer(
                                      flex: 15,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
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

  void onGoogleButtonPressed(BuildContext context) async {
    var status = await controller.googleSignIn();
    switch (status) {
      case AccountStatus.Succesfully:
        print('succesfully');
        Get.offAllNamed(HostelLocatorHomePage.HOSTE_LOCATOR_HOME_PAGE);
        break;
      case AccountStatus.NoIntenret:
        UtilMethod.showMineDilogue(context);
        break;
      case AccountStatus.Error:
        Get.snackbar(
          'Sign Up',
          'Some Error!',
        );
        break;
      default:
        print('undefined Sign Up Error');
    }
  }

  void onLoginButtonPressed(BuildContext context,
      [bool isArgument = false]) async {
    if (controller.formKey.currentState.validate()) {
      Get.dialog(CupertinoActivityIndicator(), barrierDismissible: false);
      print('validate');
      var status = await controller.createAccount();
      switch (status) {
        case AccountCreateStatus.Succesfully:
          print('succesfully');

          await FirebaseAuth.instance.signOut();
          Get.back();
          await Future.delayed(Duration(milliseconds: 100));

          if (isArgument) {
            print('after splashe route');
            Get.offNamed(SignInPage.SIGN_IN_PAGE,
                arguments: SignInResultModal(
                    userEmail: controller.tecEmail.text,
                    userPassword: controller.tecPassword.text));
            break;
          } else {
            print('in else ***************');
            Get.back<SignInResultModal>(
                result: SignInResultModal(
                    userEmail: controller.tecEmail.text,
                    userPassword: controller.tecPassword.text));
          }
          print('excecutning**************');
          break;
        case AccountCreateStatus.NoIntenret:
          Get.back();
          UtilMethod.showMineDilogue(context);
          break;
        case AccountCreateStatus.Error:
          Get.back();
          Get.snackbar(
            'Sign Up',
            'Some Error!',
          );
          break;
        case AccountCreateStatus.EmailExists:
          Get.back();
          Get.snackbar('Sign', 'Already Exists!',
              messageText: Text(
                'try to sign up with different email',
                style: TextStyle(color: Colors.redAccent.shade400),
              ));
          break;
        case AccountCreateStatus.WeakPassword:
          Get.back();
          Get.snackbar('Sign', 'weak password',
              messageText: Text(
                'kindly give strong password',
                style: TextStyle(color: Colors.redAccent.shade400),
              ));
          break;
        default:
          Get.back();
          print('undefined Sign In Error');
          break;
      }
    }
  }
}
