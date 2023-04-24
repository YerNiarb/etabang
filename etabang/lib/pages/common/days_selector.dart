import 'package:flutter/material.dart';

class DaysSelector extends StatefulWidget {
  @override
  _DaysSelectorState createState() => _DaysSelectorState();
}

class _DaysSelectorState extends State<DaysSelector> {
  final Map<String, bool> _days = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _days.keys.map((day) {
        return CheckboxListTile(
          title: Text(day),
          value: _days[day],
          onChanged: (value) {
            setState(() {
              _days[day] = value!;
            });
          },
        );
      }).toList(),
    );
  }
}
