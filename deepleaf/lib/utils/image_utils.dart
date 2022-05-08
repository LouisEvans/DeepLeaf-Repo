import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  // Convert image from path to Base64-encoded image
  static String imageToBase64(String path) {
    // Decode
    File file = File(path);
    img.Image imgTemp = img.decodeImage(file.readAsBytesSync())!;

    // Resize
    img.Image resizedImg = img.copyResize(imgTemp, width: 200);

    // Crop to 200x200, anchored in the center
    int topBounds = (resizedImg.height - 200) ~/ 2;
    img.Image croppedImg = img.copyCrop(resizedImg, 0, topBounds, 200, 200);

    // Encode to PNG
    List<int> resizedPng = img.encodePng(croppedImg);

    // Return as base64 encoded String
    return base64Encode(resizedPng);
  }

  // Write Base64-encoded image to temporary file and return path
  static Future<String> createFileFromString(String s) async {
    Uint8List bytes = base64.decode(s);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
    await file.writeAsBytes(bytes);
    return file.path;
  }
}
