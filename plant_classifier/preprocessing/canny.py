import cv2 as cv
from PIL import Image

# Used for applying the Canny Edge Detection
# algorithm to a single image

# Declare image origin
origin = (r'F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/images_train_resized/1355932/0b5fe72f89cd2da8d01eabe711cbbc22e107b028.jpg')

# Read image
img = cv.imread(origin, 0)

# Apply Canny Edge Detection
edges = cv.Canny(img, 100, 200)

# Declare directory to save to
save_path = r'F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K'

# Convert to image
im = Image.fromarray(edges)

# Save to directory
im.save(save_path+"/canny.jpg")
