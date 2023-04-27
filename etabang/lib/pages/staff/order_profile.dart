import 'package:etabang/enums/booking_status.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../connector/db_connection.dart';
import '../../global/vars.dart';
import '../../models/service.dart';
import 'dart:math' as Math;

class OrderProfile extends StatefulWidget {
  final int bookingId;
  const OrderProfile({super.key, required this.bookingId});

  @override
  State<OrderProfile> createState() => _OrderProfileState();
}

class _OrderProfileState extends State<OrderProfile> {
  bool _imageLoaded = true;
  String firstName = "";
  String lastName = "";
  String phonenumber = "";
  String street = "";
  String city = "";
  String state = "";
  String? profilePicture = "";
  int? bookedServiceId;
  double? userLat;
  double? userLng;
  double? customerLat;
  double? customerLng;
  int bookingStatus = 0;

  List<int> staffServiceIds = [];
  List<Service> services = [];
  late Service serviceToBook;
  int? userId;
  double customerKmAway = 0.00;
  bool isLoading = false;


  Future<void> _loadPreferences() async {
    await Future.delayed(Duration.zero);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userLat = prefs.getDouble('currentLat');
      userLng = prefs.getDouble('currentLng');
      userId =  prefs.getInt('loggedInUserId');
    });
  }

  double calculateHaversineDistance(lat1, lon1, lat2, lon2) {
    const int radiusOfEarthInKm = 6371;
    double lat1Radians = Math.pi / 180 * lat1;
    double lon1Radians = Math.pi / 180 * lon1;
    double lat2Radians = Math.pi / 180 * lat2;
    double lon2Radians = Math.pi / 180 * lon2;
    double dLat = lat2Radians - lat1Radians;
    double dLon = lon2Radians - lon1Radians;
    double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(lat1Radians) *
            Math.cos(lat2Radians) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return radiusOfEarthInKm * c;
  }

  Future<void> _getStaffServices() async {
    PostgreSQLConnection connection = await DbConnection().getConnection();

    String query = """ 
        SELECT "ServiceId"
          FROM public."StaffServices"
          WHERE "StaffId"=$userId;
      """;
      
    final results = await connection.mappedResultsQuery(query);
    if(results.isNotEmpty){
      for (var result in results) {
        var fetched = result;
        setState(() {
          staffServiceIds.add(
          fetched["StaffServices"]?["ServiceId"]
          );
        });
      }
    }
  }

  Future<void> _updateBookingStatus(int statusId) async {
    PostgreSQLConnection connection = await DbConnection().getConnection();

    String query = """ 
      UPDATE public."Bookings"
        SET "Status"=$statusId
        WHERE "Id" = '${widget.bookingId}';
    """;

    await connection.mappedResultsQuery(query);

    setState(() {
      bookingStatus = statusId;
    });
  }

  Future<void> _loadBookingDetails() async {
    PostgreSQLConnection connection = await DbConnection().getConnection();
    double kmAway = 1;

    String query = """
        SELECT 
          b."Id", ST_X(b."ServiceLocation") AS "Lat", ST_Y(b."ServiceLocation") AS "Lng",
          u."Id", u."FirstName", u."LastName", u."PhoneNumber",
          b."Street", b."City", b."State", u."ProfilePicture",
          b."ServiceId", s."Name", b."Status"
          FROM "Bookings" b
          LEFT JOIN "Users" u ON b."CustomerId" = u."Id"
          LEFT JOIN "Services" s ON b."ServiceId" = s."Id"
          WHERE b."Id" = ${widget.bookingId}
          LIMIT 1;
    """;
    
    final results = await connection.mappedResultsQuery(query);

    if(results.isNotEmpty){
      var booking = results.first;

      if(booking[""]?["Lat"] != null && booking[""]?["Lng"] != null && userLat != null && userLng != null){
        kmAway = calculateHaversineDistance(booking[""]?["Lat"], booking[""]?["Lng"], userLat, userLng);
        kmAway = double.parse(kmAway.toStringAsFixed(2));

        setState(() {
          customerLat = booking[""]?["Lat"];
          customerLng = booking[""]?["Lng"];
          customerKmAway = kmAway;
        });
      }
      
      setState(() {
        firstName = booking["Users"]?["FirstName"] ?? "";
        lastName = booking["Users"]?["LastName"] ?? "";
        phonenumber = booking["Users"]?["PhoneNumber"] ?? "";
        street = booking["Bookings"]?["Street"] ?? "";
        city = booking["Bookings"]?["City"] ?? "";
        state = booking["Bookings"]?["State"] ?? "";
        bookedServiceId = booking["Bookings"]?["ServiceId"];
        bookingStatus = booking["Bookings"]?["Status"];

        serviceToBook = services.firstWhere((service) => service.id == bookedServiceId);
        isLoading = false;
      });
    }
  }

  _launchNavigationInMaps() async {
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=${customerLat},${customerLng}';
    final String appleMapsUrl = 'https://maps.apple.com/?q=${customerLat},${customerLng}';

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } 
    else if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
      await launchUrl(Uri.parse(appleMapsUrl));
    } 
    else {
      throw 'Could not launch maps';
    }

    await _updateBookingStatus(BookingStatus.otw.index);
  }

  Future<void> _getServices() async {
    PostgreSQLConnection connection = await DbConnection().getConnection();

    String query = """
        SELECT "Id", "Name", "HourlyRate"
          FROM "Services"
          WHERE "IsActive" = true;
    """;
    
    final results = await connection.mappedResultsQuery(query);
    List<Service> fetchedServices = [];

    if(results.isNotEmpty){
      for (var result in results) {
        var fetched = result.values.first;
        fetchedServices.add(
          Service(
            id: fetched["Id"], 
            name: fetched["Name"], 
            hourlyPrice: fetched["HourlyRate"]
          )
        );
      }
    }

    setState(() {
      services = fetchedServices;
    });
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _getServices();
    _getStaffServices();
    _loadPreferences().then((value) => {
      _loadBookingDetails()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                // Profile Picture
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      _imageLoaded
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                              width: double.infinity,
                              height: 275,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      profilePicture ?? ""),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  onError: (exception, stackTrace) {
                                    setState(() {
                                      _imageLoaded = false;
                                    });
                                  },
                                ),
                                color: Colors.black12,
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                              width: double.infinity,
                              height: 275,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(defaulProfileImageUrl),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  onError: (exception, stackTrace) {
                                    setState(() {
                                      _imageLoaded = false;
                                    });
                                  },
                                ),
                                color: Colors.black12,
                              )),
                      //Buttons
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 60, 0, 0),
                        alignment: Alignment.bottomLeft,
                        child: FloatingActionButton(
                          heroTag: "navigateback",
                          elevation: 0,
                          backgroundColor: Colors.grey[200],
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.chevron_left),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 60, 10, 0),
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          heroTag: "bookmark",
                          elevation: 0,
                          backgroundColor: Colors.grey[200],
                          onPressed: () {
                            // Handle button 1 tap
                          },
                          child: const Icon(Icons.bookmark_outline),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //Service Worker Details
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                        "$firstName $lastName",
                        style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins')),
                    const Spacer(),
                    if(phonenumber.isNotEmpty)
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.phone_outlined),
                        color: Colors.white,
                        onPressed: () async {
                          String _phoneNumber = phonenumber;
                          final url = Uri.parse('tel:$_phoneNumber');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      )
                    )
                  ]),

                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                    child: Text(phonenumber,
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                        )),
                  ),

                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                    child: const Text("Customer",
                        style:  TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                        )),
                  ),

                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                        ),
                        Text("${customerKmAway.toStringAsFixed(2)} km away",
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              color: Colors.grey,
                            )),
                      ],
                    ),
                  ),
      
                  // ---------- ADDRESS

                  Row(children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: const Text("Service Location",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins')),
                      
                    ),
                    const Spacer(),
                    if(phonenumber.isNotEmpty)
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.map_outlined),
                        color: Colors.white,
                        onPressed: _launchNavigationInMaps,
                      )
                    )
                  ]),
      
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(street.isNotEmpty ? "$street," : "-",
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                        )),
                    
                  ),
      
                   Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                        city.isNotEmpty && state.isNotEmpty ? 
                        "$city, $state" :
                        "-",
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        color: Colors.grey,
                      )),
                    
                  ),
      
                  // ---------- SERVICES
      
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: const Text("Requested Service",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins')),
                    
                  ),
      
                  Wrap(
                    children: [
                      for(Service service in services)
                        Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(13.0),
                          decoration: BoxDecoration(
                            color: service.id == bookedServiceId ? Colors.cyan : Colors.transparent,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: service.id == bookedServiceId ? Colors.white : Colors.grey,
                            ),
                          ),
                          child: Text(
                            service.name,
                            style: TextStyle(
                              fontSize: 15, 
                              color: service.id == bookedServiceId ? Colors.white : Colors.grey
                            ),
                          ),
                        ),
                    ],
                  ),
    
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: const Text("Booking Status",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins')),
                    
                  ),

                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
                    decoration: BoxDecoration(
                      color: BookingStatus.values[bookingStatus].statusColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                        BookingStatus.values[bookingStatus].description,
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        )),
                    
                  ),

                  if(bookingStatus == BookingStatus.booked.index || bookingStatus == BookingStatus.otw.index)
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 35, 0, 10),
                    child: TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.cyan),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(double.infinity, 50)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              const TextStyle(
                                  fontSize: 18, fontFamily: 'Poppins'),
                            )),
                        onPressed: bookingStatus == BookingStatus.cancelled.index ? null : () async {
                          await _updateBookingStatus(BookingStatus.servicing.index);
                        },
                        child: const Text('Start Servicing')),
                  ),

                  if(bookingStatus == BookingStatus.booked.index || bookingStatus == BookingStatus.otw.index)
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 35),
                    child: TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(double.infinity, 50)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              const TextStyle(
                                  fontSize: 18, fontFamily: 'Poppins'),
                            )),
                        onPressed: () async {
                          await _updateBookingStatus(BookingStatus.cancelled.index);
                        },
                        child: const Text('Cancel Booking')),
                  ),

                  if(bookingStatus == BookingStatus.servicing.index)
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 35, 0, 35),
                    child: TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(double.infinity, 50)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              const TextStyle(
                                  fontSize: 18, fontFamily: 'Poppins'),
                            )),
                        onPressed: bookingStatus == BookingStatus.completed.index ? null : () async {
                          await _updateBookingStatus(BookingStatus.completed.index);
                        },
                        child: const Text('Complete')),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}