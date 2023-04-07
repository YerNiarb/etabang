import 'package:etabang/models/user.dart';

class ServiceWorker extends User {
  double currentLocationLat;
  double currentLocationLong;

  ServiceWorker({
    required super.firstName, 
    required super.lastName, 
    required super.street, 
    required super.city, 
    required super.state, 
    required super.userName,
    this.currentLocationLat = 12.879721,
    this.currentLocationLong = 121.77401699999996
  });
}
