class Service {
  int id;
  String name;
  double hourlyPrice;
  String imageUrl;

  Service({required this.name, required this.hourlyPrice, this.imageUrl = "", required this.id});
}
