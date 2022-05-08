import os
from PIL import Image
from pkgutil import extend_path

# A tool to expose corrupt images within a dataset

# Origin folder
origin = r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/flower_grabcut_dataset/val"

# Progress variable
x = 1

# For each directory in origin
for i in os.scandir(origin):

    # Track progress
    print(str(x)+"/1077")
    x += 1

    # For each image
    for image in os.scandir(i):

        # Try to open it
        try:
            Image.open(image.path)

        # If it fails, print (or remove)
        except:
            print("removing "+image.path)
            # os.remove(image.path)
