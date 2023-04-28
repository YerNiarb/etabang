import 'package:etabang/models/user.dart';

class ServiceWorker extends User {
  double hourlyPrice;
  double currentLocationLat;
  double currentLocationLong;
  double kmAway;
  List<bool> workingDays;
  String workingHours;

  ServiceWorker({
    required super.id,
    required super.firstName, 
    required super.lastName, 
    required super.street, 
    required super.city, 
    required super.state, 
    required super.userName,
    this.currentLocationLat = 12.879721,
    this.currentLocationLong = 121.77401699999996,
    this.hourlyPrice = 0.00,
    this.kmAway = 1,
    this.workingDays  = const [true, true, true, true, true, true, true],
    this.workingHours = "9:00AM to 3:00PM",
  });
}
