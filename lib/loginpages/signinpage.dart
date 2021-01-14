import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hostelfinder/loginpages/logincontrollers/signincontroller.dart';
import 'package:hostelfinder/loginpages/loginwidgets/googlebutton.dart';
import 'package:hostelfinder/loginpages/loginwidgets/loginbuttons.dart';
import 'package:hostelfinder/loginpages/loginwidgets/loginheader.dart';

import 'package:hostelfinder/loginpages/loginwidgets/logintextfields.dart';
import 'package:hostelfinder/loginpages/signuppage.dart';
import 'package:hostelfinder/modalclasses/signinresultm.dart';

import 'package:hostelfinder/pages/homepage.dart';

import 'package:hostelfinder/utils/colorutils/colorutils.dart';
import 'package:hostelfinder/utils/sizingutil/sizingutil.dart';
import 'package:hostelfinder/utils/utilmethods/utilmethods.dart';

class SignInPage extends StatelessWidget {
  static const SIGN_IN_PAGE = '/signin';
  static const HERO_TAG_TO_SIGN_UP = 'herosign';

  final controller = Get.put<SignInController>(SignInController());

  SignInPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null && Get.arguments is SignInResultModal) {
      SignInResultModal result = Get.arguments as SignInResultModal;
      controller.tecEmail.text = result.userEmail;
      controller.tecPassword.text = result.userPassword;
      print('Arguments not null sign ************');
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
              flex: 25,
              child: LoginHeader(
                onBackIconPressed: () => Get.back(),
                titleText: 'Sign In',
                onRegisterPressed: () async {
                  var result = await Get.toNamed(SignUpPage.SIGN_UP_PAGE);
                  if (result != null) {
                    controller.tecEmail.text = result.userEmail;
                    controller.tecPassword.text = result.userPassword;
                  }
                },
                isSignUpPage: false,
              ),
            ),
            Expanded(
              flex: 65,
              child: Hero(
                tag: HERO_TAG_TO_SIGN_UP,
                child: Container(
                  decoration: BoxDecoration(
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
                              Spacer(
                                flex: 10,
                              ),
                              //Text Fields Area
                              LoginTextFields(
                                hintText: 'Your E-mail',
                                tec: controller.tecEmail,
                                multiValidator: MultiValidator([
                                  RequiredValidator(
                                      errorText: 'email is required'),
                                  EmailValidator(
                                      errorText: 'enter a valid email address'),
                                ]),
                              ),
                              SizedBox(height: SizingUtil.TEXT_FIELD_GAP),
                              GetX<SignInController>(
                                builder: (controller) => LoginTextFields(
                                  showEye: true,
                                  onEyeTap: controller.obsecurePasswordMethod,
                                  obsecureText:
                                      controller.obsecurePassword.value,
                                  hintText: 'Password',
                                  tec: controller.tecPassword,
                                  multiValidator: MultiValidator([
                                    RequiredValidator(
                                        errorText: 'password is required'),
                                    MinLengthValidator(6,
                                        errorText:
                                            'password must be at least 6 digits long'),
                                  ]),
                                ),
                              ),

                              //Forgot Password Area
                              Expanded(
                                flex: 30,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Forgot your password ?',
                                    style: GoogleFonts.sourceSansPro(
                                        color: ColorUtils.HEADING_GREY,
                                        fontSize: 18,
                                        decoration: TextDecoration.none),
                                  ),
                                ),
                              ),

                              //Button Foooters
                              Expanded(
                                flex: 45,
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 45,
                                        child: LayoutBuilder(
                                          builder: (context, constraints) =>
                                              LoginButtons(
                                            constraints: constraints,
                                            backgroundColor:
                                                ColorUtils.YELLOW_COLOR,
                                            buttonPressed: () async {
                                              if (controller
                                                  .formKey.currentState
                                                  .validate()) {
                                                onLoginPressed(context);
                                              }
                                            },
                                            text: 'Login',
                                            textColor: ColorUtils.WHITE_COLOR,
                                          ),
                                        ),
                                      ),
                                      Spacer(
                                        flex: 10,
                                      ),
                                      Expanded(
                                        flex: 45,
                                        child: LayoutBuilder(
                                          builder: (context, constraints) =>
                                              GoogleButton(
                                                  constraints: constraints,
                                                  onGoogleButtonPressed: () =>
                                                      onGoogleLogin(context)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Spacer(
                                flex: 15,
                              ),
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

  void onGoogleLogin(BuildContext context) async {
    Get.dialog(CupertinoActivityIndicator(), barrierDismissible: false);
    var status = await controller.googleSignIn();
    switch (status) {
      case GoogleSignInResult.Succesfully:
        print('succesfully');
        Get.back();
        Get.offAllNamed(HostelLocatorHomePage.HOSTE_LOCATOR_HOME_PAGE);
        break;
      case GoogleSignInResult.NoInternent:
        Get.back();
        UtilMethod.showMineDilogue(context);
        break;
      case GoogleSignInResult.Error:
        Get.back();
        Get.snackbar(
          'Sign In ',
          'Some Error!',
        );
        break;
      default:
        Get.back();
        print('undefined Sign In Error');
    }
  }

  void onLoginPressed(BuildContext context) async {
    if (controller.formKey.currentState.validate()) {
      Get.dialog(CupertinoActivityIndicator(), barrierDismissible: false);
      var status = await controller.signIn();
      switch (status) {
        case EmailSignInResult.Succesfully:
          print('succesfully');
          Get.back();
          Get.offAllNamed(HostelLocatorHomePage.HOSTE_LOCATOR_HOME_PAGE);
          break;
        case EmailSignInResult.NoInternent:
          Get.back();
          UtilMethod.showMineDilogue(context);
          break;
        case EmailSignInResult.Error:
          Get.back();
          Get.snackbar(
            'Sign In ',
            'Some Error!',
          );
          break;
        case EmailSignInResult.WrongEmail:
          Get.back();
          Get.snackbar('Sign In', 'user not found',
              messageText: Text(
                'no user found for that email',
                style: TextStyle(color: Colors.redAccent),
              ));
          break;
        case EmailSignInResult.WrongPassword:
          Get.back();
          Get.snackbar('Sign In', 'wrong password',
              messageText: Text(
                'wrong password provided for that user.',
                style: TextStyle(color: Colors.redAccent),
              ));
          break;
        default:
          Get.back();
          print('undefined Sign In Error');
      }
    }
  }
}
