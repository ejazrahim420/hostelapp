import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:hostelfinder/utils/connectivityutil/connectivityutil.dart';
import 'package:hostelfinder/utils/utilmethods/utilmethods.dart';

enum GoogleSignInResult { NoInternent, Succesfully, Error }
enum EmailSignInResult {
  NoInternent,
  Succesfully,
  Error,
  WrongPassword,
  WrongEmail
}

class SignInController extends GetxController {
  final String tag = 'SignInController';
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController tecEmail, tecPassword;
  var obsecurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    print('OnInit $tag');

    tecEmail = TextEditingController();
    tecPassword = TextEditingController();
  }

  void loginInUser() {
    print('${tecPassword.text} ${tecEmail.text}');
  }

  Future<EmailSignInResult> signIn() async {
    if (await ConnectivityUtil.checkConnectionIsAvailable()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: tecEmail.text, password: tecPassword.text);
        return EmailSignInResult.Succesfully;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          return EmailSignInResult.WrongEmail;
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');

          return EmailSignInResult.WrongPassword;
        } else {
          return EmailSignInResult.Error;
        }
      }
    } else {
      return EmailSignInResult.NoInternent;
    }
  }

  Future<void> addUserDetails(UserCredential userCredential) async {
    await UtilMethod.userCollectionRef.doc(userCredential.user.uid).set({
      UtilMethod.USER_NAME_KEY: userCredential.user.displayName,
      UtilMethod.FVRT_PET_KEY: 'cat',
      UtilMethod.NICK_NAME_KEY: 'nickname',
      UtilMethod.IS_GOOGLE_SIGN_IN_KEY: true
    });
  }

  Future<GoogleSignInResult> googleSignIn() async {
    if (await ConnectivityUtil.checkConnectionIsAvailable()) {
      try {
        print('Before googleSignIn');
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        var credeintals =
            await FirebaseAuth.instance.signInWithCredential(credential);
        print('Before add user');
        await addUserDetails(credeintals);
        return GoogleSignInResult.Succesfully;
      } catch (e) {
        return GoogleSignInResult.Error;
      }
    } else {
      return GoogleSignInResult.NoInternent;
    }
  }

  void obsecurePasswordMethod() {
    obsecurePassword.value = !obsecurePassword.value;
  }

  @override
  void onClose() {
    tecEmail.dispose();
    tecPassword.dispose();
    super.onClose();
  }
}
