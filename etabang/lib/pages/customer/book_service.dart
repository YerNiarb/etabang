import 'package:etabang/models/booking.dart';
import 'package:etabang/models/payment_method.dart';
import 'package:etabang/pages/customer/booking_confirmed.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/service_worker.dart';
import '../common/integer_input.dart';
import 'location_selector.dart';

class BookService extends StatefulWidget {
  final ServiceWorker serviceWorker;
  final String serviceName;
  final String streetAddress;
  final double hourlyPrice;
  const BookService({super.key, required this.serviceName, required this.streetAddress, required this.hourlyPrice, required this.serviceWorker});

  @override
  State<BookService> createState() => _BookServiceState();
}

class _BookServiceState extends State<BookService> {
  int _currentStep = 1;
  String stepOneTitle = "Service";
  String stepTwoTitle = "Payment Details";
  String stepThreeTitle = "Book Now";
  String stepTitle = "Payment Details";  
  String nextButtonText = "Review Payment and Location"; 
  DateTime serviceDate = DateTime.now();
  TimeOfDay serviceTime = TimeOfDay.now();

  //Booking Details
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  Booking? _bookingDetails = null;
  double subTotal = 0.00;
  double travelFee = 25.00;
  int quantity = 1;
  TextEditingController qtyOfServiceInput = TextEditingController();

  List<PaymentMethod> paymentMethods = [
      PaymentMethod(
          id: 1,
          name: "COD",
          description: "Cash on delivery")
    ];

   void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    subTotal = widget.hourlyPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.close, color: Colors.cyan,),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stepTitle, 
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20
                        ),
                      ),
                      Text(
                        "${widget.serviceName} - ${widget.streetAddress}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey
                        ),
                      )
                    ],
                  ),
                )
              ]
            ),
            Expanded(
              child: Stepper(
                type: StepperType.horizontal,
                currentStep: _currentStep,
                onStepTapped: (step) => {
                  setState(() {
                    if(step == 0){
                      Navigator.pop(context);
                      return;
                    }

                    _currentStep = step;
                  })
                },
                controlsBuilder: (BuildContext context, ControlsDetails details) {
                  return Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.cyan),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(275, 65)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                const TextStyle(
                                    fontSize: 15, fontFamily: 'Poppins'),
                              )),
                          onPressed: () async {
                            setState(() {
                              if(_currentStep == 2){
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => BookingConfirmed(serviceWorkerName: "${widget.serviceWorker.firstName} ${widget.serviceWorker.lastName}",)),
                                );
                              }

                              if (_currentStep < 2) {
                                _currentStep += 1;

                                switch(_currentStep){
                                  case 0:
                                    nextButtonText = "";
                                    stepTitle = stepOneTitle;
                                    break;
                                  case 1:
                                    nextButtonText = "Review Payment and Location";
                                    stepTitle = stepTwoTitle;
                                    break;
                                  case 2:
                                    nextButtonText = "Book Now";
                                    stepTitle = stepThreeTitle;
                                    break;
                                }
                              }                              
                            });
                          },
                          child: Text(nextButtonText)),
                      ],
                    ),
                  );
                },
                steps: [
                  Step(
                    title: const Text('Service'),
                    content: const Text('This is Service'),
                    isActive: _currentStep >= 0,
                  ),
                  //PAYMENT
                  Step(
                    title: const Text('Payment Details'),
                    content: Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 25, 5, 25),
                                child: Row(
                                  children: [
                                    IntegerInput(
                                      initialValue: 1,
                                      minValue: 1,
                                      maxValue: 99,
                                      onChanged: (value) {
                                        setState(() {
                                          quantity = value;
                                          subTotal = (value * widget.hourlyPrice);
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        widget.serviceName,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins'
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: SizedBox(
                                        width: 70,
                                        child: Text(
                                          "₱ ${widget.hourlyPrice}/hour",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: InkWell(
                              onTap: () async {
                                DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (selectedDate != null) {
                                  setState(() {
                                    serviceDate = selectedDate;
                                  });
                                }
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 25, 5, 25),
                                  child: Row(
                                    children: [
                                       SizedBox(
                                        width: 75,
                                        child: Container(
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFE3FBFF),
                                          ),
                                          child: const Icon(
                                            Icons.calendar_month_outlined,
                                            color: Colors.cyan,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Service Date",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins'
                                              ),
                                            ),
                                            Text(
                                              DateFormat('EEEE, dd MMM yyyy').format(serviceDate),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                                color: Colors.grey
                                              ),
                                            ),
                                          ]
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        child: const SizedBox(
                                          width: 60,
                                          child: Icon(
                                            Icons.chevron_right,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: InkWell(
                              onTap: () async {
                                TimeOfDay? seletedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (seletedTime != null) {
                                  setState(() {
                                    serviceTime = seletedTime;
                                  });
                                }
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 25, 5, 25),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 75,
                                        child: Container(
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFE3FBFF),
                                          ),
                                          child: const Icon(
                                            Icons.access_time_outlined,
                                            color: Colors.cyan,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Service Time",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins'
                                              ),
                                            ),
                                            Text(
                                              serviceTime.format(context),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                                color: Colors.grey
                                              ),
                                            ),
                                          ]
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        child: const SizedBox(
                                          width: 60,
                                          child: Icon(
                                            Icons.chevron_right,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "SubTotal",
                                  style: TextStyle(
                                    fontSize: 18, 
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700]
                                  ),
                                ),
                                Text(
                                  "₱ $subTotal",
                                  style: TextStyle(
                                    fontSize: 18, 
                                    // fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700]
                                  ),
                                )
                              ]
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5, right:5, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Travel Fee",
                                  style: TextStyle(
                                    fontSize: 18, 
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700]
                                  ),
                                ),
                                Text(
                                  "₱ $travelFee",
                                  style: TextStyle(
                                    fontSize: 18, 
                                    // fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700]
                                  ),
                                )
                              ]
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5, right:5, bottom: 10),
                            child: Text(
                              "The travel fee depends on the rider and the client’s address/location.",
                              maxLines: null,
                              style: TextStyle(
                                fontSize: 15, 
                                fontFamily: 'Poppins',
                                color: Colors.grey[400]
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 1,
                  ),

                  // CHECKOUT
                  Step(
                    title: const Text('Checkout'),
                    content: Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: InkWell(
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LocationSelector()),
                                  );
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 75,
                                              child: Container(
                                                height: 40,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFFE3FBFF),
                                                ),
                                                child: const Icon(
                                                  Icons.location_on,
                                                  color: Colors.cyan,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 200,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Service Location",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Poppins'
                                                    ),
                                                  ),
                                                  Text(
                                                    _bookingDetails == null || _bookingDetails?.city == "" ? "Location not selected." : "${_bookingDetails?.floor} ${_bookingDetails?.street} ${_bookingDetails?.city}",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                      color: Colors.grey
                                                    ),
                                                  ),
                                                ]
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                              child: const SizedBox(
                                                width: 60,
                                                child: Icon(
                                                  Icons.chevron_right,
                                                  color: Colors.cyan,
                                                  size: 30,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 20),
                                          child: SizedBox(
                                            height: 150,
                                            child: GoogleMap(
                                              // onMapCreated: _onMapCreated,
                                              initialCameraPosition: const CameraPosition(
                                                target: LatLng(14.599512, 120.984222),
                                                zoom: 12.0,
                                              ),
                                              markers: _markers,
                                              mapType: MapType.normal,
                                            ),
                                          ),
                                         ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(5, 25, 5, 25),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(left: 20),
                                        child: const SizedBox(
                                          width: 200,
                                          child: Text(
                                            "Payment Method",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppins'
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 20),
                                        child: Row(
                                          children: [
                                             SizedBox(
                                              width: 75,
                                              child: Container(
                                                height: 40,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFFE3FBFF),
                                                ),
                                                child: const Icon(
                                                  Icons.wallet,
                                                  color: Colors.cyan,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 200,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: const [
                                                  Text(
                                                    "COD",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Poppins'
                                                    ),
                                                  ),
                                                  Text(
                                                    "Cash On Delivery",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                      color: Colors.grey
                                                    ),
                                                  ),
                                                ]
                                              ),
                                            ),
                                            Container(
                                              height: 30,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFFE3FBFF),
                                                ),
                                              child: const SizedBox(
                                                width: 60,
                                                child: Icon(
                                                  Icons.circle,
                                                  color: Colors.cyan,
                                                  size: 15,
                                                ),
                                              ),
                                            )
                                          ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 25, 5, 25),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(left: 20),
                                        child: const SizedBox(
                                          width: 200,
                                          child: Text(
                                            "Summary",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppins'
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${quantity}x ${widget.serviceName}",
                                              maxLines: null,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Poppins',
                                                color: Colors.grey,
                                                overflow: TextOverflow.clip
                                              ),
                                            ),
                                            Text(
                                              "₱ ${widget.hourlyPrice}",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                                overflow: TextOverflow.clip
                                              ),
                                            )
                                          ]
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top:10, left: 18, right: 18),
                                        height: 1,
                                        color: Colors.grey,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "SubTotal",
                                              maxLines: null,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Poppins',
                                                color: Colors.grey,
                                                overflow: TextOverflow.clip
                                              ),
                                            ),
                                            Text(
                                              "₱ $subTotal",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                                overflow: TextOverflow.clip
                                              ),
                                            )
                                          ]
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Travel Fee",
                                              maxLines: null,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Poppins',
                                                color: Colors.grey,
                                                overflow: TextOverflow.clip
                                              ),
                                            ),
                                            Text(
                                              "₱ $travelFee",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                                overflow: TextOverflow.clip
                                              ),
                                            )
                                          ]
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Total",
                                              maxLines: null,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Poppins',
                                                color: Colors.grey,
                                                overflow: TextOverflow.clip,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "₱ ${subTotal + travelFee}",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                                overflow: TextOverflow.clip,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    isActive: _currentStep >= 2,
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}