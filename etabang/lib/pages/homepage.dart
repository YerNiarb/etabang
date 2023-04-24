import 'package:etabang/enums/user_type.dart';
import 'package:etabang/pages/customer/find_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/user_profile.dart';
import 'customer/worker_tracker.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    FindServices(),
    Text('Messages'),
    WorkerTracker(),
    UserProfile(),
  ];

  // Future<void> _loadNavbarItems() async {
  //   Future.delayed(Duration.zero);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int? userType = await prefs.getInt('loggedInUserType');

  //   if(userType == UserType.customer.index){
  //     setState(() {
  //       _screens = [
  //         FindServices(),
  //         Text('Messages'),
  //         WorkerTracker(),
  //         UserProfile(),
  //       ];
  //     });
  //   }else{
  //     _screens = [
  //       Text('Messages'),
  //       UserProfile(),
  //     ];
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    // _loadNavbarItems();
    super.initState();
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
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          elevation: 5,
          selectedItemColor: Colors.cyan,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
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
          ],
        ),
      ),
    );
  }
}
