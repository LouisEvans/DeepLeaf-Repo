import numpy as np
import cv2 as cv
from PIL import Image
import os

# Used to perform both the GrabCut and Canny Edge Detection
# algorithms on a dataset and save as new dataset

# Declare origin directories
origins = [
    r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/images_test_resized",
    r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/images_train_resized",
    r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/images_val_resized"
]

# Progress variables
x = 0
percent = 0

# For each origin (test, train, val)
for origin in origins:

    # For each classification within origin
    for classification in os.scandir(origin):

        # Track progress
        tempPercent = x/3240
        if(int(tempPercent) > percent):
            percent = tempPercent
            print(str(x)+"/3240, "+str(x/3240)+"%")
        x += 1

        # Get all original images in classification folder
        images = [file for file in os.listdir(
            classification.path) if file.endswith(('jpeg', 'png', 'jpg'))]

        # For each original image
        for image in images:

            # Open image
            img = cv.imread(classification.path+"/"+image)

            # Create mask
            mask = np.zeros(img.shape[:2], np.uint8)

            # Set background and foreground matrices (used internally)
            bgdModel = np.zeros((1, 65), np.float64)
            fgdModel = np.zeros((1, 65), np.float64)

            # Set bounding rectangle
            rect = (50, 50, 450, 290)

            # Perform GrabCut
            cv.grabCut(img, mask, rect, bgdModel,
                       fgdModel, 5, cv.GC_INIT_WITH_RECT)

            # Extract foregound
            mask2 = np.where((mask == 2) | (mask == 0), 0, 1).astype('uint8')
            img = img*mask2[:, :, np.newaxis]

            # Canny edge detection
            edges = cv.Canny(img, 100, 200)
            im = Image.fromarray(edges)

            # Get new path
            classification_dir = os.path.basename(
                os.path.normpath(classification.path))  # eg. 1718287
            save_path = origin + "_grabcut_canny/" + classification_dir

            # If path doesn't exist, create it
            if not os.path.isdir(save_path):
                os.mkdir(save_path)

            # Save
            im.save(save_path + "/" + image, optimize=True, quality=40)
