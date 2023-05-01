import 'package:etabang/global/vars.dart';
import 'package:etabang/pages/common/registration_payment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../enums/user_type.dart';

class TermsAndConditions extends StatelessWidget {
  String name;
  UserType userType;
  bool isViewOnly;
  TermsAndConditions({super.key, required this.name, required this.userType, this.isViewOnly = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(40, 50, 40, 40),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: const Center(
                child: Text(
                  "Terms and Conditions",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      userType == UserType.customer ? 
                        customerTermsAndConditions.replaceAll("{_NAME}", name).replaceAll("{_DATE}", DateFormat('MMM dd, yyyy').format(DateTime.now())) :
                        staffTermsAndConditions.replaceAll("{_NAME}", name).replaceAll("{_DATE}", DateFormat('MMM dd, yyyy').format(DateTime.now())),
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 20,
                        color: Colors.black45
                      ),
                    ),
                    
                    if(isViewOnly)
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
                        onPressed :() async {
                          Navigator.pop(context);
                        },
                        child: const Text('Back')
                      ),
                    ),

                    if(!isViewOnly)
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
                        onPressed :() async {
                          // Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegistrationPayment()),
                          );
                        },
                        child: const Text('Continue')
                      ),
                    ),
                  ]
                ),
              ),
            )
          ]
        ),
      ),
    );
  }
}
