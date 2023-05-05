import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:etabang/pages/common/registration_payment.dart';
import 'package:etabang/pages/common/terms_and_conditions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:etabang/enums/user_type.dart';
import 'package:etabang/pages/sign_in.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';

import '../connector/db_connection.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  UserType userType = UserType.customer;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  DateTime birthdate = DateTime.now();
  bool isLoading = false;
  TextEditingController birthdateController = TextEditingController();
  late LatLng currentLocation;
  List<int> staffServices = [];

  final List<File> _selectedFiles = [];

  Future<void> _openFileExplorer() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );
    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.files.map((file) => File(file.path ?? "")));
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  Widget _buildSelectedFilesList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _selectedFiles.length,
      itemBuilder: (context, index) {
        final file = _selectedFiles[index];
        return ListTile(
          leading: const Icon(Icons.file_copy),
          title: Text(file.path.split('/').last),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _removeFile(index),
          ),
        );
      },
    );
  }

  Future<void> _registerUser() async {
    try {
      PostgreSQLConnection connection = await DbConnection().getConnection();

      String insertUserQuery = """ 
        INSERT INTO public."Users"(
          "FirstName", "LastName", "Password", "PhoneNumber", "BirthDate", "UserType", "CurrentLocation", "Username")
          VALUES (
            '${firstName.text}', 
            '${lastName.text}', 
            '${password.text}',
            '${phoneNumber.text}', 
            '$birthdate',
            ${userType.index}, 
            ST_Point(${currentLocation.latitude}, ${currentLocation.longitude}),
            '${userName.text}'
          )
        RETURNING "Id";
      """;

      final insertResult = await connection.mappedResultsQuery(insertUserQuery);
      final newUserId = insertResult[0];
      final userId = newUserId.values.first["Id"];

      if(_selectedFiles.isNotEmpty){
        for (var file in _selectedFiles) {
          final bytes = await File(file.path).readAsBytes();
          final fileBase64 = base64Encode(bytes);
          final fileName = file.path.split('/').last;

          String insertUserDocumentQuery = """ 
            INSERT INTO public."UserDocuments"
              ("UserId", "Document", "FileType", "FileName", "FileSize")
              VALUES($userId, '$fileBase64', '${fileName.split('.').last}', '$fileName', '${file.lengthSync()}')
          """;

          await connection.mappedResultsQuery(insertUserDocumentQuery);
        }
      }

      if(userType == UserType.staff){
        generateStaffServices();
        if(staffServices.isNotEmpty){
          for (var serviceId in staffServices) {
            String insertUserDocumentQuery = """ 
              INSERT INTO public."StaffServices"
                ("ServiceId", "StaffId")
                VALUES($serviceId, $userId)
            """;

            await connection.mappedResultsQuery(insertUserDocumentQuery);
        
          }
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      } );
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to connect to the database: $e'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }
  }

  generateStaffServices(){
    var rng = Random();
    var lengths = [1, 2, 3, 4]; // set the desired lengths here
    List<int> result = [];

    for (var i = 0; i < lengths.length; i++) {
      for (var j = 0; j < lengths[i]; j++) {
        var value = rng.nextInt(3) + 1;
        if(!result.contains(value)) {
          result.add(value);
        }
      }
    }

    setState(() {
      staffServices = result;
    });
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
    _initializeLocation().then((location) {
      // Set the state when the initialization is complete.
      setState(() {
        currentLocation = location;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(30, 100, 30, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child:  const Text('Let\'s Create\nYour Account!',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Helvetica')
                    ),
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: userType == UserType.staff ? Colors.cyan : Colors.white70,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: TextButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                              minimumSize:
                                  MaterialStateProperty.all<Size>(const Size(160, 60)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                const TextStyle(fontSize:  15, fontFamily: 'Poppins'),
                              )),
                          onPressed: () {
                            setState(() {
                              userType = UserType.staff;
                            });
                          },
                          icon: const Icon(Icons.group_outlined),
                          label: const Text('Staff')
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: userType == UserType.customer ?  Colors.cyan : Colors.white70,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: TextButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                              minimumSize:
                                  MaterialStateProperty.all<Size>(const Size(160, 60)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                const TextStyle(fontSize:  15, fontFamily: 'Poppins'),
                              )),
                          onPressed: () {
                            setState(() {
                              userType = UserType.customer;
                            });
                          },
                          icon: const Icon(Icons.person_outline),
                          label: const Text('Customer')
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'First Name',
                        style: TextStyle(
                              fontSize:  15,
                              fontFamily: 'Poppins'
                        )
                      ),
                      TextField(
                        controller: firstName,
                        style: const TextStyle(
                              fontSize:  15,
                              fontFamily: 'Poppins'
                        ),
                        cursorColor: Colors.cyan,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                          ),
                        )
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Last Name',
                        style: TextStyle(
                              fontSize:  15,
                              fontFamily: 'Poppins'
                        )
                      ),
                      TextField(
                        controller: lastName,
                        style: const TextStyle(
                              fontSize:  15,
                              fontFamily: 'Poppins'
                        ),
                        cursorColor: Colors.cyan,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                          ),
                        )
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Phone Number',
                        style: TextStyle(
                              fontSize:  15,
                              fontFamily: 'Poppins'
                        )
                      ),
                      TextField(
                        controller: phoneNumber,
                        style: const TextStyle(
                              fontSize:  15,
                              fontFamily: 'Poppins'
                        ),
                        cursorColor: Colors.cyan,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                          ),
                        )
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(
                              fontSize:  15,
                              fontFamily: 'Poppins'
                        )
                      ),
                      TextField(
                        controller: userName,
                        style: const TextStyle(
                              fontSize:  15,
                              fontFamily: 'Poppins'
                        ),
                        cursorColor: Colors.cyan,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                          ),
                        )
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Password',
                        style: TextStyle(
                              fontSize:  15,
                              fontFamily: 'Poppins'
                        )
                      ),
                      TextField(
                        controller: password,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        style: const TextStyle(
                              fontSize:  15,
                              fontFamily: 'Poppins',
                        ),
                        cursorColor: Colors.cyan,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                          ),
                        )
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Birthdate',
                        style: TextStyle(
                              fontSize:  15,
                              fontFamily: 'Poppins'
                        )
                      ),
                      TextField(
                        controller: birthdateController,
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              birthdate = selectedDate;
                              birthdateController.text = DateFormat('dd MMM yyyy').format(selectedDate);
                            });
                          }
                        },
                        style: const TextStyle(
                              fontSize:  15,
                              fontFamily: 'Poppins',
                        ),
                        cursorColor: Colors.cyan,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                          ),
                        )
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      userType == UserType.customer ? 
                        'Valid ID:':
                        'Valid ID, Police Clearance, Professional Certificate (optional):',
                      style: const TextStyle(
                            fontSize:  15,
                            fontFamily: 'Poppins'
                      )
                    ),
                    const SizedBox(height: 18,),
                    InkWell(
                      onTap: _openFileExplorer,
                      child: Container(
                        color: const Color.fromARGB(255, 245, 245, 245),
                        padding: const EdgeInsets.all(15),
                        height: 130,
                        width: double.infinity,
                        child: Column(
                          children: const [
                            Icon(
                              Icons.upload_file, 
                              color: Color.fromARGB(108, 0, 187, 212),
                              size: 50,
                            ),
                            Text(
                              "Browse files",
                              style: TextStyle(
                                fontSize:  15,
                                fontFamily: 'Poppins',
                                color: Colors.black87
                              )
                            ),
                            Text(
                              "Images only, up to 5 MB",
                              style: TextStyle(
                                fontSize:  13,
                                fontFamily: 'Poppins',
                                color: Colors.grey
                              )
                            )
                          ],
                        ),

                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 50),
                      // height: 120,
                      child:  SizedBox(
                        height: 120,
                        child: _selectedFiles.isEmpty
                            ? const Center(child: Text('No files selected.'),)
                            : _buildSelectedFilesList(),
                      ),
                    ),
                  ],
                ),

                Center(
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        minimumSize: MaterialStateProperty.all<Size>(const Size(250, 60)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          const TextStyle(fontSize:  15, fontFamily: 'Poppins'),
                        )),
                    onPressed: isLoading? null :() async {
                      setState(() {
                        isLoading = true;
                      });
                      if(userName.text.isNotEmpty && password.text.isNotEmpty){
                        await _registerUser().then((value) => {
                          //  if(userType == UserType.customer){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignIn()),
                            )
                          // }else{
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => const RegistrationPayment()),
                          //   )
                          // }
                        }); 
                      }
                      else{
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Enter required fields.'),
                          ),
                        );
                      }
                    },
                    child: isLoading? const CircularProgressIndicator(color: Colors.white,) : const Text('Sign Up')
                  ),
                ),

                isLoading ? const SizedBox(height: 10,) : 
                  Center(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'By clicking Sign Up, you agree to our',
                            style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    color: Color(0x97979797),
                              )
                          ),
                          GestureDetector(
                            onTap: () async{
                              if(firstName.text.isNotEmpty && lastName.text.isNotEmpty){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TermsAndConditions(name: "${firstName.text} ${lastName.text}", userType: userType, isViewOnly: true,)),
                                );
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Enter your name to view Terms and Agreement.'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Terms and Agreement',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ), 

                isLoading ? const SizedBox(height: 10,) : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  color: Color(0x97979797),
                            )
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignIn()),
                            );
                          },
                          child: const Text('Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        )
                      ],
                    ),
              ), 
            ]
          )
        ),
      )
    );
  }
}