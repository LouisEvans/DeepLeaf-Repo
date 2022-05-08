from PIL import Image
import os

# Used to downscale an entire dataset and save
# as a new one

# Declare origin directories
origins = [
    r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/images_test",
    r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/images_train",
    r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/images_val"
]

# For each origin (test, train, val)
for origin in origins:

    # For each classification within origin
    for classification in os.scandir(origin):

        # Get all original images in classification folder
        images = [file for file in os.listdir(
            classification.path) if file.endswith(('jpeg', 'png', 'jpg'))]

        # For each original image
        for image in images:

            # Open image
            img = Image.open(classification.path+"/"+image)

            # Resize
            img.thumbnail((200, 200))

            # Get new path
            classification_dir = os.path.basename(
                os.path.normpath(classification.path))  # eg. 1718287
            save_path = origin + "_resized/" + classification_dir

            # If path doesn't exist, create it
            if not os.path.isdir(save_path):
                os.mkdir(save_path)

            # Save
            img.save(save_path + "/" + image, optimize=True, quality=40)
