import 'package:flutter/material.dart';

class IntegerInput extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final ValueChanged<int>? onChanged;

  IntegerInput({
    Key? key,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    this.onChanged,
  })  : assert(initialValue >= minValue && initialValue <= maxValue),
        super(key: key);

  @override
  _IntegerInputState createState() => _IntegerInputState();
}

class _IntegerInputState extends State<IntegerInput> {
  late TextEditingController _controller;
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _controller = TextEditingController(text: _value.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _decrement() {
    setState(() {
      _value = _value - 1;
      _controller.text = _value.toString();
      widget.onChanged?.call(_value);
    });
  }

  void _increment() {
    setState(() {
      _value = _value + 1;
      _controller.text = _value.toString();
      widget.onChanged?.call(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: _value == widget.minValue ? null : _decrement,
          child: Icon(Icons.remove),
          style: ButtonStyle(
            maximumSize: MaterialStateProperty.all(Size(25, 35)),
            minimumSize: MaterialStateProperty.all(Size(25, 35)),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            iconSize: MaterialStateProperty.resolveWith<double>((Set<MaterialState> states) {
              return 10;
            }),
             overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return const Color.fromARGB(255, 185, 235, 244);
                }
                return const Color.fromARGB(255, 185, 235, 244);
              },
            ),
            elevation: MaterialStateProperty.resolveWith<double>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return 1; // Set elevation to 6 when button is pressed
                }
                return 0; // Set default elevation to 4
              },
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey[100];
                }
                return const Color(0xFFE3FBFF); 
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey;
                }
                return Colors.cyan; 
              },
            ),
          ),
        ),
        SizedBox(
          width: 15.0,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(0),
            ),
            onChanged: (value) {
              setState(() {
                _value = int.parse(value);
                if (_value < widget.minValue) {
                  _value = widget.minValue;
                  _controller.text = _value.toString();
                } else if (_value > widget.maxValue) {
                  _value = widget.maxValue;
                  _controller.text = _value.toString();
                }
                widget.onChanged?.call(_value);
              });
            },
          ),
        ),
        ElevatedButton(
          onPressed: _value == widget.maxValue ? null : _increment,
          child: Icon(Icons.add),
          style: ButtonStyle(
            maximumSize: MaterialStateProperty.all(Size(25, 35)),
            minimumSize: MaterialStateProperty.all(Size(25, 35)),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            iconSize: MaterialStateProperty.resolveWith<double>((Set<MaterialState> states) {
              return 15;
            }),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return const Color.fromARGB(255, 185, 235, 244);
                }
                return const Color.fromARGB(255, 185, 235, 244);
              },
            ),
            elevation: MaterialStateProperty.resolveWith<double>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return 1; // Set elevation to 6 when button is pressed
                }
                return 0; // Set default elevation to 4
              },
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey[100];
                }
                return const Color(0xFFE3FBFF); 
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey;
                }
                return Colors.cyan; 
              },
            ),
          )
        ),
      ],
    );
  }
}