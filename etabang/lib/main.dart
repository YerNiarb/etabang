// import 'package:etabang/pages/customer/find_services.dart';
// import 'package:etabang/pages/get_started.dart';
import 'package:etabang/pages/get_started.dart';
import 'package:etabang/pages/homepage.dart';
import 'package:etabang/pages/sign_in.dart';
// import 'package:etabang/pages/sign_up.dart';
// import 'package:etabang/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? true;

  runApp(MaterialApp(
    home: Initialize(isFirstTime: isFirstTime, isLoggedIn: isLoggedIn,),
  ));
}

class Initialize extends StatelessWidget {
  final bool isFirstTime;
  final bool isLoggedIn;
  const Initialize({ required this.isFirstTime, required this.isLoggedIn });

  @override
  Widget build(BuildContext context) {
    if(isFirstTime){
      return const MaterialApp(
        home: GetStarted()
      );
    }
    
    // TODO: Add authentication check

    return MaterialApp(
      home: const SignIn(), // isLoggedIn ? const Homepage() : const SignIn(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan),
        disabledColor: Colors.grey,
      ),
    );
  }
}