import 'package:google_maps_flutter/google_maps_flutter.dart';

class Booking {
  // String serviceId;
  // double subTotal;
  // double travelFee;
  // int numberOfHours;
  LatLng latLong;
  String floor;
  String street;
  String city;

  Booking({required this.latLong, this.floor = "", this.street = "", required this.city});
}
