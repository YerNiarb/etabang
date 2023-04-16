import 'package:etabang/models/service_worker.dart';
import 'package:etabang/pages/customer/book_service.dart';
import 'package:flutter/material.dart';
import '../../global/vars.dart';
import '../common/star_rating.dart';

class ViewServiceWorkerDetails extends StatefulWidget {
  final ServiceWorker serviceWorker;
  const ViewServiceWorkerDetails({super.key, required this.serviceWorker});

  @override
  _ServiceWorkerDetails createState() => _ServiceWorkerDetails();
}

class _ServiceWorkerDetails extends State<ViewServiceWorkerDetails> {
  bool _imageLoaded = true;
  double kilometersAway = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                // Profile Picture
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      _imageLoaded
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                              width: double.infinity,
                              height: 275,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      widget.serviceWorker.profileImageUrl ?? ""),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  onError: (exception, stackTrace) {
                                    setState(() {
                                      _imageLoaded = false;
                                    });
                                  },
                                ),
                                color: Colors.black12,
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                              width: double.infinity,
                              height: 275,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(defaulProfileImageUrl),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  onError: (exception, stackTrace) {
                                    setState(() {
                                      _imageLoaded = false;
                                    });
                                  },
                                ),
                                color: Colors.black12,
                              )),
                      //Buttons
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 60, 0, 0),
                        alignment: Alignment.bottomLeft,
                        child: FloatingActionButton(
                          heroTag: "navigateback",
                          elevation: 0,
                          backgroundColor: Colors.grey[200],
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.chevron_left),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 60, 10, 0),
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          heroTag: "bookmark",
                          elevation: 0,
                          backgroundColor: Colors.grey[200],
                          onPressed: () {
                            // Handle button 1 tap
                          },
                          child: Icon(Icons.bookmark_outline),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //Service Worker Details
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                        "${widget.serviceWorker.firstName} ${widget.serviceWorker.lastName}",
                        style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins')),
                    const Spacer(),
                    Container(
                      alignment: Alignment.center,
                      child: Row(children: [
                        Text("₱ ${widget.serviceWorker.hourlyPrice}",
                            style: const TextStyle(fontSize: 23)),
                        const Text(" / hour",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              color: Colors.grey,
                            )),
                      ]),
                    )
                  ]),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                    child: Text("Housekeeping",
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                        )),
                  ),
                  StarRating(
                    starCount: 5,
                    rating: 3.5,
                    color: const Color(0xFFFEA41D),
                    size: 25.0,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                        ),
                        Text("${kilometersAway} km away",
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              color: Colors.grey,
                            )),
                      ],
                    ),
                  ),
      
                  // ---------- ADDRESS
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: const Text("Address",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins')),
                    
                  ),
      
                   Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text("${widget.serviceWorker.street},",
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                        )),
                    
                  ),
      
                   Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                        "${widget.serviceWorker.city}, ${widget.serviceWorker.state}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                        )),
                    
                  ),
      
                  // ---------- SERVICES
      
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: const Text("Services",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins')),
                    
                  ),
      
                  Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(13.0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: const Text(
                          'Caretaker Services',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(13.0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: const Text(
                          'Laundry Services',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(13.0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: const Text(
                          'Plumbing Services',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(13.0),
                        decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                        child: const Text(
                          'Dishwashing Services',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
      
                  // ---------- Working Day | Hours
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: const Text("Working Day | Hours",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins')),
                    
                  ),
      
                   Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text("${widget.serviceWorker.street},",
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                        )),
                    
                  ),
      
                   Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                        "Monday - Friday, 8:30am - 7:30pm",
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                        )),
                    
                  ),

                  // ---------- Feedbacks
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: const Text("Feedbacks",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins')),
                    
                  ),

                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(25),
                    child: const Text("No feedbacks.",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontFamily: 'Poppins')),
                    
                  ),

                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 35, 0, 35),
                    child: TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.cyan),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(double.infinity, 65)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              const TextStyle(
                                  fontSize: 18, fontFamily: 'Poppins'),
                            )),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BookService(
                              serviceName: "Dishwashing Service", 
                              streetAddress: widget.serviceWorker.street, 
                              hourlyPrice: widget.serviceWorker.hourlyPrice,)
                            ),
                          );
                        },
                        child: const Text('Book Now')),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
