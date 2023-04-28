import 'package:etabang/pages/customer/view_service_worker_details.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../connector/db_connection.dart';
import '../../global/vars.dart';
import '../../models/service_worker.dart';
import '../homepage.dart';
import 'dart:math' as Math;

class FindWorkers extends StatefulWidget {
  final int serviceId;
  FindWorkers({super.key, required this.serviceId});

  @override
  State<FindWorkers> createState() => _FindWorkersState();
}

class _FindWorkersState extends State<FindWorkers> {
  String userName = "";
  String userInitials = "";
  int? userId;
  double? userLat;
  double? userLng;
  TextEditingController textFilter = TextEditingController();
      
  List<ServiceWorker> availableWorkers = [];

  Future<void> _loadPreferences() async {
    await Future.delayed(Duration.zero);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loggedInUserfirstName = prefs.getString('loggedInUserfirstName') ?? "";
    String loggedInUserlastName = prefs.getString('loggedInUserlastName') ?? "";
    userId = prefs.getInt('loggedInUserId');

    setState(() {
      userName = loggedInUserfirstName;
      userLat = prefs.getDouble('currentLat');
      userLng = prefs.getDouble('currentLng');
      userInitials = "${String.fromCharCode(loggedInUserfirstName.codeUnitAt(0))}${String.fromCharCode(loggedInUserlastName.codeUnitAt(0))}";
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

  Future<void> _getAvailableWorkers() async {
    PostgreSQLConnection connection = await DbConnection().getConnection();

    String query = """
        SELECT u."FirstName", u."LastName", ST_X(u."CurrentLocation") AS "Lat", ST_Y(u."CurrentLocation") AS "Lng", u."Street", u."City", u."State", 
          u."WorkingDays", u."WorkingHours",
          s."Name" as "ServiceName", ss."ServiceId" as "ServiceId", ss."StaffId" as "StaffId", s."HourlyRate" as "HourlyRate"
          FROM "StaffServices" ss 
          LEFT JOIN "Users" u ON ss."StaffId" = u."Id"  
          LEFT JOIN "Services" s ON ss."ServiceId" = s."Id"
          WHERE ss."ServiceId" = ${widget.serviceId} AND (u."FirstName" ILIKE '%${textFilter.text}%' OR u."LastName" ILIKE '%${textFilter.text}%');
    """;
    
    final results = await connection.mappedResultsQuery(query);
    List<ServiceWorker> fetchedWorkers = [];

    if(results.isNotEmpty){
      for (var result in results) {
        var fetched = result;
        double kmAway = 1;

        if(fetched[""]?["Lat"] != null && fetched[""]?["Lng"] != null && userLat != null && userLng != null){
          kmAway = calculateHaversineDistance(fetched[""]?["Lat"], fetched[""]?["Lng"], userLat, userLng);
          kmAway = double.parse(kmAway.toStringAsFixed(2));
        }

        var fetchedWorker =  ServiceWorker(
            id: fetched["StaffServices"]?["StaffId"], 
            firstName: fetched["Users"]?["FirstName"], 
            lastName: fetched["Users"]?["LastName"], 
            street: fetched["Users"]?["Street"] ?? "", 
            city: fetched["Users"]?["City"] ?? "", 
            state: fetched["Users"]?["State"] ?? "", 
            userName: "",
            hourlyPrice: fetched["Services"]?["HourlyRate"],
            kmAway: kmAway,
            workingHours: fetched["Users"]?["WorkingHours"] ?? ""
          );

          if(fetched["Users"]?["WorkingDays"]){
            fetchedWorker.workingDays = fetched["Users"]?["WorkingDays"];
          }

        fetchedWorkers.add(fetchedWorker);
      }
    }

    setState(() {
      availableWorkers = fetchedWorkers;
    });
  }

  @override
  void initState() {
    super.initState();
    _getAvailableWorkers(); 
    _loadPreferences();
  }


  @override
  Widget build(BuildContext context) {
    CircleAvatar defaultAvatar = CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey[300],
      child: Text(
        userInitials,
        style: TextStyle(fontSize: 24, color: Colors.white70),
      ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 10.0),
        child: Container(
          color: Colors.white,
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Homepage()),
                        );
                      },
                    )
                  ],
                ),
                defaultAvatar
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 50),
              child: TextField(
                onSubmitted: (value) async => await _getAvailableWorkers(),
                cursorColor: Colors.grey,
                controller: textFilter,
                style: const TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none),
                    hintText: 'Search',
                    hintStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    labelStyle: const TextStyle(
                        fontSize: 15, fontFamily: 'Poppins'),
                    filled: true,
                    fillColor: Colors.grey[200],
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)))),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Workers available",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Helvetica'))
                  ]),
            ),
            Expanded(
              child: availableWorkers.isEmpty
                  ? Container(
                    margin: const EdgeInsets.only(top: 120),
                    child: Text(
                      textFilter.text.isEmpty ? "No staff found." : "No search results for \"${textFilter.text}\"", 
                      style: const TextStyle(
                        color: Colors.grey, 
                        fontFamily: 'Poppins', 
                        fontSize: 18),
                      ),
                  )
                  : GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                padding: const EdgeInsets.all(5.0),
                children: List.generate(availableWorkers.length, (index) {
                  return  InkWell(
                     onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewServiceWorkerDetails(
                            serviceWorker: availableWorkers[index],
                            serviceIdToBook: widget.serviceId,
                          )
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                width: 160,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                  image: DecorationImage(
                                    image: AssetImage(availableWorkers[index].profileImageUrl ?? defaulProfileImageUrl),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  )),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                                child: Text(
                                  availableWorkers[index].firstName,
                                  textAlign: TextAlign.left,
                                  maxLines: null,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(8.0, 0, 0, 1),
                                child: Text(
                                  '${availableWorkers[index].kmAway} km away',
                                  textAlign: TextAlign.left,
                                  maxLines: null,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0x97979797),
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                            ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
