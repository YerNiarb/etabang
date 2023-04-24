import 'package:etabang/pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    String username = "christiandoe";
    String email = "christian@getnada.com";
    String address = "Room 123, Brooklyn St, Kepler District";

    CircleAvatar defaultAvatar = CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[300],
        child: const Text(
          'CD',
          style: TextStyle(fontSize: 24, color: Colors.white70),
        ));

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50, left: 35, right: 35),
          child: Column(
            children: [
              const Center(
                child:  Text(
                  "User Profile",
                  textAlign: TextAlign.center,  
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: defaultAvatar,
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Text(
                  "Christian Doe",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Username",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                    ),
                    Text(
                      username,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700]
                        ),
                    )
                  ]
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Email",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700]
                        ),
                    )
                  ]
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                     Text(
                      "Location",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                    )
                  ]
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.cyan,
                    ),
                    Text(
                      address,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700]
                        ),
                    )
                  ]
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 100),
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.cyan),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        minimumSize:
                            MaterialStateProperty.all<Size>(const Size(double.infinity, 20)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          const TextStyle(fontSize: 18),
                        )),
                    onPressed: () async {
                       
                    },
                    child: const Text('Save Changes')
                  ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        minimumSize:
                            MaterialStateProperty.all<Size>(const Size(double.infinity, 20)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          const TextStyle(fontSize: 18),
                        )),
                    onPressed: () async {
                       SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isFirstLogin', true);
                        await prefs.setBool('isLoggedIn', false);

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                          (route) => false,
                        );
                    },
                    child: const Text('Logout')
                  ),
              ),
            ],
          ),
        )
      ),
    );
  }
}