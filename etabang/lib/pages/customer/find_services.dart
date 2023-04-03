import 'package:flutter/material.dart';

import '../../models/service.dart';

class FindServices extends StatelessWidget {
  const FindServices({super.key});

  @override
  Widget build(BuildContext context) {
    String customerName = "Christian";
    TextEditingController textFilter = TextEditingController();
    CircleAvatar defaultAvatar = CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey[300],
        child: const Text(
          'CD',
          style: TextStyle(fontSize: 24, color: Colors.white70),
        ));

    List<Service> services = [
      Service(name: "Laundry Services", hourlyPrice: 100),
      Service(name: "Caretaker Services", hourlyPrice: 100),
      Service(name: "Plumbing Services", hourlyPrice: 100),
      Service(name: "Dishwashing Services", hourlyPrice: 100),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 10.0),
        child: Container(
          color: Colors.white,
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hi $customerName',
                        style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan,
                            fontFamily: 'Helvetica')),
                    const Text('Need help?',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0x97979797),
                            fontFamily: 'Poppins')),
                  ],
                ),
                defaultAvatar
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 40, 0, 40),
              child: TextField(
                  cursorColor: Colors.grey,
                  controller: textFilter,
                  style: const TextStyle(fontSize: 19.5, fontFamily: 'Poppins'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none
                    ),
                    hintText: 'Search',
                    hintStyle: TextStyle(fontSize: 19.5, fontFamily: 'Poppins', color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    labelStyle: const TextStyle(fontSize: 19.5, fontFamily: 'Poppins'),
                    filled: true,
                    fillColor: Colors.grey[200],
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                    )
                  )),
            ),
            SingleChildScrollView(
              child: Container(
                height: 200.0,
                color: Colors.blue,
                child: Column(
                  children: <Widget>[
                    // add your widgets here
                  ],
                ),
              )
            )
          ]),
        ),
      ),
    );
  }
}
