# DeepLeaf - Flutter App
This repository contains the code for the application layer of the DeepLeaf project. 

NOTE: 13 files needed to be removed in order to upload this repository to GitHub, as the file limit was exceeded. These files include all TensorFlow models, TFLite models, and the OpenCV framework. These files are accessible via request.

| ![Camera / Home](https://i.imgur.com/595VyKP.jpg) | ![History](https://i.imgur.com/ydMhjwv.png) | ![Result](https://i.imgur.com/i0m6Jgo.jpg) |
|--|--|--|

## How to run
 1. Ensure Flutter is [installed](https://docs.flutter.dev/get-started/install) on your computer and added to your PATH. 
 2. Ensure you either have an emulator (Android Studio AVD settings) or a physical phone attached to your computer.
 3. Ensure that the `/native_opencv` repository is located in the same directory as the root of the `/deepleaf` repository
 4. While inside the `/deepleaf` directory, type `flutter run --no-sound-null-safety`.

## How to use

 1. Take a photo by tapping the 🪴 button at the bottom of the screen. Alternatively, scan a photo from your gallery by tapping the gallery button in the bottom-right.
 2. Receive a result!
 3. To view previous scans, swipe left

## Updating `native_opencv`
In order to see changes in the `native_opencv` plugin reflected in the `deepleaf` project, follow these steps:

 1. Save all changes in `native_opencv`
 2. Inside the `/deepleaf` directory, run `flutter packages get`
 3. If currently running DeepLeaf, quit (`CTRL-C`) then run `flutter run --no-sound-null-safety` again.