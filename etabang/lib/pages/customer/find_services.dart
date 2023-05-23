import 'dart:convert';

import 'package:etabang/pages/customer/find_workers.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../connector/db_connection.dart';
import '../../global/vars.dart';
import '../../models/service.dart';

class FindServices extends StatefulWidget {
  const FindServices({super.key});

  @override
  State<FindServices> createState() => _FindServicesState();
}

class _FindServicesState extends State<FindServices> {
  String userName = "";
  String userInitials = "";
  TextEditingController textFilter = TextEditingController();
  int? userId;
  String? _image;

  List<Service> services = [];

  @override
  void initState() {
    super.initState();
    _getServices(); 
    _loadPreferences().then((value) => {
      _getUserDetails()
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

  Future<void> _getUserDetails() async {
    PostgreSQLConnection connection = await DbConnection().getConnection();

    String query = """
        SELECT "ProfilePicture" 
          FROM "Users"
          WHERE "Id" = $userId;
    """;
    
    final results = await connection.mappedResultsQuery(query);

    if(results.isNotEmpty){
      var result = results.first;
      setState(() {
        _image = result.values.first["ProfilePicture"];
      });
    }
  }
  
  Future<void> _getServices() async {
    PostgreSQLConnection connection = await DbConnection().getConnection();

    String query = """
        SELECT "Id", "Name", "HourlyRate"
          FROM "Services"
          WHERE "IsActive" = true AND "Name" ILIKE '%${textFilter.text}%';
    """;
    
    final results = await connection.mappedResultsQuery(query);
    List<Service> fetchedServices = [];

    if(results.isNotEmpty){
      for (var result in results) {
        var _fetched = result.values.first;
        fetchedServices.add(
          Service(id: _fetched["Id"], name: _fetched["Name"], hourlyPrice: _fetched["HourlyRate"])
        );
      }
    }

    setState(() {
      services = fetchedServices;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    CircleAvatar defaultAvatar = _image != null ? 
      CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            backgroundImage:  MemoryImage(base64.decode(_image!)),    
          ):
      CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          backgroundImage: const AssetImage('assets/images/default-profile.png'),  
        );

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
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 50),
              child: TextField(
                  cursorColor: Colors.grey,
                  controller: textFilter,
                  style: const TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                  onSubmitted:(value) async => await _getServices(),
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
              margin: const EdgeInsets.only(bottom: 10),
              alignment: Alignment.centerLeft,
              child: const Text("What are you looking for?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Helvetica')),
            ),
            Expanded(
              child: 
                  services.isEmpty 
                  ? Center(
                    child: Text(
                      textFilter.text.isEmpty ? "No services found." : "No search results for \"${textFilter.text}\"", 
                      style: const TextStyle(
                        color: Colors.grey, 
                        fontFamily: 'Poppins', 
                        fontSize: 18),
                      ),
                  )
                  : ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FindWorkers( serviceId: services[index].id )),
                        );
                      },
                      child: Card(
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
                                      image: services[index].imageUrl.isNotEmpty ? AssetImage(services[index].imageUrl) : AssetImage(defaulServiceImageUrl),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    )),
                              ),
                              Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  height: 100,
                                  width: 225,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        services[index].name,
                                        textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins'),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: Colors.lightBlue[50],
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                            ),
                                            child: const Text(
                                              '₱',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.cyan),
                                            ),
                                          ),
                                          Text(
                                            '${services[index].hourlyPrice} / hour',
                                            textAlign: TextAlign.center,
                                            maxLines: null,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Color(0x97979797),
                                                fontFamily: 'Poppins'),
                                          )
                                        ],
                                      )
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
