// import 'package:etabang/pages/customer/find_services.dart';
// import 'package:etabang/pages/get_started.dart';
import 'package:etabang/pages/homepage.dart';
import 'package:etabang/pages/sign_in.dart';
// import 'package:etabang/pages/sign_up.dart';
// import 'package:etabang/pages/welcome_page.dart';
import 'package:flutter/material.dart';

import 'global/vars.dart';

void main() { 
  runApp(const MaterialApp(
    home: Initialize(),
  ));
}

class Initialize extends StatelessWidget {
  const Initialize({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Add authentication check

    return MaterialApp(
      home: isLoggedIn ? const Homepage() : const SignIn()
    );
  }
}