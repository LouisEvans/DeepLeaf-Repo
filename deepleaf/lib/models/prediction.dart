import 'package:hive/hive.dart';

part 'prediction.g.dart';

// The Prediction model constructor
// Stores all information about a prediction result

@HiveType(typeId: 0)
class Prediction extends HiveObject {
  Prediction(
      {required this.plantName,
      required this.confidence,
      required this.image,
      required this.date,
      required this.description});

  // The name of the plant
  @HiveField(0)
  final String plantName;

  // The confidence of the prediction
  @HiveField(1)
  final double confidence;

  // The Base64-encoded image of the original scan
  @HiveField(2)
  final String image;

  // The date and time the prediction was made
  @HiveField(3, defaultValue: "")
  final String date;

  // The Wikipedia description of the plant
  @HiveField(4, defaultValue: "")
  final String description;

  // To re-generate this file, run:
  // flutter packages pub run build_runner build
}
