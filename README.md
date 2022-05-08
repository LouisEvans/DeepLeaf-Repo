# DeepLeaf
This repository contains all the code for my final dissertation titled "DeepLeaf: Automatic Plant Identification using Convolutional Neural Networks". 

NOTE: 13 files needed to be removed in order to upload this repository to GitHub, as the file limit was exceeded. These files include all TensorFlow models, TFLite models, and the OpenCV framework. These files are accessible via request.

Student ID `680023224`.
| ![Camera / Home](https://i.imgur.com/595VyKP.jpg) | ![History](https://i.imgur.com/ydMhjwv.png) | ![Result](https://i.imgur.com/i0m6Jgo.jpg) |
|--|--|--|

## Structure
Further information about each directory can be found in that directory's README.

 - `/deepleaf` - The Flutter repository. The frontend of the application.
 - `/native_opencv` - A Flutter plugin using OpenCV to expose the GrabCut algorithm's functionality
 - `/plant_classifier` - A Python repository using TensorFlow to train a CNN to classify plants