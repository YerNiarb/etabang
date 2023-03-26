import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});
  
  @override
  Widget build(BuildContext context) {
    TextEditingController userName = TextEditingController();
    TextEditingController password = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.fromLTRB(50, 40, 50, 0),
        child: ListView(
          children: [
           Container(
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 40),
              child: Image.asset('assets/images/sign-in-splash-logo.png'),
            ),
           
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Username',
                    style: TextStyle(
                          fontSize: 19.5,
                          fontFamily: 'Poppins'
                    )
                  ),
                  TextField(
                    controller: userName,
                    style: const TextStyle(
                          fontSize: 19.5,
                          fontFamily: 'Poppins'
                    ),
                    cursorColor: Colors.cyan,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                      ),
                    )
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Password',
                    style: TextStyle(
                          fontSize: 19.5,
                          fontFamily: 'Poppins'
                    )
                  ),
                  TextField(
                    controller: password,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(
                          fontSize: 19.5,
                          fontFamily: 'Poppins',
                    ),
                    cursorColor: Colors.cyan,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                      ),
                    )
                  ),
                ],
              ),
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
              onPressed: () {
                // This function will be called when the button is pressed
              },
              child: const Text('Sign Up')
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Not a member yet? ',
                        style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                color: Color(0x97979797),
                          )
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle the tap event
                        },
                        child: const Text('Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      )
                    ],
                  ),
            ) 
          ]),
      )
    );
  }
}