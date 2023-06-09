import 'package:etabang/enums/user_type.dart';
import 'package:etabang/pages/customer/find_services.dart';
import 'package:etabang/pages/staff/order_history.dart';
import 'package:etabang/pages/staff/staff_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../connector/db_connection.dart';
import 'common/messaging.dart';
import 'common/user_profile.dart';
import 'customer/booking_tracker.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  List<BottomNavigationBarItem> _items = [];
  List<Widget> _screens = [];

  Future<int?> _loadPreferences() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('loggedInUserType');
  }

  _loadNavbarItems(int? userType){
    if(userType == UserType.customer.index){
      setState(() {
        _items = const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ];

        _screens = const [
          FindServices(),
          Messaging(),
          BookingTracker(),
          UserProfile(),
        ];
      });
    }else{
      setState(() {
        _items = const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ];

        _screens = const [
          StaffDashboard(),
          Messaging(),
          OrderHistory(),
          UserProfile(),
        ];
      });

    }
  }

  Future<void> _updateUserLocation() async {
    PostgreSQLConnection connection = await DbConnection().getConnection();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double lat;
    double lng;
    String city;
    String street;
    String state;

    if (position == null) {
      lat = 14.599512;
      lng = 120.984222;
    } else {
      lat = position.latitude;
      lng = position.longitude;
    }

    prefs.setDouble("currentLat", lat);
    prefs.setDouble("currentLng", lng);

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    city = place.locality ?? "";
    street = place.street ?? "";
    state = place.subAdministrativeArea ?? "";

    if(isLoggedIn){
      int? userId = prefs.getInt('loggedInUserId');
      if(userId != null){
          String query = """ 
              UPDATE public."Users"
                SET "CurrentLocation"=ST_Point($lat, $lng), "City"='$city', "Street"='$street', "State"='$state'
                WHERE "Id" = '$userId';
            """;

          await connection.mappedResultsQuery(query);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences().then((value) => {
      _loadNavbarItems(value)
    });
    _updateUserLocation();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens.isNotEmpty ? _screens.elementAt(_selectedIndex) : const Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar:_items.isEmpty ? null : SizedBox(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          elevation: 5,
          selectedItemColor: Colors.cyan,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          items: _items,
        ),
      ),
    );
  }
}
