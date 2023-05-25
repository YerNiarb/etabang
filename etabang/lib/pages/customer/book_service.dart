import 'package:etabang/enums/booking_status.dart';
import 'package:etabang/models/booking.dart';
import 'package:etabang/models/payment_method.dart';
import 'package:etabang/pages/customer/booking_confirmed.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../connector/db_connection.dart';
import '../../enums/payment_options.dart';
import '../../models/service_worker.dart';
import '../../models/user_location.dart';
import '../common/integer_input.dart';
import 'location_selector.dart';

class BookService extends StatefulWidget {
  final ServiceWorker serviceWorker;
  final String serviceName;
  final String streetAddress;
  final double hourlyPrice;
  final int serviceId;
  const BookService({super.key, required this.serviceName, required this.streetAddress, required this.hourlyPrice, required this.serviceWorker, required this.serviceId});

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
  int? userId;
  double? userLat;
  double? userLng;
  bool isLoading = false;

  //Booking Details
  late GoogleMapController _mapController;
  bool _isMapCreated = false;
  final Set<Marker> _markers = {};

  late Booking _bookingDetails;
  TextEditingController qtyOfServiceInput = TextEditingController();

  List<PaymentMethod> paymentMethods = [
      PaymentMethod(
          id: 1,
          name: "COD",
          description: "Cash on delivery")
    ];

  void _onMapCreated(GoogleMapController controller) {
    if (!_isMapCreated) {
      _mapController = controller;
      _isMapCreated = true;
    }
  }

  void _initBookingDetails(){
    setState(() {
      _bookingDetails = Booking(
        serviceId: widget.serviceId,
        subTotal: widget.hourlyPrice,
        travelFee: 25.00,
        numberOfHours:  1, 
        bookingDate:  DateTime.now(),
        bookingTime: TimeOfDay.now()
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _initBookingDetails();
    _initializeLocation();
  }

  Future<void> _loadPreferences() async {
    await Future.delayed(Duration.zero);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() {
      userId = prefs.getInt('loggedInUserId');
      userLat = prefs.getDouble('currentLat');
      userLng = prefs.getDouble('currentLng');
    });
  }

  Future<LatLng> _initializeLocation() async {
    double? lat = userLat;
    double? lng = userLng;

    if(lat == null && lng == null){
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // ignore: unnecessary_null_comparison
      if(position == null){
        lat = 14.599512;
        lng = 120.984222;
      }else{
        lat = position.latitude;
        lng = position.longitude;
      }
    }

    LatLng userLocation = LatLng(lat!, lng!);

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];
      setState(() {
        // _selectedLocation = location;
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('Selected Location'),
            position: userLocation,
          ),
        );
        _bookingDetails.city = place.locality ?? "";
        _bookingDetails.street = place.street ?? "";
        _bookingDetails.state = place.subAdministrativeArea ?? "";
        _bookingDetails.latLong = userLocation;

      });
    } catch (e) {
       setState(() {
        _bookingDetails.latLong = null;
        _markers.clear();
        _bookingDetails.city = "";
        _bookingDetails.street = "";
        _bookingDetails.state = "";
      });
    }

    if(_isMapCreated){
      setState(() {
        _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: userLocation,
          zoom: 14.0,
        )));
        
        _markers.clear();
        _markers.add(Marker(
          markerId: MarkerId(userLocation.toString()),
          position: userLocation,
        ));
      
      });
    }
    
    return userLocation;
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
                  icon: const Icon(Icons.close, color: Colors.cyan,),
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
                            if (_currentStep == 2) {
                              try {
                                PostgreSQLConnection connection = await DbConnection().getConnection();
                                String query = """
                                  INSERT INTO public."Bookings"(
                                    "StaffId", "CustomerId", "ServiceId", "Quantity", "SubTotal", "TravelFee", 
                                    "ServiceLocation", "Street", "City", "State", "Status", "PaymentOption", "Date", "Time")
                                    VALUES (
                                      ${widget.serviceWorker.id}, 
                                      $userId, 
                                      ${widget.serviceId}, 
                                      ${_bookingDetails.numberOfHours}, 
                                      ${double.parse(_bookingDetails.subTotal.toStringAsFixed(2))}, 
                                      ${double.parse(_bookingDetails.travelFee.toStringAsFixed(2))}, 
                                      ST_Point(${_bookingDetails.latLong!.latitude}, ${_bookingDetails.latLong!.longitude}), 
                                      '${_bookingDetails.street}', 
                                      '${_bookingDetails.city}',
                                      '${_bookingDetails.state}',
                                      ${BookingStatus.booked.index},
                                      ${PaymentOption.cod.index},
                                      '${DateFormat('yyyy-MM-dd').format(_bookingDetails.bookingDate)}',
                                      '${_bookingDetails.bookingTime.hour}:${_bookingDetails.bookingTime.minute}:00'
                                    );
                                """;

                                final insertResult = await connection.mappedResultsQuery(query);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Success.'),
                                    backgroundColor: Colors.cyan,
                                  ),
                                );

                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookingConfirmed(
                                            serviceWorkerName:
                                                "${widget.serviceWorker.firstName} ${widget.serviceWorker.lastName}",
                                          )),
                                );
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                } );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Unable place booking.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                            }

                            setState(() {
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
                    content: SingleChildScrollView(
                      child: Container(
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
                                            _bookingDetails.numberOfHours = value;
                                            _bookingDetails.subTotal = (value * widget.hourlyPrice);
                                          });
                                        },
                                      ),
                                      Flexible(
                                        child: SizedBox(
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
                                      _bookingDetails.bookingDate = selectedDate;
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
                                        Flexible(
                                          child: SizedBox(
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
                                                  DateFormat('EEEE, dd MMM yyyy').format(_bookingDetails.bookingDate),
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
                                      _bookingDetails.bookingTime = seletedTime;
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
                                        Flexible(
                                          child: SizedBox(
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
                                                  _bookingDetails.bookingTime.format(context),
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
                                    "₱ ${_bookingDetails.subTotal}",
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
                                    "₱ ${_bookingDetails.travelFee}",
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
                    ),
                    isActive: _currentStep >= 1,
                  ),

                  // CHECKOUT
                  Step(
                    title: const Text('Checkout'),
                    content: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 25),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: InkWell(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LocationSelector()
                                      ),
                                    );
                    
                                    if(result != null){
                                      UserLocation selectedLocation = result as UserLocation;
                                      setState(() {
                                        _bookingDetails.latLong = LatLng(selectedLocation.lat, selectedLocation.lng);
                                        _bookingDetails.street = selectedLocation.street;
                                        _bookingDetails.city = selectedLocation.city;
                                        _bookingDetails.state = selectedLocation.state;
                                      });
                                    }
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
                                              Flexible(
                                                child: SizedBox(
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
                                                        _bookingDetails == null || 
                                                          _bookingDetails.latLong == null ? "Location not selected." : "${_bookingDetails.street}, ${_bookingDetails.city}, ${_bookingDetails.state}",
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
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 5),
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
                                          StatefulBuilder(
                                            builder: (BuildContext context, StateSetter setState) {
                                              return Container(
                                                margin: const EdgeInsets.only(top: 20),
                                                child: SizedBox(
                                                  height: 150,
                                                  child: GoogleMap(
                                                    onMapCreated: _onMapCreated,
                                                    initialCameraPosition: CameraPosition(
                                                      target: _bookingDetails.latLong == null ? const LatLng(14.599512, 120.984222) : _bookingDetails.latLong!,
                                                      zoom: 12.0,
                                                    ),
                                                    markers: _markers,
                                                    mapType: MapType.normal,
                                                  ),
                                                ),
                                              );
                                            }
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
                                          margin: const EdgeInsets.only(top: 20),
                                          child: Row(
                                            children: [
                                               Flexible(
                                                 child: SizedBox(
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
                                                "${_bookingDetails.numberOfHours}x ${widget.serviceName}",
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
                                                "₱ ${_bookingDetails.subTotal}",
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
                                                "₱ ${_bookingDetails.travelFee}",
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
                                                "₱ ${_bookingDetails.subTotal + _bookingDetails.travelFee}",
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