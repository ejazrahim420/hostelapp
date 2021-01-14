import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:hostelfinder/utils/colorutils/colorutils.dart';

import 'package:lottie/lottie.dart';

abstract class UtilMethod {
  static const USER_NAME_KEY = 'username';
  static const FVRT_PET_KEY = 'favouritetpet';
  static const NICK_NAME_KEY = 'nickname';
  static const IS_GOOGLE_SIGN_IN_KEY = 'isgoogle';
  static final userCollectionRef =
      FirebaseFirestore.instance.collection('users');

  static void showMineDilogue(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 500));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UnconstrainedBox(
        child: Container(
          width: Get.width * 0.75,
          height: Get.height * 0.3,
          decoration: BoxDecoration(
            color: ColorUtils.LITE_WHITE_COLOR,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Lottie.asset('assets/nointernet.json'),
        ),
      ),
    );
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
