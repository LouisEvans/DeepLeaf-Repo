import tensorflow as tf
from PIL import Image
import numpy as np
from skimage import transform
import os
import cv2 as cv

# Used for converting an entire dataset to one where
# any images with flowers detected in them will have
# the GrabCut algorithm applied to them

# Set memory growth to true for all GPUs (bugfix)
gpus = tf.config.experimental.list_physical_devices('GPU')
if gpus:
    try:
        for gpu in gpus:
            tf.config.experimental.set_memory_growth(gpu, True)
        logical_gpus = tf.config.experimental.list_logical_devices('GPU')
        print(len(gpus), "Physical GPUs,", len(logical_gpus), "Logical GPUs")
    except RuntimeError as e:
        print(e)

# Declare classes
classes = ['false', 'true']

# Load model
model = tf.keras.models.load_model("saved_models/models/my_model6")

# Declare dataset origins
origins = [
    "test",
    "train",
    "val"
]

# Progress variable
iteration = 0

# For each origin (test, train, val)
for origin in origins:

    # Derive origin directory
    origin_dir = r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/images_"+origin+"_resized"

    # For each classification within origin
    for classification in os.scandir(origin_dir):

        print(str(iteration / 292000)+"%")
        # Get all original images in classification folder
        images = [file for file in os.listdir(
            classification.path) if file.endswith(('jpeg', 'png', 'jpg'))]

        # For each original image
        for image in images:

            iteration += 1

            # Open image and resize
            open_image = Image.open(classification.path+"/"+image)
            img = np.array(open_image).astype('float32')/255
            img = transform.resize(img, (200, 200, 3))
            img = np.expand_dims(img, axis=0)

            # Make prediction
            prediction = model.predict(img)

            # Extract label
            v, i = tf.nn.top_k(prediction, k=1)
            p_index = i.numpy()[0][0]
            p_class = classes[p_index]

            # If there is a plant in the image...
            if(p_class == 'true'):

                # Read the image
                img = cv.imread(classification.path+"/"+image)

                # Create mask
                mask = np.zeros(img.shape[:2], np.uint8)

                # Set background and foreground matrices (used internally)
                bgdModel = np.zeros((1, 65), np.float64)
                fgdModel = np.zeros((1, 65), np.float64)

                # Set bounding rectangle
                rect = (10, 10, 180, 180)

                # Perform GrabCut
                cv.grabCut(img, mask, rect, bgdModel,
                           fgdModel, 5, cv.GC_INIT_WITH_RECT)

                # Extract foregound
                mask2 = np.where((mask == 2) | (
                    mask == 0), 0, 1).astype('uint8')
                img = img*mask2[:, :, np.newaxis]
                RGB_img = cv.cvtColor(img, cv.COLOR_BGR2RGB)
                im = Image.fromarray(RGB_img)

                # Get new path
                classification_dir = os.path.basename(
                    os.path.normpath(classification.path))  # eg. 1718287
                save_path = r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/flower_grabcut_dataset/" + \
                    origin+"/" + classification_dir

                # If path doesn't exist, create it
                if not os.path.isdir(save_path):
                    os.mkdir(save_path)

                # Save
                im.save(save_path + "/" + image, optimize=True, quality=40)
            else:
                # Get new path
                classification_dir = os.path.basename(
                    os.path.normpath(classification.path))  # eg. 1718287
                save_path = r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/flower_grabcut_dataset/" + \
                    origin+"/" + classification_dir

                # If path doesn't exist, create it
                if not os.path.isdir(save_path):
                    os.mkdir(save_path)

                # Save
                open_image.save(save_path + "/" + image,
                                optimize=True, quality=40)
