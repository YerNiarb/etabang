import 'package:etabang/pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../enums/user_type.dart';
import '../../models/user_location.dart';
import '../customer/location_selector.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String firstName = "";
  String lastName = "";
  String username = "christiandoe";
  String name = "";
  String phonenumber = "11111111111";
  String street = "";
  String city = "";
  String state = "";
  // String address = "Room 123, Brooklyn St, Kepler District";
  String _text = 'Initial Text';
  String userInitials = "";
  LatLng? location;
  int? userType;
  String workingDays = "";
  String workingHours = "";

  List<bool> days = List<bool>.filled(7, false);

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    await Future.delayed(Duration.zero);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loggedInUserfirstName = prefs.getString('loggedInUserfirstName') ?? "";
    String loggedInUserlastName = prefs.getString('loggedInUserlastName') ?? "";

    setState(() {
      firstName = loggedInUserfirstName;
      lastName = loggedInUserlastName;
      userType = prefs.getInt('loggedInUserType');
      userInitials = "${String.fromCharCode(loggedInUserfirstName.codeUnitAt(0))}${String.fromCharCode(loggedInUserlastName.codeUnitAt(0))}";
    });
  }
  
  void _showModal(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: _text);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Text'),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _text = controller.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
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
    CircleAvatar defaultAvatar = CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[300],
        child: Text(
          userInitials,
          style: TextStyle(fontSize: 24, color: Colors.white70),
        ));

    return Scaffold(
      body: SingleChildScrollView(
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
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Text(
                  "$firstName $lastName",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),

              // GestureDetector(
              //   onTap:() => _showModal(context),
              //   child: Container(
              //     height: 50,
              //     width: 200,
              //     color: Colors.blue,
              //     child: Center(
              //       child: Text('Tap me to open modal'),
              //     ),
              //   ),
              // ),

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
                    Text(
                      username,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700]
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
                    Text(
                      phonenumber,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700]
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
                      const Icon(
                        Icons.access_time_outlined,
                        color: Colors.cyan,
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
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.cyan,
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