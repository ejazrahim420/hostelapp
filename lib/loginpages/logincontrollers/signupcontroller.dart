import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hostelfinder/utils/connectivityutil/connectivityutil.dart';
import 'package:hostelfinder/utils/utilmethods/utilmethods.dart';

enum AccountStatus { NoIntenret, Error, Succesfully }
enum AccountCreateStatus {
  NoIntenret,
  Error,
  Succesfully,
  EmailExists,
  WeakPassword
}

class SignUpController extends GetxController {
  final String tag = 'SignUpController';
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController tecName, tecEmail, tecPassword, tecConfirmPassword;
  static const UPATE_CONFIRM_KEY = 'confirm';
  var obsecurePassword = true.obs;
  var obsecureConfirmPassword = true.obs;
  bool isArgumentsHave = false;

  @override
  void onInit() {
    tecName = TextEditingController();
    tecEmail = TextEditingController();
    tecPassword = TextEditingController();
    tecConfirmPassword = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    tecName.dispose();
    tecEmail.dispose();
    tecPassword.dispose();
    tecConfirmPassword.dispose();
    super.onClose();
  }

  void obsecurePasswordMethod() {
    obsecurePassword.value = !obsecurePassword.value;
  }

  void obsecureConfirmPasswordMethod() {
    obsecureConfirmPassword.value = !obsecureConfirmPassword.value;
  }

  Future<AccountCreateStatus> createAccount() async {
    if (await ConnectivityUtil.checkConnectionIsAvailable()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: tecEmail.text, password: tecPassword.text);
        await addUserDetails(userCredential);

        return AccountCreateStatus.Succesfully;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          return AccountCreateStatus.WeakPassword;
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');

          return AccountCreateStatus.EmailExists;
        } else {
          return AccountCreateStatus.Error;
        }
      } catch (e) {
        print(e);
        return AccountCreateStatus.Error;
      }
    } else {
      print('No Connection');
      return AccountCreateStatus.NoIntenret;
    }
  }

  Future<void> addUserDetails(UserCredential userCredential,
      [bool googleSignIn = false]) async {
    await UtilMethod.userCollectionRef.doc(userCredential.user.uid).set({
      UtilMethod.USER_NAME_KEY:
          googleSignIn ? userCredential.user.displayName : tecName.text,
      UtilMethod.FVRT_PET_KEY: 'cat',
      UtilMethod.NICK_NAME_KEY: 'nickname',
      UtilMethod.IS_GOOGLE_SIGN_IN_KEY: googleSignIn
    });
  }

  Future<AccountStatus> googleSignIn() async {
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
        await addUserDetails(credeintals, true);
        return AccountStatus.Succesfully;
      } catch (e) {
        return AccountStatus.Error;
      }
    } else {
      return AccountStatus.NoIntenret;
    }
  }
}
