import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:hostelfinder/modalclasses/searchbytextm.dart';
import 'package:hostelfinder/utils/apiutils/apiutils.dart';
import 'package:hostelfinder/utils/connectivityutil/connectivityutil.dart';
import 'package:hostelfinder/utils/utilmethods/utilmethods.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class HomePageController extends GetxController
    with SingleGetTickerProviderMixin {
  SearchByTextM objSearchByText;
  List<SearchByTextResults> searchByTextDataList = [];
  final tag = 'HomePageController';
  String nextPageToken;
  ScrollController scrollController;
  TextEditingController tecSearchByCountryOrCity;
  Location location = new Location();
  AnimationController animationController;

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  var searchByLocation = false.obs;

  static const HOME_PAGE_LIST_BUILDER_KEY = 'datalist';
  var fetchingNewData = false.obs;
  bool searchTapped = false;
  String countryOrCityName;
  bool isDilogueOpen = false;

  var connectivityListner;

  @override
  void onInit() {
    scrollController = ScrollController()..addListener(scrollControllerListner);
    tecSearchByCountryOrCity = TextEditingController();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    connectivityListner = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      print('In Connectivity Listner');
      //setupLocationSearch();
    });
    super.onInit();
  }

  @override
  void onReady() {
    // setupLocationSearch();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    tecSearchByCountryOrCity.dispose();
    animationController.dispose();
    connectivityListner.cancel();
    super.onClose();
  }

  void getHoestelDataWhencLocationEnableOrNot({String countryOrCity}) async {
    var res;
    // fetchingNewData.value = false;

    try {
      if (countryOrCity != null) {
        searchByLocation.value = false;
        countryOrCityName = countryOrCity;
        res = await http.get(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query=hostel+in+$countryOrCity&key=${ApiUtils.API_KEY}');
      } else if (searchByLocation.value) {
        res = await http.get(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query=hostel&location=${_locationData.latitude},${_locationData.longitude}&radius=10000&key=${ApiUtils.API_KEY}');
      } else {
        res = await http.get(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query=hostel&key=${ApiUtils.API_KEY}');
      }
      if (res.statusCode != 200) throw HttpException('Http Expetion $tag');

      objSearchByText = SearchByTextM.fromJson(jsonDecode(res.body));

      searchByTextDataList = objSearchByText.results;

      //Assign Next Page Token
      nextPageToken = objSearchByText.nextPageToken;
      update([HOME_PAGE_LIST_BUILDER_KEY]);
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

  void scrollControllerListner() {
    var triggerFetchMoreSize = scrollController.position.maxScrollExtent;
    if (scrollController.position.pixels >= triggerFetchMoreSize) {
      if (fetchingNewData.value) {
      } else {
        print('getHoestelPaginationWithoutLocation ***********');
        print(nextPageToken);
        getHoestelPaginationWithoutLocation();
      }
    }
  }

  void getHoestelPaginationWithoutLocation() async {
    fetchingNewData.value = true;
    if (nextPageToken != null) {
      var res;
      try {
        if (countryOrCityName != null) {
          res = await http.get(
              'https://maps.googleapis.com/maps/api/place/textsearch/json?query=hostel+in+$countryOrCityName&pagetoken=$nextPageToken&key=${ApiUtils.API_KEY}');
        } else if (searchByLocation.value) {
          res = await http.get(
              'https://maps.googleapis.com/maps/api/place/textsearch/json?query=hostel&location=${_locationData.latitude},${_locationData.longitude}&radius=10000&pagetoken=$nextPageToken&key=${ApiUtils.API_KEY}');
        } else {
          res = await http.get(
              'https://maps.googleapis.com/maps/api/place/textsearch/json?query=hostel&pagetoken=$nextPageToken&key=${ApiUtils.API_KEY}');
        }

        if (res.statusCode != 200) throw HttpException('Http Expetion $tag');

        objSearchByText = SearchByTextM.fromJson(jsonDecode(res.body));

        searchByTextDataList.addAll(objSearchByText.results);

        //Assign Next Page Token
        nextPageToken = objSearchByText.nextPageToken ?? null;
        update([HOME_PAGE_LIST_BUILDER_KEY]);
      } on SocketException {
        print('SocketException $tag');
      } on HttpException {
        print('HttpException $tag');
      } on FormatException {
        print('FormatException $tag');
      } catch (e) {
        print('Genrealize Expetion $tag ${e.toString()}');
      } finally {
        fetchingNewData.value = false;
      }
    } else {
      print('No More Token');
      fetchingNewData.value = false;
      Get.snackbar('Hostel Locator', 'No More Hostel Founds');
    }
  }

  void onSearchButtonClicked() {
    if (tecSearchByCountryOrCity.text.trim().length > 0) {
      getHoestelDataWhencLocationEnableOrNot(
          countryOrCity: tecSearchByCountryOrCity.text);
    }
  }

  void setupLocationSearch() async {
    if (await ConnectivityUtil.checkConnectionIsAvailable()) {
      if (isDilogueOpen) {
        print('dilogue scene');
        isDilogueOpen = false;
        Get.back();
      }
      print('no dilogue');
      if (searchByLocation.value) {
        searchByLocation.value = false;
        getHoestelDataWhencLocationEnableOrNot();
      } else {
        locationRequestOrGetCurrentLocation().then((value) {
          if (value) {
            searchByLocation.value = true;
          } else {
            searchByLocation.value = false;
            Get.snackbar('Location', 'Location is not enabled');
          }
          getHoestelDataWhencLocationEnableOrNot();
        });
      }

      return;
    }
    print('before return');
    if (!isDilogueOpen) {
      isDilogueOpen = true;
      UtilMethod.showMineDilogue(Get.context);
      return;
    }
  }

  Future<bool> locationRequestOrGetCurrentLocation() async {
    print('locationRequestOrGetCurrentLocation *****************');
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    print('$_permissionGranted      *****************');
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    _locationData = await location.getLocation();
    return true;
  }
}
