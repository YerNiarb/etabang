import 'package:flutter/material.dart';

class Messaging extends StatefulWidget {
  const Messaging({super.key});

  @override
  State<Messaging> createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(30),
        child: Center(
           child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
             children: const [
                Text(
                  "No messages to display.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
                ),
             ],
           )
        ),
      ),
    );
  }
}