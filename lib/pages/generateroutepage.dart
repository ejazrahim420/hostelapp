import 'dart:async';
import 'dart:math';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hostelfinder/modalclasses/genrateroutem.dart';
import 'package:hostelfinder/utils/apiutils/apiutils.dart';
import 'package:hostelfinder/utils/colorutils/colorutils.dart';
import 'package:transparent_image/transparent_image.dart';

class GenerateRoutePage extends StatefulWidget {
  GenerateRoutePage({Key key, this.genrateRouteM});
  final GenrateRouteM genrateRouteM;
  static const ROUTE_PAGE_ROUTE = '/routepage';

  @override
  _GenerateRoutePageState createState() => _GenerateRoutePageState();
}

class _GenerateRoutePageState extends State<GenerateRoutePage> {
  final Completer<GoogleMapController> _controller = Completer();

  Set<Polyline> polylines = {};

  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    _getPolyline();
    getDistance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            polylines: polylines,
            markers: <Marker>{
              Marker(
                  markerId: MarkerId(widget
                      .genrateRouteM.currentLocation.longitude
                      .toString()),
                  icon: BitmapDescriptor.defaultMarker,
                  draggable: false,
                  visible: true,
                  position: widget.genrateRouteM.currentLocation),
              Marker(
                  markerId: MarkerId(widget
                      .genrateRouteM.destinationLocation.longitude
                      .toString()),
                  icon: BitmapDescriptor.defaultMarker,
                  draggable: false,
                  visible: true,
                  position: widget.genrateRouteM.destinationLocation),
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.genrateRouteM.currentLocation.latitude,
                  widget.genrateRouteM.currentLocation.longitude),
              zoom: 13.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            top: height * 0.75,
            bottom: 20,
            right: 30,
            left: 30,
            child: Card(
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: LayoutBuilder(
                builder: (context, constraints) =>
                    widget.genrateRouteM.photoRef != null
                        ? FadeInImage.memoryNetwork(
                            fadeInCurve: Curves.easeIn,
                            fadeInDuration: const Duration(milliseconds: 400),
                            placeholder: kTransparentImage,
                            image:
                                'https://maps.googleapis.com/maps/api/place/photo?maxwidth=300&photoreference=${widget.genrateRouteM.photoRef}&key=${ApiUtils.API_KEY}',
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
            ),
          ),

          //Total Distance
          Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: FutureBuilder<double>(
                future: getDistance(),
                initialData: 0,
                builder: (context, snapshot) {
                  return Center(
                    child: CustomRowIconAndText(
                      iconData: Icons.place,
                      text: '${snapshot.data.toStringAsFixed(2)} km',
                    ),
                  );
                },
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorUtils.DARK_BLUE_COLOR,
        onPressed: _goToTheLake,
        label: Text('Go To the Hostel!'),
        icon: Icon(Icons.business_outlined),
      ),
    );
  }

  Future<double> getDistance() async {
    double distanceInMeters = Geolocator.distanceBetween(
      widget.genrateRouteM.currentLocation.latitude,
      widget.genrateRouteM.currentLocation.longitude,
      widget.genrateRouteM.destinationLocation.latitude,
      widget.genrateRouteM.destinationLocation.longitude,
    );
    return distanceInMeters / 1000;
  }

  Future<void> _goToTheLake() async {
    getDistance();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(widget.genrateRouteM.currentLocation.latitude,
              widget.genrateRouteM.currentLocation.longitude),
          zoom: 19.5555,
          tilt: 50,
          bearing: getBearing(widget.genrateRouteM.currentLocation,
              widget.genrateRouteM.destinationLocation),
        ),
      ),
    );
  }

  double getBearing(LatLng begin, LatLng end) {
    double dLon = (end.longitude - begin.longitude);
    double x = sin(radians(dLon)) * cos(radians(end.latitude));
    double y = cos(radians(begin.latitude)) * sin(radians(end.latitude)) -
        sin(radians(begin.latitude)) *
            cos(radians(end.latitude)) *
            cos(radians(dLon));
    double bearing = degrees((atan2(x, y)));
    return bearing;
  }

  _addPolyLine() {
    print('inisde poly line');
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: ColorUtils.RED_COLOR,
        points: polylineCoordinates,
        width: 4,
        jointType: JointType.round);
    polylines.add(polyline);
    setState(() {});
  }

  _getPolyline() async {
    print('_getPolyline poly line');
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      ApiUtils.API_KEY,
      PointLatLng(widget.genrateRouteM.currentLocation.latitude,
          widget.genrateRouteM.currentLocation.longitude),
      PointLatLng(widget.genrateRouteM.destinationLocation.latitude,
          widget.genrateRouteM.destinationLocation.longitude),
    );
    if (result.points.isNotEmpty) {
      print('result.points.isNotEmpty poly line');
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  // void animatedCamera() async {
  //   final GoogleMapController controller = await _controller.future;
  //   if (widget.genrateRouteM.currentLocation.latitude <=
  //       widget.genrateRouteM.destinationLocation.latitude) {
  //     _southwestCoordinates = widget.genrateRouteM.currentLocation;
  //     _northeastCoordinates = widget.genrateRouteM.destinationLocation;
  //   } else {
  //     _southwestCoordinates = widget.genrateRouteM.destinationLocation;

  //     _northeastCoordinates = widget.genrateRouteM.currentLocation;
  //   }
  //   controller.animateCamera(
  //     CameraUpdate.newLatLngBounds(
  //         LatLngBounds(
  //           northeast: LatLng(
  //             _northeastCoordinates.latitude,
  //             _northeastCoordinates.longitude,
  //           ),
  //           southwest: LatLng(
  //             _southwestCoordinates.latitude,
  //             _southwestCoordinates.longitude,
  //           ),
  //         ),
  //         //padding
  //         10),
  //   );
  // }

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
    return Card(
      color: ColorUtils.DARK_BLUE_COLOR,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
                    color: ColorUtils.WHITE_COLOR,
                    fontSize: 16,
                    decoration: TextDecoration.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
