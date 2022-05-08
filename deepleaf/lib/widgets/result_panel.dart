import 'dart:convert';

import 'package:deepleaf/models/prediction.dart';
import 'package:deepleaf/utils/confidence_text.dart';
import 'package:flutter/material.dart';

// Slide Up Panel content builder from Prediction object
class ResultPanel extends StatelessWidget {
  const ResultPanel({Key? key, required this.prediction, required this.vpW})
      : super(key: key);

  final Prediction prediction;
  final double vpW;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: vpW,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(base64Decode(prediction.image)))),
                ),
                Container(
                  width: vpW,
                  height: 200,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                        Colors.black.withOpacity(0.66),
                        Colors.black.withOpacity(0)
                      ])),
                ),
                Positioned(
                    bottom: 30,
                    left: 30,
                    child: Container(
                      width: vpW - 50,
                      child: Text(
                        prediction.plantName,
                        style: TextStyle(
                            color: Colors.white, fontSize: 42, height: 0.98),
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Row(
                children: [
                  ConfidenceText(confidence: prediction.confidence),
                  Text(" confidence"),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: Text(prediction.description))
          ],
        ),
      ),
    );
  }
}
