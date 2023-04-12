import 'package:flutter/material.dart';

class BookService extends StatefulWidget {
  final String serviceName;
  final String streetAddress;
  const BookService({super.key, required this.serviceName, required this.streetAddress});

  @override
  State<BookService> createState() => _BookServiceState();
}

class _BookServiceState extends State<BookService> {
  

  @override
  Widget build(BuildContext context) {
    int _currentStep = 1;
    String stepOneTitle = "Service";
    String stepTwoTitle = "Payment Details";
    String stepThreeTitle = "Checkout";
    String stepTitle = "Payment Details";

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
                controlsBuilder: (BuildContext context, ControlsDetails details) {
                  return Row(
                    children: <Widget>[
                      TextButton(
                        onPressed: details.onStepContinue,
                        child: const Text('NEXT'),
                      ),
                      // TextButton(
                      //   onPressed: details.onStepCancel,
                      //   child: const Text('CANCEL'),
                      // ),
                    ],
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
                    content: const Text('This is the content of Step 2'),
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