import 'package:flutter/material.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 40),
              child: Image.asset('assets/images/get-started-img.png'),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: const Text('e-Tabang',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                      fontFamily: 'Helvetica')),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                child: const Text(
                  'We make house care services simple.\nFind the most suited staff for you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(0x97979797),
                      fontFamily: 'Poppins'),
                )
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: TextButton(
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
                  onPressed: () {
                    // This function will be called when the button is pressed
                  },
                  child: const Text('Get Started')),
            )
          ],
        ));
  }
}