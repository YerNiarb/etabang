import 'package:etabang/enums/booking_status.dart';

class Customer {
  int id;
  int? bookingId;
  String? name;
  String? bookedService;
  String imageUrl;
  int bookingStatus;
  String phoneNumber;
  String? profilePicture;

  Customer({required this.id, this.bookingId, this.name, this.bookedService, this.imageUrl = "", this.bookingStatus = 0, this.phoneNumber = "", this.profilePicture = "assets/images/default-profile.png"});
}
