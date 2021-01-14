import 'package:google_maps_flutter/google_maps_flutter.dart';

class GenrateRouteM {
  LatLng currentLocation;
  LatLng destinationLocation;
  String locationName;
  String photoRef;

  GenrateRouteM(
      {this.currentLocation,
      this.destinationLocation,
      this.locationName,
      this.photoRef});
}
