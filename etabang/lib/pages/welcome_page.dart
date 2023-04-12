import 'package:etabang/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String name = "Christian";

     return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        
        margin: const EdgeInsets.fromLTRB(50, 0, 50, 30),
        child: Center(
          child: ListView(
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 100),
                  width: 300,
                  height: 300,
                  child: Image.asset('assets/images/welcome-page-splash-art.png'),
                ),
              
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Text('Welcome $name',
                      style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                          fontFamily: 'Helvetica')),
                ),
                
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                    child: const Text(
                      'Have some problem today?\nDon’t worry, now you are part of e-Tabang.\nLets us help you.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 21,
                          color: Color(0x97979797),
                          fontFamily: 'Poppins'),
                    )
                ),

                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.cyan),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(250, 65)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                      )),
                  onPressed: () async {
                     SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isFirstLogin', false);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Homepage()),
                      );
                  },
                  child: const Text('Go to Homepage')
                ),
              ]
            )
        ),
      )
    );
  }
}