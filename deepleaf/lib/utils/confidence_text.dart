import 'package:flutter/material.dart';

// Text in either red, amber or green depending on confidence value
class ConfidenceText extends StatelessWidget {
  const ConfidenceText({Key? key, required this.confidence}) : super(key: key);

  final double confidence;

  final int RED = 60; // Anything below this is red
  final int AMBER = 80; // Anything above RED and below this is amber
  // Anything above AMBER is green

  Color getColor() {
    if (confidence * 100 < RED) {
      return const Color(0xffEE4040);
    } else if (confidence * 100 < AMBER) {
      return const Color(0xffEE8940);
    } else {
      return const Color(0xff1EBE4B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text((confidence * 100).toInt().toString() + "%",
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 14, color: getColor()));
  }
}
