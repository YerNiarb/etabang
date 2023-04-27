import 'package:flutter/material.dart';

enum BookingStatus {
  booked,
  otw,
  servicing,
  cancelled,
  completed
}

extension BookingStatusExtension on BookingStatus {
  String get description {
    switch (this) {
      case BookingStatus.booked:
        return 'Booked';
      case BookingStatus.otw:
        return 'On the way';
      case BookingStatus.servicing:
       return 'Servicing';
      case BookingStatus.cancelled:
       return 'Cancelled';
      case BookingStatus.completed:
       return 'Completed';
      default:
        return '';
    }
  }

  Color get statusColor {
    switch (this) {
      case BookingStatus.cancelled:
       return Colors.red;
      case BookingStatus.completed:
       return Colors.green;
      default:
        return Colors.grey;
    }
  }
}