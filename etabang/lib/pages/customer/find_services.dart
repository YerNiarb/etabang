import 'package:etabang/pages/customer/find_workers.dart';
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
      Service(
          name: "Laundry Services",
          hourlyPrice: 100,
          imageUrl: 'assets/images/services/caretaker.jfif'),
      Service(
          name: "Caretaker Services",
          hourlyPrice: 100,
          imageUrl: 'assets/images/services/caretaker.jfif'),
      Service(
          name: "Plumbing Services",
          hourlyPrice: 100,
          imageUrl: 'assets/images/services/caretaker.jfif'),
      Service(
          name: "Dishwashing Services",
          hourlyPrice: 100,
          imageUrl: 'assets/images/services/caretaker.jfif'),
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
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 50),
              child: TextField(
                  cursorColor: Colors.grey,
                  controller: textFilter,
                  style: const TextStyle(fontSize: 19.5, fontFamily: 'Poppins'),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none),
                      hintText: 'Search',
                      hintStyle: TextStyle(
                          fontSize: 19.5,
                          fontFamily: 'Poppins',
                          color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      labelStyle: const TextStyle(
                          fontSize: 19.5, fontFamily: 'Poppins'),
                      filled: true,
                      fillColor: Colors.grey[200],
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)))),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              alignment: Alignment.centerLeft,
              child: const Text("What are you looking for?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Helvetica')),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FindWorkers()),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 10, 30, 10),
                              width: 80,
                              height: 90,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image: AssetImage(services[index].imageUrl),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  )),
                            ),
                            Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                height: 100,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        services[index].name,
                                        textAlign: TextAlign.center,
                                        maxLines: null,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins'),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: Colors.lightBlue[50],
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                            ),
                                            child: const Text(
                                              '₱',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.cyan),
                                            ),
                                          ),
                                          Text(
                                            '${services[index].hourlyPrice} / hour',
                                            textAlign: TextAlign.center,
                                            maxLines: null,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Color(0x97979797),
                                                fontFamily: 'Poppins'),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
