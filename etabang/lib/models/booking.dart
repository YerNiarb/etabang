import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Booking {
  int serviceId;
  double subTotal;
  double travelFee;
  int numberOfHours;
  LatLng? latLong;
  String state;
  String street;
  String city;
  DateTime bookingDate;
  TimeOfDay bookingTime;

  Booking({
    required this.serviceId,
    required this.subTotal,
    required this.travelFee,
    required this.numberOfHours,
    this.latLong, 
    this.state = "", 
    this.street = "", 
    this.city = "", 
    required this.bookingDate,
    required this.bookingTime
  });
}
