import 'package:flutter/material.dart';
import '../homepage.dart';

class BookingConfirmed extends StatelessWidget {
  final String serviceWorkerName;

  const BookingConfirmed({super.key, required this.serviceWorkerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        
        margin: const EdgeInsets.fromLTRB(50, 0, 50, 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 100),
                  width: 300,
                  height: 300,
                  child: Image.asset('assets/images/welcome-page-splash-art.png'),
                ),
              
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: const Text('Success!',
                      style:  TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                          fontFamily: 'Helvetica')),
                ),
                
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: Text(
                      'Payment successful. You’re now connected directly with $serviceWorkerName. Please wait for a while.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18,
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Homepage()),
                      );
                  },
                  child: const Text('Back to Home')
                ),
              ]
            ),
        ),
      )
    );
  }
}