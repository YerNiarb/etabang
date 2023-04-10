import 'package:etabang/pages/common/drawer.dart';
import 'package:etabang/pages/customer/view_service_worker_details.dart';
import 'package:flutter/material.dart';
import '../../global/vars.dart';
import '../../models/service_worker.dart';
import '../homepage.dart';

class FindWorkers extends StatelessWidget {
  const FindWorkers({super.key});

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

    List<ServiceWorker> availableWorkers = [
      ServiceWorker(
          firstName: 'John',
          lastName: 'Doe',
          city: 'Polomolok',
          state: 'South Cotabato',
          street: '1103 Champaca St.',
          userName: 'john2424',
          hourlyPrice: 100),
      ServiceWorker(
          firstName: 'Katherine',
          lastName: 'Doe',
          city: 'Polomolok',
          state: 'South Cotabato',
          street: '1103 Champaca St.',
          userName: 'john2424',
          hourlyPrice: 100),
      ServiceWorker(
          firstName: 'Jesse',
          lastName: 'Doe',
          city: 'Polomolok',
          state: 'South Cotabato',
          street: '1103 Champaca St.',
          userName: 'john2424',
          hourlyPrice: 100),
      ServiceWorker(
          firstName: 'Stephen',
          lastName: 'Doe',
          city: 'Polomolok',
          state: 'South Cotabato',
          street: '1103 Champaca St.',
          userName: 'john2424',
          hourlyPrice: 100),
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
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Homepage()),
                        );
                      },
                    )
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
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Workers available",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Helvetica'))
                  ]),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                padding: EdgeInsets.all(5.0),
                children: List.generate(availableWorkers.length, (index) {
                  return InkWell(
                     onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewServiceWorkerDetails(serviceWorker: availableWorkers[index])),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                width: 160,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                  image: DecorationImage(
                                    image: AssetImage(availableWorkers[index].profileImageUrl ?? defaulProfileImageUrl),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  )),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                                child: Text(
                                  availableWorkers[index].firstName,
                                  textAlign: TextAlign.left,
                                  maxLines: null,
                                  style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(8.0, 0, 0, 1),
                                child: Text(
                                  '1000 km away',
                                  textAlign: TextAlign.left,
                                  maxLines: null,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: Color(0x97979797),
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                            ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
