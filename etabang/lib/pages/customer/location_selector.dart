import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationSelector extends StatefulWidget {
  @override
  _LocationSelectorState createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  late GoogleMapController _mapController;
  late LatLng _selectedLocation = const LatLng(14.599512, 120.984222);
  final Set<Marker> _markers = {};
  late final TextEditingController _cityController = TextEditingController();
  late bool _isCityFound = false;
  late final TextEditingController _streetController = TextEditingController();
  late final TextEditingController _floorController = TextEditingController();
  // final TextEditingController _searchController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _onLocationSelected(LatLng location) async {
      _getLocationPermission();
      
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(_selectedLocation.latitude, _selectedLocation.longitude);
        Placemark place = placemarks[0];
        setState(() {
          _selectedLocation = location;
          _markers.clear();
          _markers.add(
            Marker(
              markerId: MarkerId('Selected Location'),
              position: _selectedLocation,
            ),
          );
          _cityController.text = place.locality ?? '';
          if(place.locality != null){
            _isCityFound = true;
          }
          _streetController.text = place.street ?? '';
          _floorController.text = '';
        });
      } catch (e) {
         setState(() {
          _selectedLocation = location;
          _markers.clear();
          _markers.add(
            Marker(
              markerId: MarkerId('Selected Location'),
              position: _selectedLocation,
            ),
          );
          _cityController.text = '';
          _isCityFound = false;
          _streetController.text = '';
          _floorController.text = '';
        });
      }
  }

  Future<LatLng> _initializeLocation() async {
     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if(position == null){
        return const LatLng(14.599512, 120.984222);
      }

      return LatLng(position.longitude, position.longitude);
  }

  @override
  void initState() {
    super.initState();
    _cityController.text = "";
    _isCityFound = false;
     _initializeLocation().then((location) {
      // Set the state when the initialization is complete.
      setState(() {
        _selectedLocation = location;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.cyan,),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    "Select Location", 
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20
                    ),
                  )
                ]
              ),
            ),
            // Container(
            //   color: Colors.white,
            //   child: TextField(
            //     controller: _searchController,
            //     decoration: InputDecoration(
            //       hintText: "Search location",
            //       prefixIcon: Icon(Icons.search),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10.0),
            //         borderSide: BorderSide.none,
            //       ),
            //     ),
            //     onSubmitted: (value) async {
            //       List<Location> locations = await locationFromAddress(value);
            //       if (locations.length > 0) {
            //         Location location = locations[0];
            //         _selectedLocation = LatLng(location.latitude!, location.longitude!);
            //         setState(() {
            //           _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            //             target: _selectedLocation,
            //             zoom: 14.0,
            //           )));
            //           _markers.clear();
            //           _markers.add(Marker(
            //             markerId: MarkerId(_selectedLocation.toString()),
            //             position: _selectedLocation,
            //           ));
            //         });
            //       }
            //     },
            //   ),
            // ),
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(14.599512, 120.984222),
                  zoom: 12.0,
                ),
                markers: _markers,
                mapType: MapType.normal,
                onTap: _onLocationSelected,
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _cityController,
                    enabled: !_isCityFound,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 15.0, fontFamily: 'Poppins')
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _streetController,
                    decoration: const InputDecoration(
                      labelText: 'Street',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 15.05, fontFamily: 'Poppins')
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _floorController,
                    decoration: const InputDecoration(
                      labelText: 'Floor',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 15.0, fontFamily: 'Poppins')
                  ),
                  const SizedBox(height: 10.0,),
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.cyan),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          minimumSize:
                              MaterialStateProperty.all<Size>(Size(275, 65)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                                fontSize: 15, fontFamily: 'Poppins'),
                          )),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: const Text("Set Location")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getLocationPermission() async {
    if (await Permission.location.request().isGranted) {
      // Permission is granted
    } else {
      // Permission is not granted
      await _handleInvalidPermissions();
    }
  }

  Future<void> _handleInvalidPermissions() async {
    final PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus == PermissionStatus.denied) {
      // Permission denied
      // Show dialog to prompt the user to grant permission
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      // Permission permanently denied
      // Show dialog to prompt the user to go to app settings
    } else if (permissionStatus == PermissionStatus.restricted) {
      // Permission restricted
      // Show dialog to prompt the user to go to app settings
    }
  }
}
