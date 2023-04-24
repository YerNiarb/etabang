import 'package:etabang/pages/homepage.dart';
import 'package:etabang/pages/sign_up.dart';
import 'package:etabang/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../connector/db_connection.dart';
import '../connector/db_connector.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late DbConnector dbConnector;

  TextEditingController userName = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbConnector = DbConnector();
    dbConnector.connect();
  }

  @override
  void dispose() {
    dbConnector.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.fromLTRB(50, 40, 50, 0),
        child: SingleChildScrollView(
          child: Column(
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
                            fontSize:  15,
                            fontFamily: 'Poppins'
                      )
                    ),
                    TextField(
                      controller: userName,
                      style: const TextStyle(
                            fontSize:  15,
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
                            fontSize:  15,
                            fontFamily: 'Poppins'
                      )
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      style: const TextStyle(
                            fontSize:  15,
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
                  if(userName.text.isNotEmpty && passwordController.text.isNotEmpty){  
                    try {
                      PostgreSQLConnection connection = await DbConnection().getConnection();
                      String query = """ 
                        SELECT "Id", "FirstName", "LastName", "Username", "Password", "UserType", "City", "State", "Street"
                          FROM public."Users"
                          WHERE "Username"='${userName.text}'
                          LIMIT 1;
                      """;

                      final result = await connection.mappedResultsQuery(query);
                      
                      if(result.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Username or password is incorrect'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }else{
                        final user = result[0];
                        var userId = user.values.first["Id"];
                        String? firstname = user.values.first["FirstName"].toString();
                        String? lastname = user.values.first["LastName"];
                        String? username = user.values.first["Username"];
                        String? password = user.values.first["Password"];
                        String? city = user.values.first["City"];
                        String? state = user.values.first["State"];
                        String? street = user.values.first["Street"];
                        var userType = user.values.first["UserType"];

                        //check password
                        if(passwordController.text == password){
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isLoggedIn', true);
                          bool isFirstTime = prefs.getBool('isFirstLogin') ?? true;

                          await prefs.setString('loggedInUserfirstName', firstname);
                          await prefs.setString('loggedInUserlastName', lastname ?? "");
                          await prefs.setInt('loggedInUserId', userId);
                          await prefs.setInt('loggedInUserType', userType);

                          if (isFirstTime) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WelcomePage(name: firstname)),
                                (route) => false,
                              );
                          } else {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const Homepage()),
                              (route) => false,
                            );
                          }
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid username or password'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enter username or password'),
                          backgroundColor: Colors.red,
                        ),
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
        ),
      )
    );
  }
}