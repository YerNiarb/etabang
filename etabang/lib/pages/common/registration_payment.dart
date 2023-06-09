import 'package:etabang/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../connector/db_connection.dart';
import '../homepage.dart';
import '../sign_in.dart';

class RegistrationPayment extends StatelessWidget {
  const RegistrationPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(40, 50, 40, 40),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(bottom: 30),
              child: const Text(
                "Payment",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Please send an exact amount payment for registration through Gcash.",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 20,
                        color: Colors.black45
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 500,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(35)
                          ),
                          margin: const EdgeInsets.fromLTRB(0, 50, 0, 40),
                          child: Image.asset('assets/images/gcash_qr.jpg', height: 100, width: 275,),
                        ),
                      ),
                    ),
                    const Text(
                      "Please send the receipt to etabang20@gmail.com for verification of payment.",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 20,
                        color: Colors.black45
                      ),
                    ),
                  ]
                ),
              ),
            ),
            Center(
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.cyan),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(250, 60)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(fontSize:  15, fontFamily: 'Poppins'),
                    )),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String firstName = prefs.getString('loggedInUserfirstName') ?? "";
                  int? userId = prefs.getInt('loggedInUserId');

                  PostgreSQLConnection connection = await DbConnection().getConnection();

                  String query = """
                      UPDATE "Users"
                        SET "IsPaid" = true
                        WHERE "Id" = $userId;
                  """;
                  
                  final results = await connection.mappedResultsQuery(query);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WelcomePage(name: firstName)),
                    (route) => false,
                  );
                },
                child: const Text('Sign in')
              ),
            ),
          ]
        ),
      ),
    );
  }
}