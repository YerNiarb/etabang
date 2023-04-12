import 'package:etabang/global/vars.dart';
import 'package:etabang/pages/customer/find_services.dart';
import 'package:etabang/pages/homepage.dart';
import 'package:etabang/pages/sign_up.dart';
import 'package:etabang/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});
  
  @override
  Widget build(BuildContext context) {
    TextEditingController userName = TextEditingController();
    TextEditingController password = TextEditingController();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                onPressed: () async {
                  if(userName.text.isNotEmpty && password.text.isNotEmpty){
                    isLoggedIn = true;

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', true);

                    bool isFirstTime = prefs.getBool('isFirstLogin') ?? true;

                    if (isFirstTime) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomePage()),
                        );
                      } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Homepage()),
                      );
                    }
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter username or password'),
                      ),
                    );
                  }
                },
                child: const Text('Sign In')
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUp()),
                            );
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
      ),
    );
  }
}