# Native OpenCV (GrabCut only)
This repository contains the code for the application layer of the `native_opencv` Flutter plugin. This plugin currently only exposes the GrabCut function.

NOTE: 13 files needed to be removed in order to upload this repository to GitHub, as the file limit was exceeded. These files include all TensorFlow models, TFLite models, and the OpenCV framework. These files are accessible via request.

| ![Original](https://i.imgur.com/2wybpac.jpg) | ![GrabCut](https://i.imgur.com/9PAEOZ9.jpg) |
|--|--|

## Install
Add the plugin to your Flutter dependencies in your `pubspec.yaml` like so:
```
dependencies:
    native_opencv:
	    path: ../native_opencv
```
Where `../native_opencv` corresponds to the root directory of this plugin.

To import, use: `import  'package:native_opencv/native_opencv.dart';`

## GrabCut
To use GrabCut: 
`String outputPath = await grabCut(inputImagePath);`

## Credit
https://medium.com/flutter-community/integrating-c-library-in-a-flutter-app-using-dart-ffi-38a15e16bc14