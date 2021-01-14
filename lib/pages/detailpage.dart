import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hostelfinder/controllers/detailpagecontroller.dart';
import 'package:hostelfinder/modalclasses/genrateroutem.dart';
import 'package:hostelfinder/modalclasses/placedetail.dart';
import 'package:hostelfinder/modalclasses/searchbytextm.dart';
import 'package:hostelfinder/pages/generateroutepage.dart';
import 'package:hostelfinder/utils/apiutils/apiutils.dart';
import 'package:hostelfinder/utils/colorutils/colorutils.dart';
import 'package:lottie/lottie.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key key, this.searchByTextM}) : super(key: key);
  final SearchByTextResults searchByTextM;

  @override
  Widget build(BuildContext context) {
    Get.put(DetailPageController(searchByTextM.placeId));
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: onGereateRoutePressed,
          backgroundColor: ColorUtils.DARK_BLUE_COLOR,
          icon: ImageIcon(AssetImage('assets/routes.png')),
          isExtended: true,
          label: Text(
            'Route',
            style: GoogleFonts.sourceSansPro(
                fontWeight: FontWeight.w400,
                color: ColorUtils.WHITE_COLOR,
                fontSize: 14,
                decoration: TextDecoration.none),
          ),
        ),
        body: SafeArea(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                flexibleSpace: FlexibleSpaceBar(
                  background: LayoutBuilder(
                    builder: (context, constraints) =>
                        searchByTextM.photos?.length != null
                            ? FadeInImage.memoryNetwork(
                                fadeInCurve: Curves.easeIn,
                                fadeInDuration:
                                    const Duration(milliseconds: 400),
                                placeholder: kTransparentImage,
                                image:
                                    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=300&photoreference=${searchByTextM.photos[0].photoReference}&key=${ApiUtils.API_KEY}',
                                fit: BoxFit.fill,
                                height: constraints.maxHeight,
                                width: constraints.minWidth,
                                imageErrorBuilder: (_, p, y) =>
                                    Image.memory(kTransparentImage),
                              )
                            : Center(
                                child: Text(
                                  'image not available for this hostel',
                                  style: GoogleFonts.sourceSansPro(
                                      fontWeight: FontWeight.w500,
                                      color: ColorUtils.BLACK_COLOR,
                                      fontSize: 15,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                  ),
                  collapseMode: CollapseMode.parallax,
                  stretchModes: [
                    StretchMode.blurBackground,
                    StretchMode.zoomBackground
                  ],
                ),
                expandedHeight: Get.height * 0.3,
                stretch: true,
                stretchTriggerOffset: 100,
                pinned: true,
                backgroundColor: ColorUtils.WHITE_COLOR,
                //floating: true,
              ),
              SliverToBoxAdapter(
                child: CustomRowIconAndText(
                  iconData: Icons.place,
                  text: searchByTextM.name,
                ),
              ),
              SliverToBoxAdapter(
                child: CustomRowIconAndText(
                  iconData: Icons.business,
                  text: searchByTextM.formattedAddress,
                ),
              ),
              SliverToBoxAdapter(
                child: GetX<DetailPageController>(
                  builder: (controller) => CustomRowIconAndText(
                    iconData: Icons.phone,
                    text: controller?.phoneNo?.value ?? '',
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: CustomHeader(
                    child: Center(
                      child: SizedBox(
                        width: Get.width * 0.7,
                        height: 60,
                        child: Card(
                          color: Colors.white,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: ColorUtils.YELLOW_COLOR,
                                    shape: BoxShape.circle),
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.rate_review,
                                  color: ColorUtils.WHITE_COLOR,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'User Reviews',
                                maxLines: 6,
                                style: GoogleFonts.sourceSansPro(
                                    fontWeight: FontWeight.w500,
                                    color: ColorUtils.HEADING_BLACK,
                                    fontSize: 20,
                                    decoration: TextDecoration.none),
                              ),

                              //Revies List Area ******************
                            ],
                          ),
                        ),
                      ),
                    ),
                    maxHeight: 70,
                    minHeight: 55),
              ),
              GetBuilder<DetailPageController>(
                builder: (controller) => controller.placeDetailM != null
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => RowTile(
                              obj: controller.resultOfDetailM.reviews[index]),
                          childCount:
                              controller.resultOfDetailM?.reviews?.length ?? 0,
                        ),
                      )
                    : SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: ColorTween(
                                    begin: ColorUtils.DARK_BLUE_COLOR,
                                    end: ColorUtils.LITE_WHITE_COLOR)
                                .animate(Get.find<DetailPageController>()
                                    .animationController),
                            strokeWidth: 8,
                            backgroundColor: ColorUtils.YELLOW_COLOR,
                          ),
                        ),
                      ),
              )
            ],
          ),
        ));
  }

  void onGereateRoutePressed() async {
    Get.dialog(UnconstrainedBox(
      child: SizedBox(
        width: Get.width * 0.6,
        height: Get.height * 0.25,
        child: Container(
            color: ColorUtils.WHITE_COLOR,
            child: Lottie.asset('assets/generateroute.json')),
      ),
    ));
    //await Future.delayed(Duration(seconds: 3));
    try {
      bool res = await Get.find<DetailPageController>()
          .locationRequestOrGetCurrentLocation();
      if (res) {
        print(Get.find<DetailPageController>().locationData.latitude);
        var currentLocation = Get.find<DetailPageController>().locationData;

        Get.back();

        Get.to(GenerateRoutePage(
          genrateRouteM: GenrateRouteM(
            currentLocation:
                LatLng(currentLocation.latitude, currentLocation.longitude),
            destinationLocation: LatLng(searchByTextM.geometry.location.lat,
                searchByTextM.geometry.location.lng),
            locationName: searchByTextM.name,
            photoRef: searchByTextM?.photos[0]?.photoReference ?? null,
          ),
        ));
      } else {
        Get.back();
        Get.snackbar('Route', 'location permission required to genrate route');
      }
    } catch (e) {
      Get.back();
      print(e.toString());
    }
  }
}

class CustomRowIconAndText extends StatelessWidget {
  const CustomRowIconAndText({
    Key key,
    this.iconData,
    this.text,
  }) : super(key: key);
  final IconData iconData;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: ColorUtils.YELLOW_COLOR, shape: BoxShape.circle),
            padding: const EdgeInsets.all(4),
            child: Icon(
              iconData,
              color: ColorUtils.WHITE_COLOR,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              '$text',
              maxLines: 6,
              style: GoogleFonts.sourceSansPro(
                  fontWeight: FontWeight.w500,
                  color: ColorUtils.BLACK_COLOR,
                  fontSize: 16,
                  decoration: TextDecoration.none),
            ),
          ),
        ],
      ),
    );
  }
}

class RowTile extends StatelessWidget {
  const RowTile({Key key, @required this.obj}) : super(key: key);

  final Reviews obj;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: UnconstrainedBox(
        child: Stack(
          children: [
            SizedBox(
              height: 150,
              width: Get.width * 0.95,
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
                                FadeInImage.memoryNetwork(
                                  fadeInCurve: Curves.easeIn,
                                  fadeInDuration:
                                      const Duration(milliseconds: 400),
                                  placeholder: kTransparentImage,
                                  image: obj.profilePhotoUrl,
                                  fit: BoxFit.fill,
                                  height: constraints.maxHeight,
                                  width: constraints.minWidth,
                                  imageErrorBuilder: (_, p, y) =>
                                      Image.memory(kTransparentImage),
                                ))),
                    Expanded(
                      flex: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${obj.authorName ?? ''}',
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
                                '${obj?.text ?? ''}',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
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

class CustomHeader extends SliverPersistentHeaderDelegate {
  CustomHeader({this.minHeight, this.maxHeight, this.child});
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: child,
    );
  }

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return maxExtent != oldDelegate.maxExtent ||
        minExtent != oldDelegate.minExtent;
  }
}
