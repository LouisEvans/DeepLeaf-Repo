import numpy as np
import cv2 as cv
from PIL import Image

# Used to perform the GrabCut algorithm on a single image

# Declare origin image and the amount of iterations to run the algorithm over
image_name = "1c95466643660a93699f11557d2357a8cc136f1a"
iterations = 5
img = cv.imread(
    r'F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/grabcut_test/'+image_name+'.jpg')

# Create mask
mask = np.zeros(img.shape[:2], np.uint8)

# Set background and foreground matrices (used internally)
bgdModel = np.zeros((1, 65), np.float64)
fgdModel = np.zeros((1, 65), np.float64)

# Set bounding rectangle
rect = (10, 10, 180, 180)

# Perform GrabCut
cv.grabCut(img, mask, rect, bgdModel,
           fgdModel, iterations, cv.GC_INIT_WITH_RECT)

# Extract foregound
mask2 = np.where((mask == 2) | (mask == 0), 0, 1).astype('uint8')
img = img*mask2[:, :, np.newaxis]
RGB_img = cv.cvtColor(img, cv.COLOR_BGR2RGB)

# Save
save_path = r'F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/grabcut_test'
im = Image.fromarray(RGB_img)
im.save(save_path+"/"+image_name+"_grabcut_"+str(iterations)+".jpg")
