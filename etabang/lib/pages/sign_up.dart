import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:etabang/enums/user_type.dart';
import 'package:etabang/pages/sign_in.dart';
import 'package:intl/intl.dart';

import '../global/vars.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  UserType userType = UserType.customer;

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

  @override
  Widget build(BuildContext context) {
    TextEditingController fullName = TextEditingController();
    TextEditingController userName = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController phoneNumber = TextEditingController();
    DateTime birthdate = DateTime.now();
    TextEditingController birthdateController = TextEditingController();

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
                        'Full Name',
                        style: TextStyle(
                              fontSize:  15,
                              fontFamily: 'Poppins'
                        )
                      ),
                      TextField(
                        controller: fullName,
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
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
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
                      height: 120,
                      child:  Expanded(
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
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.cyan),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        minimumSize:
                            MaterialStateProperty.all<Size>(const Size(250, 60)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          const TextStyle(fontSize:  15, fontFamily: 'Poppins'),
                        )),
                    onPressed: () {
                      if(userName.text.isNotEmpty && password.text.isNotEmpty){
                        isLoggedIn = true;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignIn()),
                        );
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Enter required fields.'),
                          ),
                        );
                      }
                    },
                    child: const Text('Sign Up')
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
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
              ) 
            ]
          )
        ),
      )
    );
  }
}