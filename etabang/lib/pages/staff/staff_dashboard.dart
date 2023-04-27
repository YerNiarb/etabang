import 'package:etabang/enums/booking_status.dart';
import 'package:etabang/pages/common/vertical_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../connector/db_connection.dart';
import '../../global/vars.dart';
import '../../models/customer.dart';
import '../../models/service.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  String userName = "";
  String userInitials = "";
  TextEditingController textFilter = TextEditingController();
  int numberOfServices = 0;
  double profit = 0.00;
  int? userId;
  bool isLoading = false;

  List<Customer> recentCustomers = [];

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _loadPreferences().then((value) => {
      _loadDashboardData(),
      _loadRecentCustomers()
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    await Future.delayed(Duration.zero);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loggedInUserfirstName = prefs.getString('loggedInUserfirstName') ?? "";
    String loggedInUserlastName = prefs.getString('loggedInUserlastName') ?? "";

    setState(() {
      userName = loggedInUserfirstName;
      userId =  prefs.getInt('loggedInUserId');
      userInitials = "${String.fromCharCode(loggedInUserfirstName.codeUnitAt(0))}${String.fromCharCode(loggedInUserlastName.codeUnitAt(0))}";
    });
  }
  
  Future<void> _loadDashboardData() async {
    PostgreSQLConnection connection = await DbConnection().getConnection();

    String query = """
      SELECT COUNT(*)
        FROM "StaffServices"
        WHERE "StaffId" = $userId
      """;
    
    final numberOfServicesResult = await connection.mappedResultsQuery(query);
    var servicesCount = numberOfServicesResult.first.values.first["count"];

    query = """
      SELECT SUM("SubTotal")
	      FROM "Bookings"
        WHERE "StaffId" = $userId AND "Status"=${BookingStatus.completed.index}
      """;
    
    final profitResult = await connection.mappedResultsQuery(query);
    var profitSum = profitResult.first.values.first["sum"];

    setState(() {
      if(servicesCount != null){
        numberOfServices = servicesCount;
      }
      if(profitSum != null){
        profit = double.parse(profitSum);
      }
    });
  }

  Future<void> _loadRecentCustomers() async {
    PostgreSQLConnection connection = await DbConnection().getConnection();

    String query = """
      SELECT b."Id", u."Id", u."FirstName", u."LastName", s."Name"
        FROM "Bookings" b
        LEFT JOIN "Users" u ON b."CustomerId" = u."Id"
        LEFT JOIN "Services" s ON b."ServiceId" = s."Id"
        WHERE b."StaffId" = $userId
          AND (u."FirstName" ILIKE '%${textFilter.text}%' OR u."LastName" ILIKE '%${textFilter.text}%');
      """;
    
    final results = await connection.mappedResultsQuery(query);

    List<Customer> fetchedCustomers = [];

    if(results.isNotEmpty){
      for (var result in results) {
        var fetched = result;
        fetchedCustomers.add(
          Customer(
            id: fetched["Users"]!["Id"],
            name: "${fetched["Users"]?["FirstName"]} ${fetched["Users"]?["LastName"]}",
            bookingId: fetched["Bookings"]!["Id"],
            bookedService: fetched["Services"]!["Name"]
          )
        );
      }
    }

    setState(() {
      recentCustomers = fetchedCustomers;
      isLoading = false;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    CircleAvatar defaultAvatar = CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey[300],
      child: Text(
        userInitials,
        style: const TextStyle(fontSize: 24, color: Colors.white70),
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
                    Text('Hi $userName',
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan,
                            fontFamily: 'Helvetica')),
                    const Text('Need help?',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0x97979797),
                            fontFamily: 'Poppins')),
                  ],
                ),
                defaultAvatar
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 30),
              child: TextField(
                  cursorColor: Colors.grey,
                  controller: textFilter,
                  style: const TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                  onSubmitted:(value) async => await _loadRecentCustomers(),
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
            SizedBox(
              height: 130,
              child: isLoading ? const Align(alignment: Alignment.center, child: const CircularProgressIndicator()) :  Container(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 20),
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(25)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "# of Services",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            color: Colors.white
                          ),
                        ),
                         Text(
                          numberOfServices.toString(),
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ]
                    ),
                    const VerticalDashedLine(
                      color: Colors.white, 
                      height: double.infinity,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       const Text(
                         "Profit",
                         style: TextStyle(
                           fontFamily: "Poppins",
                           fontSize: 18,
                           color: Colors.white
                         ),
                       ),
                        Text(
                         "₱${NumberFormat('#,##0.00', 'en_US').format(profit)}",
                         style: const TextStyle(
                           fontSize: 30,
                           color: Colors.white,
                         ),
                       )
                     ]
                    ),
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.centerLeft,
              child: const Text("Recent Customers",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Poppins')),
            ),

            Expanded(
              child: 
                  recentCustomers.isEmpty 
                  ? Center(
                    child: Text(
                      textFilter.text.isEmpty ? "No recent customers." : "No search results for \"${textFilter.text}\"", 
                      style: const TextStyle(
                        color: Colors.grey, 
                        fontFamily: 'Poppins', 
                        fontSize: 18),
                      ),
                  )
                  : ListView.builder(
                  itemCount: recentCustomers.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 10, 30, 10),
                              width: 80,
                              height: 90,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image: recentCustomers[index].imageUrl.isNotEmpty ? AssetImage(recentCustomers[index].imageUrl) : AssetImage(defaulProfileImageUrl),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  )),
                            ),
                            Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                height: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${recentCustomers[index].name}",
                                      textAlign: TextAlign.center,
                                      maxLines: null,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins'),
                                    ),
                                    Text(
                                      '${recentCustomers[index].bookedService}',
                                      textAlign: TextAlign.center,
                                      maxLines: null,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Color(0x97979797),
                                          fontFamily: 'Poppins'),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ),
          ]),
        ),
      ),
    );
  }
}