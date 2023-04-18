import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class WorkerTracker extends StatefulWidget {
  const WorkerTracker({super.key});

  @override
  State<WorkerTracker> createState() => _WorkerTrackerState();
}

class _WorkerTrackerState extends State<WorkerTracker> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(30),
        child: Center(
           child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
             children: [
                const Text(
                  "No appointment in progress.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Text(
                    "Please book an appointment or avail a service to get started.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
             ],
           )
        ),
      ),
    );
  }
}