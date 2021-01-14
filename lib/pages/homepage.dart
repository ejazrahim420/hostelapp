import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hostelfinder/controllers/homepagecontroller.dart';
import 'package:hostelfinder/modalclasses/searchbytextm.dart';
import 'package:hostelfinder/pages/detailpage.dart';
import 'package:hostelfinder/pages/splashpage/aftersplashpage.dart';
import 'package:hostelfinder/utils/apiutils/apiutils.dart';

import 'package:hostelfinder/utils/colorutils/colorutils.dart';

import 'package:hostelfinder/widgets/searchfieldwidget.dart';
import 'package:transparent_image/transparent_image.dart';

class HostelLocatorHomePage extends StatelessWidget {
  static const HOSTE_LOCATOR_HOME_PAGE = '/homelocator';
  //Get.put();
  final HomePageController homePageController =
      Get.put<HomePageController>(HomePageController());

  // Location location = new Location();
  // bool _serviceEnabled;
  // PermissionStatus _permissionGranted;
  // LocationData _locationData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          color: ColorUtils.DARK_BLUE_COLOR,
          child: LayoutBuilder(
            builder: (context, constraints) => Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: constraints.maxWidth,
                  height: 70,
                  child: GestureDetector(
                    onTap: () async {
                      GoogleSignIn _googleSignIn = GoogleSignIn();
                      await _googleSignIn.signOut();
                      await FirebaseAuth.instance.signOut();
                      Get.offAllNamed(AfterSplashPage.AFTER_SPLASH_PAGE);
                    },
                    child: Container(
                      color: ColorUtils.YELLOW_COLOR,
                      padding: const EdgeInsets.only(right: 15),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Logout',
                          style: GoogleFonts.sourceSansPro(
                              fontWeight: FontWeight.bold,
                              color: ColorUtils.BLACK_COLOR,
                              fontSize: 18,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: ColorUtils.LITE_WHITE_COLOR,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorUtils.WHITE_COLOR,
        centerTitle: true,
        title: Text(
          'Explore',
          style: GoogleFonts.sourceSansPro(
              fontWeight: FontWeight.bold,
              color: ColorUtils.BLACK_COLOR,
              fontSize: 26,
              decoration: TextDecoration.none),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 110,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SearchTextFields(
                        hintText: 'Search..',
                        tec: homePageController.tecSearchByCountryOrCity,
                        onCrossIconTap: () {
                          homePageController.tecSearchByCountryOrCity.clear();
                        },
                      ),
                    ),
                    CircleAvatar(
                      minRadius: 22,
                      backgroundColor: ColorUtils.YELLOW_COLOR,
                      child: GestureDetector(
                        onTap: () {
                          homePageController.onSearchButtonClicked();
                        },
                        child: Icon(
                          Icons.search_sharp,
                          color: ColorUtils.WHITE_COLOR,
                          size: 28,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'By your location',
                        style: GoogleFonts.sourceSansPro(
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.BLACK_COLOR,
                            fontSize: 16,
                            decoration: TextDecoration.none),
                      ),
                      GetX<HomePageController>(
                        builder: (controller) => IconButton(
                          icon: controller.searchByLocation.value
                              ? const Icon(
                                  Icons.location_on,
                                  color: ColorUtils.GREEN_COLOR,
                                )
                              : const Icon(
                                  Icons.location_off,
                                  color: ColorUtils.BLACK_COLOR,
                                ),
                          onPressed: () async {
                            homePageController.setupLocationSearch();
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                //List View Main
                GetBuilder<HomePageController>(
                  id: HomePageController.HOME_PAGE_LIST_BUILDER_KEY,
                  builder: (controller) => MainListViewHomePage(
                    obj: controller.searchByTextDataList,
                  ),
                ),
                //CircularProgressIndicator(),
                // Search Indicator

                GetX<HomePageController>(
                  builder: (controller) {
                    print(
                        'inside ********  ${controller.fetchingNewData.value}');
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 400),
                      top: controller.fetchingNewData.value ? 50 : -50,
                      right: 0,
                      left: 0,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: ColorTween(
                                  begin: ColorUtils.DARK_BLUE_COLOR,
                                  end: ColorUtils.GOLDEN_COLOR)
                              .animate(homePageController.animationController),
                          strokeWidth: 5,
                          backgroundColor: ColorUtils.YELLOW_COLOR,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MainListViewHomePage extends StatelessWidget {
  const MainListViewHomePage({Key key, this.obj}) : super(key: key);
  final List<SearchByTextResults> obj;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        width: Get.width * 0.95,
        child: obj.isNotEmpty
            ? ListView.builder(
                controller: Get.find<HomePageController>().scrollController,
                itemExtent: 190,
                itemCount: obj.length ?? 0,
                itemBuilder: (context, index) {
                  //  print(obj[index]?.photos?.length ?? obj[index].name);
                  // https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${obj[index].photos[index].photoReference}&key=${ApiUtils.API_KEY}
                  return RowTile(
                    obj: obj[index],
                    constraints: constraints,
                    onRowTap: () {
                      Get.find<HomePageController>()
                          .tecSearchByCountryOrCity
                          .clear();
                      FocusScope.of(context).unfocus();
                      Get.to(DetailPage(
                        searchByTextM: obj[index],
                      ));
                    },
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: ColorTween(
                          begin: ColorUtils.DARK_BLUE_COLOR,
                          end: ColorUtils.LITE_WHITE_COLOR)
                      .animate(
                          Get.find<HomePageController>().animationController),
                  strokeWidth: 8,
                  backgroundColor: ColorUtils.YELLOW_COLOR,
                ),
              ),
      ),
    );
  }
}

class RowTile extends StatelessWidget {
  const RowTile({Key key, @required this.obj, this.constraints, this.onRowTap})
      : super(key: key);

  final SearchByTextResults obj;
  final BoxConstraints constraints;
  final VoidCallback onRowTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: onRowTap,
        child: Stack(
          children: [
            SizedBox(
              height: 170,
              width: constraints.maxWidth,
              child: Card(
                color: ColorUtils.YELLOW_COLOR,
                elevation: 4,
                shadowColor: ColorUtils.SHADOW_COLOR,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
            ),
            Positioned.fill(
              right: 12,
              child: Card(
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                color: ColorUtils.WHITE_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 40,
                      child: LayoutBuilder(
                        builder: (context, constraints) =>
                            obj.photos?.length != null
                                ? FadeInImage.memoryNetwork(
                                    fadeInCurve: Curves.easeIn,
                                    fadeInDuration:
                                        const Duration(milliseconds: 400),
                                    placeholder: kTransparentImage,
                                    image:
                                        'https://maps.googleapis.com/maps/api/place/photo?maxwidth=300&photoreference=${obj.photos[0].photoReference}&key=${ApiUtils.API_KEY}',
                                    fit: BoxFit.fill,
                                    height: constraints.maxHeight,
                                    width: constraints.minWidth,
                                    imageErrorBuilder: (_, p, y) =>
                                        Image.memory(kTransparentImage),
                                  )
                                : Text(
                                    'image not available for this hostel',
                                    style: GoogleFonts.sourceSansPro(
                                        fontWeight: FontWeight.w500,
                                        color: ColorUtils.BLACK_COLOR,
                                        fontSize: 15,
                                        decoration: TextDecoration.none),
                                  ),
                      ),
                    ),
                    Expanded(
                      flex: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${obj.name ?? ''}',
                              style: GoogleFonts.sourceSansPro(
                                  fontWeight: FontWeight.w500,
                                  color: ColorUtils.BLACK_COLOR,
                                  fontSize: 16,
                                  decoration: TextDecoration.none),
                            ),
                            SizedBox(
                              width: 60,
                              child: Card(
                                color: ColorUtils.WHITE_COLOR,
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${obj.rating ?? ''}',
                                        style: GoogleFonts.sourceSansPro(
                                            fontWeight: FontWeight.w500,
                                            color: ColorUtils.BLACK_COLOR,
                                            fontSize: 14,
                                            decoration: TextDecoration.none),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 18,
                                        color: obj.rating >= 4
                                            ? ColorUtils.GREEN_COLOR
                                            : obj.rating >= 3
                                                ? ColorUtils.YELLOW_COLOR
                                                : ColorUtils.RED_COLOR,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              color: ColorUtils.HEADING_BLACK,
                            ),
                            Expanded(
                              child: Text(
                                '${obj?.formattedAddress ?? ''}',
                                maxLines: 8,
                                style: GoogleFonts.sourceSansPro(
                                    fontWeight: FontWeight.w500,
                                    color: ColorUtils.HEADING_BLACK,
                                    fontSize: 12,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// child: MaterialButton(
//   child: Text('Log Out'),
//   onPressed: () async {
//     GoogleSignIn _googleSignIn = GoogleSignIn();
//     await _googleSignIn.signOut();
//     await FirebaseAuth.instance.signOut();
//     Get.offAllNamed(AfterSplashPage.AFTER_SPLASH_PAGE);
//   },
// ),
