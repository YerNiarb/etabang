import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final int starCount;
  final double rating;
  final Color color;
  final double size;

  StarRating({this.starCount = 5, this.rating = 0.0, this.color = Colors.yellow, this.size = 5.0});

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  @override
 Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(widget.starCount, (index) {
        return Icon(
          index < widget.rating.floor() ? Icons.star : Icons.star_border,
          color: Color(0xFFFEA41D),
          size: widget.size,
        );
      }),
    );
  }
}