import cv2 as cv
from PIL import Image
import os

# Used for converting a dataset to one with the
# Canny Edge Detection algorithm applied to it

# Origin directories
origins = [
    r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/images_test_resized",
    r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/images_train_resized",
    r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/images_val_resized"
]

# Progress variables
iteration = 0
percent = 0

# For each origin (test, train, val)
for origin in origins:

    # For each classification within origin
    for classification in os.scandir(origin):

        # Get all original images in classification folder
        images = [file for file in os.listdir(
            classification.path) if file.endswith(('jpeg', 'png', 'jpg'))]

        # For each original image
        for image in images:

            # Tracking progress
            tempPercent = iteration/3240
            if(int(tempPercent) > percent):
                percent = tempPercent
                print(str(iteration)+"/3240, "+str(iteration/3240)+"%")
            iteration += 1

            # Open image
            img = cv.imread(classification.path+"/"+image)

            # Canny edge detection
            edges = cv.Canny(img, 100, 200)
            im = Image.fromarray(edges)

            # Get new path
            classification_dir = os.path.basename(
                os.path.normpath(classification.path))  # eg. 1718287
            save_path = origin + "_canny/" + classification_dir

            # If path doesn't exist, create it
            if not os.path.isdir(save_path):
                os.mkdir(save_path)

            # Save
            im.save(save_path + "/" + image, optimize=True, quality=40)
