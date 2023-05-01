import 'dart:convert';

import 'package:etabang/pages/staff/order_profile.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../connector/db_connection.dart';
import '../../enums/booking_status.dart';
import '../../global/vars.dart';
import '../../models/customer.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  String userName = "";
  String userInitials = "";
  TextEditingController textFilter = TextEditingController();
  int? userId;

  List<Customer> recentCustomers = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences()
        .then((value) => {_loadRecentCustomers()});
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    await Future.delayed(Duration.zero);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loggedInUserfirstName =
        prefs.getString('loggedInUserfirstName') ?? "";
    String loggedInUserlastName = prefs.getString('loggedInUserlastName') ?? "";

    setState(() {
      userName = loggedInUserfirstName;
      userId = prefs.getInt('loggedInUserId');
      userInitials =
          "${String.fromCharCode(loggedInUserfirstName.codeUnitAt(0))}${String.fromCharCode(loggedInUserlastName.codeUnitAt(0))}";
    });
  }

  Future<void> _loadRecentCustomers() async {
    PostgreSQLConnection connection = await DbConnection().getConnection();

    String query = """
      SELECT b."Id", u."Id", u."FirstName", u."LastName", s."Name", b."Status", u."ProfilePicture"
        FROM "Bookings" b
        LEFT JOIN "Users" u ON b."CustomerId" = u."Id"
        LEFT JOIN "Services" s ON b."ServiceId" = s."Id"
        WHERE b."StaffId" = $userId
          AND (u."FirstName" ILIKE '%${textFilter.text}%' OR u."LastName" ILIKE '%${textFilter.text}%');
      """;

    final results = await connection.mappedResultsQuery(query);

    List<Customer> fetchedCustomers = [];

    if (results.isNotEmpty) {
      for (var result in results) {
        var fetched = result;
        fetchedCustomers.add(Customer(
            id: fetched["Users"]!["Id"],
            name: "${fetched["Users"]?["FirstName"]} ${fetched["Users"]?["LastName"]}",
            bookingId: fetched["Bookings"]!["Id"],
            bookedService: fetched["Services"]!["Name"],
            bookingStatus: fetched["Bookings"]!["Status"],
            profilePicture: fetched["Users"]?["ProfilePicture"] ?? defaulProfileImageUrl
            ));
      }
    }

    setState(() {
      recentCustomers = fetchedCustomers;
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
        padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 10.0),
        child: Container(
          color: Colors.white,
          child: Column(children: [
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 30),
              alignment: Alignment.center,
              child: const Text("Order History",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Poppins')),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: TextField(
                  cursorColor: Colors.grey,
                  controller: textFilter,
                  style: const TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                  onSubmitted: (value) async => await _loadRecentCustomers(),
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
                      labelStyle:
                          const TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                      filled: true,
                      fillColor: Colors.grey[200],
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)))),
            ),
            Expanded(
              child: recentCustomers.isEmpty
                  ? Center(
                      child: Text(
                        textFilter.text.isEmpty
                            ? "No orders to show."
                            : "No search results for \"${textFilter.text}\"",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                            fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: recentCustomers.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap:() async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OrderProfile(
                                  bookingId: recentCustomers[index].bookingId!,
                                    )
                                ),
                            );
                            await _loadRecentCustomers();
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                            if(recentCustomers[index].profilePicture != defaulProfileImageUrl)
                                Container(
                                  margin: const EdgeInsets.fromLTRB(10, 10, 30, 10),
                                  width: 80,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image: MemoryImage(base64.decode(recentCustomers[index].profilePicture!)),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    )),
                                ),
                                if(recentCustomers[index].profilePicture == defaulProfileImageUrl)
                                Container(
                                  margin: const EdgeInsets.fromLTRB(10, 10, 30, 10),
                                  width: 80,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image: AssetImage(defaulProfileImageUrl),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    )),
                                ),
                                  Container(
                                      margin:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      height: 100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                          ),
                                          Text(
                                            BookingStatus.values[recentCustomers[index].bookingStatus].description,
                                            textAlign: TextAlign.center,
                                            maxLines: null,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: BookingStatus.values[recentCustomers[index].bookingStatus].statusColor,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins'),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
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
