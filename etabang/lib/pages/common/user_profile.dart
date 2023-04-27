import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:etabang/pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../connector/db_connection.dart';
import '../../enums/user_type.dart';
import '../../models/user_location.dart';
import '../customer/location_selector.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int? userId;
  String firstName = "";
  String lastName = "";
  String username = "";
  String phonenumber = "";
  String street = "";
  String city = "";
  String state = "";
  String userInitials = "";
  LatLng? location;
  int? userType;
  String workingDays = "";
  String workingHours = "";

  List<bool> days = List<bool>.filled(7, false);
  bool isLoading = false;

  // late File? _imageFile;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _loadPreferences().then((value) => {
      _getUserDetails()
    });
  }

  Future<void> _getUserDetails() async {
    PostgreSQLConnection connection = await DbConnection().getConnection();

    String query = """
        SELECT * 
          FROM "Users"
          WHERE "Id" = $userId;
    """;
    
    final results = await connection.mappedResultsQuery(query);

    if(results.isNotEmpty){
      var result = results.first;
      setState(() {
        firstName = result.values.first["FirstName"] ?? "";
        lastName = result.values.first["LastName"] ?? "";
        username = result.values.first["Username"] ?? "";
        phonenumber = result.values.first["PhoneNumber"] ?? "";
        street = result.values.first["Street"] ?? "";
        city = result.values.first["City"] ?? "";
        state = result.values.first["State"] ?? "";
        workingHours = result.values.first["WorkingHours"] ?? "";

        if(result.values.first["WorkingDays"] != null){
          days = List<bool>.from(result.values.first['WorkingDays']);
        }

        isLoading = false;
      });
    }
  }

  //  Future<void> _getImage() async {
  //   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _imageFile = File(pickedFile.path);
  //     }
  //   });

  //   widget.onProfilePictureUploaded(_imageFile);
  // }

  Future<void> _loadPreferences() async {
    await Future.delayed(Duration.zero);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loggedInUserfirstName = prefs.getString('loggedInUserfirstName') ?? "";
    String loggedInUserlastName = prefs.getString('loggedInUserlastName') ?? "";

    setState(() {
      firstName = loggedInUserfirstName;
      lastName = loggedInUserlastName;
      userId =  prefs.getInt('loggedInUserId');
      userType = prefs.getInt('loggedInUserType');
      userInitials = "${String.fromCharCode(loggedInUserfirstName.codeUnitAt(0))}${String.fromCharCode(loggedInUserlastName.codeUnitAt(0))}";
    });
  }

  void _showTimeRangePicker() {
    DateTime startTime = DateTime.now();
    DateTime endTime = DateTime.now();

    DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      showSecondsColumn: false,
      currentTime: startTime,
      onChanged: (startTime) {
        startTime = startTime;
      },
      onConfirm: (startTime) {
        startTime = startTime;
        DatePicker.showTimePicker(
          context,
          showTitleActions: true,
          currentTime: endTime,
          showSecondsColumn: false,
          onChanged: (endTime) {
            endTime = endTime;
          },
          onConfirm: (endTime) {
            endTime = endTime;
            setState(() {
              workingHours = "${DateFormat('hh:mm a').format(startTime)} - ${DateFormat('hh:mm a').format(endTime)}";
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController(text: firstName);
    TextEditingController lastNameController = TextEditingController(text: lastName);
    TextEditingController usernameController = TextEditingController(text: username);
    TextEditingController phoneNumberController = TextEditingController(text: phonenumber);
    
    CircleAvatar defaultAvatar = CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[300],
        // backgroundImage: 
          // _imageFile != null ?
          // FileImage(_imageFile!) : null,
          child: 
          // _imageFile == null ? const Icon(Icons.camera_alt) :
           Text(
            userInitials,
            style: const TextStyle(fontSize: 24, color: Colors.white70),
          )
        
        );

    return Scaffold(
      body: isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50, left: 35, right: 35),
          child: Column(
            children: [
              const Center(
                child:  Text(
                  "User Profile",
                  textAlign: TextAlign.center,  
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: defaultAvatar,
              ),
              GestureDetector(
                onTap: () => {
                   showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Name'),
                        content: Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: TextField(
                                  controller: firstNameController,
                                    style: const TextStyle(
                                      fontSize:  15,
                                      fontFamily: 'Poppins',
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: "First Name",
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                                    ),
                                  )
                                ),
                              ),
                              Flexible(
                                child: TextField(
                                  controller: lastNameController,
                                    style: const TextStyle(
                                      fontSize:  15,
                                      fontFamily: 'Poppins',
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: "Last Name",
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                                    ),
                                  )
                                ),
                              ),
                            ]
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                firstName = firstNameController.text;
                                lastName = lastNameController.text;
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      );
                    },
                  )
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 25),
                  child: Text(
                    "$firstName $lastName",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Username",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Username'),
                              content: TextField(
                                controller: usernameController,
                                  style: const TextStyle(
                                    fontSize:  15,
                                    fontFamily: 'Poppins',
                                ),
                                decoration: const InputDecoration(
                                  hintText: "Username",
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                                  ),
                                )
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      username = usernameController.text;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        username,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700]
                          ),
                      ),
                    )
                  ]
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Phone No.",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Phone Number'),
                              content: TextField(
                                controller: phoneNumberController,
                                  style: const TextStyle(
                                    fontSize:  15,
                                    fontFamily: 'Poppins',
                                ),
                                decoration: const InputDecoration(
                                  hintText: "Phone Number",
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                                  ),
                                )
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      phonenumber = phoneNumberController.text;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        phonenumber,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700]
                          ),
                      ),
                    )
                  ]
                ),
              ),

              if(userType == UserType.staff.index)
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                     Text(
                      "Working Days",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                    )
                  ]
                ),
              ),

              if(userType == UserType.staff.index)
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: WeekdaySelector(
                  textStyle: const TextStyle(color: Colors.black54, inherit: false),
                  selectedTextStyle: const TextStyle(color: Colors.white, inherit: false),
                  onChanged: (int day) {
                    setState(() {
                      final index = day % 7;
                      days[index] = !days[index];
                    });
                  },
                  values: days,
                ),
              ),

               if(userType == UserType.staff.index)
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                     Text(
                      "Working Hours",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                    )
                  ]
                ),
              ),

              if(userType == UserType.staff.index)
              GestureDetector(
                onTap: _showTimeRangePicker,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.access_time_outlined,
                          color: Colors.cyan,
                        ),
                      ),
                      Text(
                        workingHours,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700]
                          ),
                      )
                    ]
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                     Text(
                      "Location",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                    )
                  ]
                ),
              ),

              GestureDetector(
                onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocationSelector()),
                );

                if (result != null) {
                  UserLocation selectedLocation = result as UserLocation;
                  setState(() {
                    location =
                        LatLng(selectedLocation.lat, selectedLocation.lng);
                    street = selectedLocation.street;
                    city = selectedLocation.city;
                    state = selectedLocation.state;
                  });
                }
              },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.location_on_outlined,
                          color: Colors.cyan,
                        ),
                      ),
                      Text(
                        "$street, $city, $state",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700]
                          ),
                      )
                    ]
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 100),
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.cyan),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        minimumSize:
                            MaterialStateProperty.all<Size>(const Size(double.infinity, 50)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          const TextStyle(fontSize: 18),
                        )),
                    onPressed: () async {
                       try {
                        PostgreSQLConnection connection = await DbConnection().getConnection();

                        var dayArrayToString = days.join(', ');

                        String query = """
                            UPDATE public."Users"
                              SET "FirstName"='$firstName', "LastName"='$lastName', "PhoneNumber"='$phonenumber',
                              "Street"='$street', "City"='$city', "State"='$state', 
                              "WorkingHours"='$workingHours', 
                              "Username"='$username', "WorkingDays"=ARRAY[$dayArrayToString]
                              WHERE "Id"=$userId;
                        """;
                        
                        final results = await connection.mappedResultsQuery(query);

                        if(location != null){
                           String query = """
                            UPDATE public."Users"
                              SET "CurrentLocation"=ST_POINT(${location!.latitude}, ${location!.longitude})
                              WHERE "Id"=$userId;
                        """;
                        
                        final results = await connection.mappedResultsQuery(query);
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Updated successfully.'),
                            backgroundColor: Colors.cyan,
                          ),
                        );
                       } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Unable to update profile.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                       }
                    },
                    child: const Text('Save Changes')
                  ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        minimumSize:
                            MaterialStateProperty.all<Size>(const Size(double.infinity, 50)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          const TextStyle(fontSize: 18),
                        )),
                    onPressed: () async {
                       SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isFirstLogin', true);
                        await prefs.setBool('isLoggedIn', false);

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                          (route) => false,
                        );
                    },
                    child: const Text('Logout')
                  ),
              ),
            ],
          ),
        )
      ),
    );
  }
}