import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

import '../common/integer_input.dart';

class BookService extends StatefulWidget {
  final String serviceName;
  final String streetAddress;
  const BookService({super.key, required this.serviceName, required this.streetAddress});

  @override
  State<BookService> createState() => _BookServiceState();
}

class _BookServiceState extends State<BookService> {
  int _currentStep = 1;
  String stepOneTitle = "Service";
  String stepTwoTitle = "Payment Details";
  String stepThreeTitle = "Checkout";
  String stepTitle = "Payment Details";  
  String nextButtonText = "Review Payment and Location";

  double subTotal = 0.00;
  double travelFee = 25.00;
  TextEditingController qtyOfServiceInput = new TextEditingController();

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
                onStepContinue: () {
                  setState(() {
                    if (_currentStep < 2) {
                      _currentStep += 1;
                    }
                  });
                },
                onStepCancel: () {
                  setState(() {
                    if (_currentStep > 0) {
                      _currentStep -= 1;
                    }
                  });
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
                                  Size(275, 65)),
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
                            // SharedPreferences prefs =
                            //     await SharedPreferences.getInstance();
                            // await prefs.setBool('isFirstLogin', false);
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => Homepage()),
                            // );
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
                  Step(
                    title: const Text('Payment Details'),
                    content: SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                IntegerInput(
                                  initialValue: 1,
                                  minValue: 1,
                                  maxValue: 99,
                                  onChanged: (value) {
                                    // Handle value changed
                                  },
                                )
                                // NumberInputPrefabbed.squaredButtons(
                                //   onChanged: (value) {
                                //     // Handle value changed
                                //   },
                                //   controller: qtyOfServiceInput,
                                //   min: 1,
                                //   max: 100,
                                //   incIcon: Icons.add,
                                //   decIcon: Icons.remove,
                                // )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                    isActive: _currentStep >= 1,
                  ),
                  Step(
                    title: const Text('Checkout'),
                    content: const Text('This is the content of Step 3'),
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

// class PaymentDetailsForm extends StatefulWidget {
//   const PaymentDetailsForm({super.key});

//   @override
//   State<PaymentDetailsForm> createState() => _PaymentDetailsFormState();
// }

// class _PaymentDetailsFormState extends State<PaymentDetailsForm> {
//   double subTotal = 0.00;
//   double travelFee = 25.00;
//   TextEditingController qtyOfServiceInput = new TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 500,
//       width: 400,
//       child: Column(
//         children: [
//           Card(
//             child: Row(
//               children: [
//                 NumberInputPrefabbed.squaredButtons(
//                   onChanged: (value) {
//                     // Handle value changed
//                   },
//                   controller: qtyOfServiceInput,
//                   min: 1,
//                   max: 100,
            
//                   incIcon: Icons.add,
//                   decIcon: Icons.remove,
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }