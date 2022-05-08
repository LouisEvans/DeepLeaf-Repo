import cv2 as cv
from PIL import Image

# Used to perform the Canny Edge Detection algorithm
# on a single image

# Read image
img = cv.imread(r'F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/images_train_resized/1355978/0ba4c53b2245e1d065c86ddecf1dcf7a8bd0bb2a.jpg', 0)

# Perform Canny Edge Detection
edges = cv.Canny(img, 100, 400)

# Save image
save_path = r'F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/canny_test'
im = Image.fromarray(edges)
im.save(save_path+"/1355978_0ba4c53b2245e1d065c86ddecf1dcf7a8bd0bb2a_canny_100_400.jpg")
