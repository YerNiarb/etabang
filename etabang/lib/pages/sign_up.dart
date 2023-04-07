import 'package:etabang/pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../global/vars.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController fullName = TextEditingController();
    TextEditingController userName = TextEditingController();
    TextEditingController password = TextEditingController();

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(50, 100, 50, 0),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 120),
              child:  const Text('Let\' Create\nYour Account!',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Helvetica')
                ),
            ),
           
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Full Name',
                    style: TextStyle(
                          fontSize: 19.5,
                          fontFamily: 'Poppins'
                    )
                  ),
                  TextField(
                    controller: fullName,
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
                if(userName.text.isNotEmpty && password.text.isNotEmpty){
                  isLoggedIn = true;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignIn()),
                  );
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enter required fields.'),
                    ),
                  );
                }
              },
              child: const Text('Sign Up')
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                color: Color(0x97979797),
                          )
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignIn()),
                          );
                        },
                        child: const Text('Sign In',
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
