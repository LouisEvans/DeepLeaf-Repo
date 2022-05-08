# DeepLeaf - TensorFlow Repository
This repository contains all the code needed to run the plant classifiers. These models were trained on the Pl@ntNet dataset (31GB), which can be found here: https://zenodo.org/record/4726653#.YhNbAOjMJPY. The folder should be placed in the directory above this one. Directories within this repository may need to be changed.

## Structure
Python files in the root directory are the core TensorFlow training scripts.

Other directories include:

 `/preprocessing` - All Python scripts used to perform image preprocessing algorithms on the dataset (Canny Edge Detection, GrabCut).
 
 `/saved_models` - Saved TFLite models.
 - `/checkpoints` - Saved epoch checkpoints
 - `/models` - Final models. Key models are 1 (original model), 4 (MVP model), and 7 (final model)
 - `/results` - CLI dumps from training
 - `/tflite` - Converted TFLite models

`/utils` - Python scripts used to perform various long-winded tasks