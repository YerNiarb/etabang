import 'package:flutter/material.dart';

class FindServices extends StatelessWidget {
  const FindServices({super.key});

  @override
  Widget build(BuildContext context) {
    String customerName = "Christian";
    AssetImage assetImage = AssetImage("assets/images/default-profile.png");

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 10.0),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        'Hi $customerName',
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                          fontFamily: 'Helvetica')
                      ),
                      
                      const Text(
                        'Need help?',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0x97979797),
                          fontFamily: 'Poppins')
                      ),
                        
                    ],
                  ),
                  CircleAvatar(
                    backgroundImage: assetImage,
                    radius: 30,
                  )
                ],
              )
            ]
          ),
        ),
      ),
    );
  }
}