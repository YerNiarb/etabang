import 'package:etabang/pages/get_started.dart';
import 'package:etabang/pages/homepage.dart';
import 'package:etabang/pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'connector/db_connection.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  DbConnection dbConnection = DbConnection();
  await dbConnection.getConnection();
  
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MaterialApp(
    home: Initialize(isFirstTime: isFirstTime, isLoggedIn: isLoggedIn,),
  ));
}

class Initialize extends StatelessWidget {
  final bool isFirstTime;
  final bool isLoggedIn;
  const Initialize({super.key,  required this.isFirstTime, required this.isLoggedIn });

  @override
  Widget build(BuildContext context) {
    if(isFirstTime){
      return const MaterialApp(
        home: GetStarted()
      );
    }

    return MaterialApp(
      home:  isLoggedIn ? const Homepage() : const SignIn(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan),
        disabledColor: Colors.grey,
      ),
    );
  }
}