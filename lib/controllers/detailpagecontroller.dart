import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostelfinder/modalclasses/placedetail.dart';
import 'package:hostelfinder/utils/apiutils/apiutils.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class DetailPageController extends GetxController
    with SingleGetTickerProviderMixin {
  DetailPageController(this.placeID);
  final String placeID;
  final tag = 'DetailPageController';
  ResultOfDetailM resultOfDetailM;
  PlaceDetailM placeDetailM;
  var phoneNo = ''.obs;
  AnimationController animationController;

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData locationData;
  Location location = new Location();

  @override
  void onInit() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    getPlaceDetail();
    super.onInit();
  }

  @override
  void onClose() {
    animationController.dispose();

    super.onClose();
  }

  void getPlaceDetail() async {
    var res;
    // fetchingNewData.value = false;

    try {
      res = await http.get(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&fields=name,rating,review,formatted_phone_number&key=${ApiUtils.API_KEY}');

      if (res.statusCode != 200) throw HttpException('Http Expetion $tag');

      placeDetailM = PlaceDetailM.fromJson(jsonDecode(res.body));

      resultOfDetailM = placeDetailM.result;
      phoneNo.value = resultOfDetailM.formattedPhoneNumber;

      //Assign Next Page Token

      update();
    } on SocketException {
      print('SocketException $tag');
    } on HttpException {
      print('HttpException $tag');
    } on FormatException {
      print('FormatException $tag');
    } catch (e) {
      print('Genrealize Expetion $tag ${e.toString()}');
    }
  }

  Future<bool> locationRequestOrGetCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    locationData = await location.getLocation();
    return true;
  }
}
