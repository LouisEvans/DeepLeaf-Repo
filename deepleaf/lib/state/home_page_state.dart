import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:deepleaf/const.dart';
import 'package:deepleaf/models/prediction.dart';
import 'package:deepleaf/utils/image_utils.dart';
import 'package:deepleaf/widgets/result_panel.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tflite/tflite.dart';
import 'package:native_opencv/native_opencv.dart';

class HomePageState extends ChangeNotifier {
  // Is currently scanning?
  bool scanning = false;

  // Current scanned image path
  String scannedImagePath = "";

  // Has finished scanning?
  bool finishedScanning = false;

  // Slide up panel contents
  Widget panelContents = Container();

  // Hive storage box
  late Box<Prediction> box;

  // Opening Hive storage box
  bool openingBox = true;

  // Initialise Hive storage
  void init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PredictionAdapter());
    box = await Hive.openBox<Prediction>('predictions');
    getRecentPredictions();
    openingBox = false;
    notifyListeners();
    reset();
  }

  // Predict plant from image
  Future scanImage(XFile file, double vpW) async {
    scanning = true;
    finishedScanning = false;
    scannedImagePath = file.path;
    notifyListeners();

    // If flower is in image, perform GrabCut
    if (await isFlower(scannedImagePath)) {
      scannedImagePath = await grabCut(scannedImagePath);
    }

    // Load model
    String? res = await Tflite.loadModel(
        model: "assets/finalmodel.tflite",
        labels: "assets/labels.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false);
    if (res != null) {
      // Convert to base64 and get file path
      String image = ImageUtils.imageToBase64(scannedImagePath);
      String path = await ImageUtils.createFileFromString(image);

      // Run model
      var recognitions = await Tflite.runModelOnImage(
          path: path,
          imageMean: 127.5,
          imageStd: 127.5,
          numResults: 5,
          threshold: 0.05, // defaults to 0.1
          asynch: true);
      print("All recognitions: " + recognitions.toString());

      // Get plant name
      String plantName = recognitions![0]['label']
          .toString()
          .split(' ')[1]
          .replaceAll('_', ' ');

      // Get Wikipedia description (if online)
      String description = await getDescription(plantName);

      // Save prediction object
      Prediction prediction = Prediction(
          plantName: plantName,
          confidence: recognitions![0]['confidence'],
          image: ImageUtils.imageToBase64(scannedImagePath),
          date: DateTime.now().toString(),
          description: description);
      savePrediction(prediction);

      // Reset
      scanning = false;
      finishedScanning = true;
      panelContents = ResultPanel(prediction: prediction, vpW: vpW);
      notifyListeners();
    } else {
      print("Res is null");
      reset();
    }
  }

  // Check if a distinguishable flower exists in the photo
  Future<bool> isFlower(String imagePath) async {
    // Load TFLite model
    String? res = await Tflite.loadModel(
        model: "assets/flowermodel.tflite",
        labels: "assets/flowerlabels.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false);

    // Convert to Base64 String and get path
    String image = ImageUtils.imageToBase64(imagePath);
    String path = await ImageUtils.createFileFromString(image);

    // Run model
    var recognitions = await Tflite.runModelOnImage(
        path: path,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 1,
        threshold: 0.5, // defaults to 0.1
        asynch: true);
    print("All recognitions: " + recognitions.toString());

    // Return true (yes there is) or false (no there isn't)
    return (recognitions![0]['label'] == 'true');
  }

  // Run GrabCut on image from path
  Future<String> grabCut(String imagePath) async {
    // Create output path
    String outputPath = imagePath.replaceAll(".jpg", "_grabcut.jpg");

    // Run GrabCut then wait for result
    processImage(imagePath, outputPath);
    Future.delayed(Duration(seconds: 2), () {});

    // Return output path
    return outputPath;
  }

  // Reset variables to default
  void reset() {
    scanning = false;
    finishedScanning = false;
    scannedImagePath = "";
    panelContents = Container();
    notifyListeners();
  }

  // Save prediction to local storage
  void savePrediction(Prediction prediction) {
    box.add(prediction);
  }

  // Close box
  void closeBox() async {
    await box.close();
  }

  // Empty box
  void clearBox() async {
    await box.clear();
    getRecentPredictions();
  }

  // Get all predictions from Hive local storage
  List<Prediction> recentPredictions = [];
  void getRecentPredictions() {
    recentPredictions = box.values.toList();
    notifyListeners();
  }

  // Get plant descriptions from Wikipedia API
  Future<String> getDescription(String title) async {
    try {
      // Construct URI
      Uri uri = Uri.parse(WIKIPEDIA_URL + title);

      // Call HTTP
      var response = await http.get(
        uri,
      );

      // Decode response
      Map<String, dynamic> responseDecoded = jsonDecode(response.body);

      // Extract description and return
      Map<String, dynamic> pages = responseDecoded['query']['pages'];
      String first = "";
      for (String key in pages.keys) {
        if (first == "") {
          first = key;
        }
      }
      return pages[first]['extract'];
    } catch (e) {
      // If HTTP failed, return empty String
      return "";
    }
  }
}
