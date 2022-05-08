import 'dart:convert';

import 'package:deepleaf/models/prediction.dart';
import 'package:deepleaf/utils/confidence_text.dart';
import 'package:deepleaf/utils/date_utils.dart';
import 'package:flutter/material.dart';

// Widget on Previous Scans page displaying a prediction
class PredictionPreview extends StatelessWidget {
  const PredictionPreview({Key? key, required this.prediction})
      : super(key: key);

  final Prediction prediction;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(prediction.plantName,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    ConfidenceText(confidence: prediction.confidence),
                    Text(" confidence",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
                Text(MyDateUtils.parseDate(prediction.date),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff9d9d9d)))
              ],
            ),
            Image.memory(
              base64Decode(prediction.image),
              width: 90,
              height: 90,
            )
          ],
        ),
      ),
    );
  }
}
